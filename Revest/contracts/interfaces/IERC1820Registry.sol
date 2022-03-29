// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

interface IERC1820Registry {
    function setInterfaceImplementer(
        address _addr,
        bytes32 _interfaceHash,
        address _implementer
    ) external;

    function getManager(address _addr) external view returns (address);

    function setManager(address _addr, address _newManager) external;

    function interfaceHash(string memory _interfaceName)
        external
        pure
        returns (bytes32);

    function updateERC165Cache(address _contract, bytes4 _interfaceId) external;

    function getInterfaceImplementer(address _addr, bytes32 _interfaceHash)
        external
        view
        returns (address);

    function implementsERC165InterfaceNoCache(
        address _contract,
        bytes4 _interfaceId
    ) external view returns (bool);

    function implementsERC165Interface(address _contract, bytes4 _interfaceId)
        external
        view
        returns (bool);

    event InterfaceImplementerSet(
        address indexed addr,
        bytes32 indexed interfaceHash,
        address indexed implementer
    );
    event ManagerChanged(address indexed addr, address indexed newManager);
}
