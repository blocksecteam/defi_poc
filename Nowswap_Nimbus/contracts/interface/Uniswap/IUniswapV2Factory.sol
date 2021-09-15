// https://uniswap.org/docs/v2/smart-contracts/factory/
// https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2Factory.solimplementation
// SPDX-License-Identifier: MIT
// UniswapV2Factory is deployed at 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f on the Ethereum mainnet, and the Ropsten, Rinkeby, Görli, and Kovan testnets
pragma solidity >=0.5.0;

interface IUniswapV2Factory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);
}
