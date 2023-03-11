// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;  

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "hardhat/console.sol";

contract MSoccer is
    ERC721,
    ERC721Enumerable,
    ERC721URIStorage,
    Ownable
{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    mapping(uint256 => bool) public claims;
    mapping(uint256 => uint256) public _redeemedTimestamp;
    mapping(uint256 => string) public extAddresses;
    string public extInfo;
    string public _baseTokenURI;

    constructor() ERC721("MSoccer", "tMSX") {}

    function _baseURI() internal pure override returns (string memory) {
        return "https://ipfs.io/ipfs/";
    }

    function mintItem(address to, string memory uri) public returns (uint256) {
        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();
        claims[tokenId] = false;
        _safeMint(to, tokenId);
        console.log('AB ',uri);
        _setTokenURI(tokenId, uri);
        //console.log('AB ',getTokenURI(tokenId));
        return tokenId;
    }

    function redeem(string memory _extInfo, uint256 tokenId) public{
        require(ownerOf(tokenId) == msg.sender, "You cannot redeem this NFT");
        require(0 == _redeemedTimestamp[tokenId], "This item has already a redeemed timestamp! ");
        _redeemedTimestamp[tokenId] = block.timestamp;
        claims[tokenId] = true;
        extAddresses[tokenId] = _extInfo;
    }

    function getClaimedAddress(uint256 tokenId) view public returns (string memory){ 
        address owner = ERC721.ownerOf(tokenId);
        require(owner == msg.sender, "You cannot check this information");
        require(claims[tokenId], "This item has not been claimed yet!");
        string memory test = extAddresses[tokenId];
        return test;
    }

     function isClaimed(uint256 tokenId) view public returns (bool){
        console.log('should return',claims[tokenId]); //
        return claims[tokenId]; 
    }
 // The following functions are overrides required by Solidity.


    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
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

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
