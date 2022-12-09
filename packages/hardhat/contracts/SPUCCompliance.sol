// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract SPUCompliance is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;   

    struct Occupation {
        uint256 tokenId;
        address occupiedBy;
    }

    Occupation[] public occupations;

    constructor() ERC721("SPUCompliance", "SPUC") {}

    function safeMint(string memory uri) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, uri);

        occupations.push(Occupation(tokenId, msg.sender));        
    }

    function setOccupation(uint256 tokenId, address occupier) public onlyOwner {
        for(uint index = 0; index < occupations.length; index++) {
            if(tokenId == occupations[index].tokenId) {
                occupations[index].tokenId = tokenId;
                occupations[index].occupiedBy = occupier;
            }
        }
    }

    function tokenOccupation(uint256 tokenId)
        public
        view        
        returns (address occupiedBy)
    {
        for(uint index = 0; index < occupations.length; index++) {
            if(tokenId == occupations[index].tokenId) {
                return occupations[index].occupiedBy;                
            }
        }
        
    }   

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }        
}
