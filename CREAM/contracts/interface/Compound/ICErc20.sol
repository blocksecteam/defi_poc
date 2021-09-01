pragma solidity >=0.5.0;

import "./ICToken.sol";

interface ICErc20 is ICToken {
    function liquidateBorrow(
        address borrower,
        uint256 repayAmount,
        address cTokenCollateral
    ) external returns (uint256);
}
