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
  function test () public {
    //usdt decimals 6
    uint256 _amount0 = 10000000;
    uint256 _amount1 = 10;
    
    //address on real net
    address USDT = 0xdac17f958d2ee523a2206206994597c13d831ec7;
    address WETH = 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2;
    address RACA = 0x12bb890508c125661e03b09ec06e404bc9289040;
    
    bytes memory _executionData = abi.encode([
      USDT,
      WETH,
      RACA,
      USDT
    ]);

    bytes memory _data = abi.encode(USDT, _amount0, USDT, 0, _executionData);
    uniswapV2Call(
      address('0x03EF36C4A2ad9f53616a32Bf5C41510ee0c06237'),
      _amount0, 
      _amount1, 
      _data);
  }
}