// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import './BaseSwapperV2.sol';
import './UniswapV2Swap.sol';

contract TriangularSwapper is BaseSwapperV2 {
  
  event TriangularSwap(address, uint256, address, uint256);

  function execute(
      address _borrowAsset,
      uint256 _borrowAmount,
      address _repayAsset,
      uint256 _repayAmount,
      bytes memory _executionData
  ) internal virtual override {

    (address[] memory path) = abi.decode(_executionData, (address[]));

    require(path[0] == _borrowAsset, "borrow asset is not same path 0!");
    
    emit TriangularSwap(_borrowAsset, _borrowAmount, _repayAsset, _repayAmount);
    UniswapV2Swap uniswap = new UniswapV2Swap();

    uniswap.triangularArbitrage(path, _borrowAmount);
  }
  function test () public returns(uint) {
    //usdt decimals 6
    uint256 _amount0 = 10000000;
    uint256 _amount1 = 10;
    
    //address on real net
    // address USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    // address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    // address RACA = 0x12BB890508c125661E03b09EC06E404bc9289040;

    //testnet
    address WETH = 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6;
    address DAI = 0x11fE4B6AE13d2a6055C8D9cF65c55bac32B5d844;
    address USDC = 0x07865c6E87B9F70255377e024ace6630C1Eaa37F;
    
    bytes memory _executionData = abi.encode([
      WETH,
      DAI,
      USDC,
      WETH
    ]);

    bytes memory _data = abi.encode(WETH, _amount0, WETH, 0, _executionData);
    
    return 256;
    // this.uniswapV2Call(
    //   address(0x03EF36C4A2ad9f53616a32Bf5C41510ee0c06237),
    //   _amount0, 
    //   _amount1, 
    //   _data);
    // bytes memory _executionData = abi.encode([
    //   USDT,
    //   WETH,
    //   RACA,
    //   USDT
    // ]);

    // bytes memory _data = abi.encode(USDT, _amount0, USDT, 0, _executionData);
    
    // this.uniswapV2Call(
    //   0x03EF36C4A2ad9f53616a32Bf5C41510ee0c06237,
    //   _amount0, 
    //   _amount1, 
    //   _data);
  }
}