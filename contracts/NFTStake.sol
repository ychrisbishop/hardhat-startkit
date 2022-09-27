// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "hardhat/console.sol";

import "./RandomAPE.sol";
import "./RewardToken.sol";

interface IRewardToken is IERC20 {
    function mint(address to, uint256 amount) external;
}

contract NFTStake is Ownable {
    uint256 public stakedTotal;
    uint256 public stakingStartTime;
    uint256 constant stakingTime = 180 seconds;
    uint256 constant token = 10e18;

    struct Staker {
        uint256[] tokenIds;
        mapping(uint256 => uint256) tokenStakingCoolDown;
        uint256 balance;
        uint256 rewardsReleased;
    }

    mapping(address => Staker) public stakers;
    mapping(uint256 => address) public tokenOwner;
    bool public tokensClaimable;
    bool initialised;

    event Staked(address owner, uint256 amount);

    event Unstaked(address owner, uint256 amount);

    event RewardPaid(address indexed user, uint256 amount);

    event ClaimableStatusUpdated(bool status);

    event EmergencyUnstake(address indexed user, uint256 tokenid);

    IERC721 nft;
    // IRewardToken rewardsToken;
    RewardToken rewardsToken;

    constructor () {
        nft = new RandomAPE();
        rewardsToken = new RewardToken();
    }
    function initStaking() public onlyOwner {
        require(!initialised, "Already initialised");

        stakingStartTime = block.timestamp;
        initialised = true;    
    }
    function setTokensClaimable(bool _enabled) public onlyOwner {
        tokensClaimable = _enabled;
        emit ClaimableStatusUpdated(_enabled);
    }
    function getStakedTokens (address _user) public view returns (uint256[] memory tokenIds) {
        return stakers[_user].tokenIds;
    }
    function stake(uint256 tokenId) public {
        _stake(msg.sender, tokenId);
    }
    function stakeBatch(uint256[] memory tokenIds) public {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            _stake(msg.sender, tokenIds[i]);
        }
    }
    function _stake(address _user, uint256 _tokenId) internal {
        require(initialised, "Staking system: the staking has not started;");
        require(
            nft.ownerOf(_tokenId) == _user,
            "user must be the owner of the token"
        );

        Staker storage staker = stakers[_user];
        staker.tokenIds.push(_tokenId);
        staker.tokenStakingCoolDown[_tokenId] = block.timestamp;
        tokenOwner[_tokenId] = _user;
        nft.approve(address(this), _tokenId);
        nft.safeTransferFrom(_user, address(this), _tokenId);

        emit Staked(_user, _tokenId);
        stakedTotal++;
    }
    function _unstake(address _user, uint256 _tokenId) internal {
        require(
            tokenOwner[_tokenId] == _user,
            "NFT Staking system: user must be the owner of the staked nft"
        );

        Staker storage staker = stakers[_user];

        uint256 lastIndex = staker.tokenIds.length - 1;
        uint256 lastIndexKey = staker.tokenIds[lastIndex];

        if (staker.tokenIds.length > 0) {
            staker.tokenIds.pop();
        }
        staker.tokenStakingCoolDown[_tokenId] = 0;
        if (staker.balance == 0) {
            delete stakers[_user];
        }

        delete tokenOwner[_tokenId];

        nft.safeTransferFrom(address(this), _user, _tokenId);

        emit Unstaked(_user, _tokenId);
        stakedTotal--;
    }

    function updateReward(address _user) public {

        Staker storage staker = stakers[_user];
        uint256[] storage ids = staker.tokenIds;

        uint256 length = ids.length;
        for(uint256 i = 0; i < length; i++) {
            uint256 tokenId = ids[i];
            if (
                staker.tokenStakingCoolDown[ids[i]] <
                block.timestamp + stakingTime &&
                staker.tokenStakingCoolDown[ids[i]] > 0
            ) {
                uint256 stakedDays = ((block.timestamp - uint(staker.tokenStakingCoolDown[tokenId]))) / stakingTime;
                uint256 partialTime = ((block.timestamp - uint(staker.tokenStakingCoolDown[tokenId]))) % stakingTime;

                staker.balance += token * stakedDays;

                staker.tokenStakingCoolDown[tokenId] = block.timestamp + partialTime;

                console.logUint(staker.tokenStakingCoolDown[tokenId]);
                console.logUint(staker.balance);
            }

        }
    }

    function claimReward(address _user) public {
        require(tokensClaimable == true, "Tokens cannot be claimed yet");
        require(stakers[_user].balance > 0, "0 rewards yet");

        stakers[_user].rewardsReleased += stakers[_user].balance;
        stakers[_user].balance = 0;
        rewardsToken.mint(_user, stakers[_user].balance);

        emit RewardPaid(_user, stakers[_user].balance);
    }
}
