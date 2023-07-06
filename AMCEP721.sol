// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AMCEP721 is ERC721Enumerable, Ownable {
    string public baseURI;

    mapping(address => bool) public minters;

    constructor() ERC721("AMC_EntryPass", "AMCEP") {}

    function addMinter(address minter) public onlyOwner {
        minters[minter] = true;
    }

    function removeMinter(address minter) public onlyOwner {
        minters[minter] = false;
    }

    function mint(address toAddress, uint256 tokenId) external {
        require(verifyUser(msg.sender), "No permissions!");
        _safeMint(toAddress, tokenId);
    }

    function verifyUser(address user) public view returns (bool) {
        return user == owner() || minters[user];
    }

    // internal
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function setBaseURI(string memory _newBaseURI) external onlyOwner {
        baseURI = _newBaseURI;
    }

    function burn(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "You do not own this token");
        _burn(tokenId);
    }

    function tokensOfOwner(
        address owner
    ) external view returns (uint256[] memory) {
        uint256 balance = balanceOf(owner);
        uint256[] memory tokens = new uint256[](balance);
        for (uint256 i = 0; i < balance; i++) {
            tokens[i] = tokenOfOwnerByIndex(owner, i);
        }
        return tokens;
    }
}
