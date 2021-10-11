// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0;

interface ICompoundPriceOracle {
    function getUnderlyingPrice(address cToken) external view returns (uint256);
}