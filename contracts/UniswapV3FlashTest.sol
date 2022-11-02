// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// import "forge-std/Test.sol";
// import "forge-std/console.sol";

import "hardhat/console.sol";
import "./UniswapV3Flash.sol";

contract UniswapV3FlashTest {
    // mainnet
    // address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    // address constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    //testnet
    address constant WETH = 0x0Bb7509324cE409F7bbC4b701f932eAca9736AB7;
    address constant USDC = 0xd35CCeEAD182dcee0F148EbaC9447DA2c4D449c4;

    uint24 constant POOL_FEE = 3000;

    IWETH private weth = IWETH(WETH);
    IERC20 private usdc = IERC20(USDC);

    UniswapV3Flash private uni = new UniswapV3Flash(USDC, WETH, POOL_FEE);

    event Flash(uint, uint);

    function setUp() public {}

    function testFlash() public pure returns (uint) {
        // Approve WETH fee
        // uint256 amount = 1e16;
        // weth.deposit{value: amount}();
        // weth.approve(address(this), amount);
        // uint256 allowance = weth.allowance(msg.sender, address(this));
        
        // console.log(allowance);
        // weth.transferFrom(msg.sender, address(this), amount);
        // weth.approve(address(uni), amount);

        // uint balBefore = weth.balanceOf(address(this));
        // uni.flash(0, 100 * amount);
        // uint balAfter = weth.balanceOf(address(this));

        // uint fee = balBefore - balAfter;
        // console.log("WETH fee", fee);
        uint fee = 100;
        // emit Flash(allowance, fee);
        // return allowance;
        return fee;
        // return (allowance, fee);
    }
}
