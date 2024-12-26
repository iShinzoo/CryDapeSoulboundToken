// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "@openzeppelin/contracts@4.7.3/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.7.3/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.7.3/access/Ownable.sol";
import "@openzeppelin/contracts@4.7.3/utils/Counters.sol";

contract CryDapeSBT is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint256;

    Counters.Counter private _tokenIdCounter;

    event Attest(address indexed to, uint256 indexed tokenId);
    event Revoke(address indexed to, uint256 indexed tokenId);

    constructor() ERC721("CryDapeSBT", "CSB") {}

    function _baseURI() 
    internal 
    pure 
    override 
    returns (string memory) 
    {
        return "ipfs://bafybeidt5boy4ousc3jl7v6v5xvle6ybiteqduek7moil6gtzajazfxq2y/";
    }

    function safeMint(address to)
    public  
    onlyOwner
    {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId)
    internal
    override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function burn(uint256 tokenId)
    external 
    {
        require(ownerOf(tokenId) == msg.sender, "You are not the owner of tokenId");
        _burn(tokenId);
    }

    function revoke(uint256 tokenId)
    external 
    onlyOwner
    {
        _burn(tokenId);
    }

    function tokenURI(uint256)
    public
    pure 
    override(ERC721, ERC721URIStorage)
    returns (string memory)
    {
        return _baseURI();
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 /* tokenId */
    )
    internal 
    override 
    virtual 
    {
        require(from == address(0) || to == address(0), "You Cannot transfer this token");
    }

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 firstTokenId
    )
    internal 
    override 
    virtual 
    {
        if (from == address(0)){
            emit Attest(to, firstTokenId);
        } else if (to == address(0)) {
            emit Revoke (to, firstTokenId);
        }
    }

}
