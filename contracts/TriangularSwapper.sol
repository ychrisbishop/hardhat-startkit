// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import './BaseSwapperV2.sol';

contract TriangularSwapper is BaseSwapperV2 {
  function execute(
      address _borrowAsset,
      uint256 _borrowAmount,
      address _repayAsset,
      uint256 _repayAmount,
      bytes memory _executionData
  ) internal virtual override {
    
  }
}