// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Math Library
library Math {
    /// @notice Absolute difference between x and y
    function abs(uint256 x, uint256 y) internal pure returns (uint256) {
        return x >= y ? x - y : y - x;
    }
}