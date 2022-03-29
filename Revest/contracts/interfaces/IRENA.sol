// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

interface IRENA {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function WETH() external view returns (address);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function balanceOf(address account) external view returns (uint256);

    function callerRewardDivisor() external view returns (uint16);

    function changeCallerRewardDivisor(uint16 callerRewardDivisor_) external;

    function changeFeeDivisor(uint16 feeDivisor_) external;

    function changeMinRebalancerAmount(uint256 minimumRebalanceAmount_)
        external;

    function changeRebalalncerDivisor(uint16 rebalancerDivisor_) external;

    function changeRebalanceInterval(uint256 interval_) external;

    function claim() external view returns (address);

    function decimals() external view returns (uint8);

    function decreaseAllowance(address spender, uint256 subtractedValue)
        external
        returns (bool);

    function feeDistributor() external view returns (address);

    function feeDivisor() external view returns (uint16);

    function increaseAllowance(address spender, uint256 addedValue)
        external
        returns (bool);

    function lastRebalance() external view returns (uint256);

    function lpStaking() external view returns (address);

    function minimumRebalanceAmount() external view returns (uint256);

    function name() external view returns (string memory);

    function owner() external view returns (address);

    function rebalance() external;

    function rebalanceInterval() external view returns (uint256);

    function rebalancer() external view returns (address);

    function rebalancerDivisor() external view returns (uint16);

    function renaFactory() external view returns (address);

    function renaRouter() external view returns (address);

    function renounceOwnership() external;

    function setClaim(address claim_) external;

    function setFeeDistributor(address feeDistributor_) external;

    function setRebalancer(address rebalancer_) external;

    function setRenaRouter(address renaRouter_) external;

    function setUniRouter(address uniRouter_) external;

    function setlpStaking(address lpStaking_) external;

    function symbol() external view returns (string memory);

    function toggleFeeless(address addr_) external;

    function totalSupply() external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    function transferOwnership(address newOwner) external;

    function treasury() external view returns (address);

    function uniFactory() external view returns (address);

    function uniPair() external view returns (address);

    function uniRouter() external view returns (address);
}