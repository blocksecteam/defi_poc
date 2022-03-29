// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2;

interface IRevest {
    struct FNFTConfig {
        address asset;
        address pipeToContract;
        uint256 depositAmount;
        uint256 depositMul;
        uint256 split;
        uint256 depositStopTime;
        bool maturityExtension;
        bool isMulti;
        bool nontransferrable;
    }

    event FNFTAddionalDeposited(
        address indexed from,
        uint256 indexed newFNFTId,
        uint256 indexed quantity,
        uint256 amount
    );
    event FNFTAddressLockMinted(
        address indexed asset,
        address indexed from,
        uint256 indexed fnftId,
        address trigger,
        uint256[] quantities,
        FNFTConfig fnftConfig
    );
    event FNFTMaturityExtended(
        address indexed from,
        uint256 indexed fnftId,
        uint256 indexed newExtendedTime
    );
    event FNFTSplit(
        address indexed from,
        uint256[] indexed newFNFTId,
        uint256[] indexed proportions,
        uint256 quantity
    );
    event FNFTTimeLockMinted(
        address indexed asset,
        address indexed from,
        uint256 indexed fnftId,
        uint256 endTime,
        uint256[] quantities,
        FNFTConfig fnftConfig
    );
    event FNFTUnlocked(address indexed from, uint256 indexed fnftId);
    event FNFTValueLockMinted(
        address indexed primaryAsset,
        address indexed from,
        uint256 indexed fnftId,
        address compareTo,
        address oracleDispatch,
        uint256[] quantities,
        FNFTConfig fnftConfig
    );
    event FNFTWithdrawn(
        address indexed from,
        uint256 indexed fnftId,
        uint256 indexed quantity
    );
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    event RoleAdminChanged(
        bytes32 indexed role,
        bytes32 indexed previousAdminRole,
        bytes32 indexed newAdminRole
    );
    event RoleGranted(
        bytes32 indexed role,
        address indexed account,
        address indexed sender
    );
    event RoleRevoked(
        bytes32 indexed role,
        address indexed account,
        address indexed sender
    );

    function ADDRESS_LOCK_INTERFACE_ID() external view returns (bytes4);

    function DEFAULT_ADMIN_ROLE() external view returns (bytes32);

    function PAUSER_ROLE() external view returns (bytes32);

    function depositAdditionalToFNFT(
        uint256 fnftId,
        uint256 amount,
        uint256 quantity
    ) external returns (uint256);

    function erc20Fee() external view returns (uint256);

    function extendFNFTMaturity(uint256 fnftId, uint256 endTime)
        external
        returns (uint256);

    function flatWeiFee() external view returns (uint256);

    function getAddressesProvider() external view returns (address);

    function getERC20Fee() external view returns (uint256);

    function getFlatWeiFee() external view returns (uint256);

    function getRoleAdmin(bytes32 role) external view returns (bytes32);

    function getRoleMember(bytes32 role, uint256 index)
        external
        view
        returns (address);

    function getRoleMemberCount(bytes32 role) external view returns (uint256);

    function grantRole(bytes32 role, address account) external;

    function hasRole(bytes32 role, address account)
        external
        view
        returns (bool);

    function mintAddressLock(
        address trigger,
        bytes memory arguments,
        address[] memory recipients,
        uint256[] memory quantities,
        FNFTConfig memory fnftConfig
    ) external payable returns (uint256);

    function mintTimeLock(
        uint256 endTime,
        address[] memory recipients,
        uint256[] memory quantities,
        FNFTConfig memory fnftConfig
    ) external payable returns (uint256);

    function mintValueLock(
        address primaryAsset,
        address compareTo,
        uint256 unlockValue,
        bool unlockRisingEdge,
        address oracleDispatch,
        address[] memory recipients,
        uint256[] memory quantities,
        FNFTConfig memory fnftConfig
    ) external payable returns (uint256);

    function owner() external view returns (address);

    function renounceOwnership() external;

    function renounceRole(bytes32 role, address account) external;

    function revokeRole(bytes32 role, address account) external;

    function setAddressRegistry(address registry) external;

    function setERC20Fee(uint256 erc20) external;

    function setFlatWeiFee(uint256 wethFee) external;

    function splitFNFT(
        uint256 fnftId,
        uint256[] memory proportions,
        uint256 quantity
    ) external returns (uint256[] memory);

    function supportsInterface(bytes4 interfaceId) external view returns (bool);

    function transferOwnership(address newOwner) external;

    function unlockFNFT(uint256 fnftId) external;

    function withdrawFNFT(uint256 fnftId, uint256 quantity) external;
}
