// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "hardhat/console.sol";
import "./UniswapV3Flash.sol";

contract UniswapV3FlashTest {

    // mainnet
    // address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    // address constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    //testnet
    address constant WETH = 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6;
    address constant USDC = 0x07865c6E87B9F70255377e024ace6630C1Eaa37F;

    uint24 constant POOL_FEE = 3000;

    uint amount = 0;

    IWETH private weth = IWETH(WETH);
    IERC20 private usdc = IERC20(USDC);

    UniswapV3Flash private uni = new UniswapV3Flash(USDC, WETH, POOL_FEE);

    event Flash(uint, uint);
    event Deposit(uint);

    function setUp() public {}

    function test () public pure returns (uint) {
        uint a = 256;

        return a;
    }

    function deposit () external payable {
        amount = msg.value;
        weth.deposit{value: amount}();
        weth.approve(address(uni), amount);
    }

    function testFlash() public returns (uint256) {

        uint balBefore = weth.balanceOf(address(this));
        uni.flash(0, 100 * amount);
        uint balAfter = weth.balanceOf(address(this));

        uint fee = balBefore - balAfter;

        emit Flash(fee, amount);
        
        return fee;
    }
}
