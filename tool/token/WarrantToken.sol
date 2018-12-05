pragma solidity ^0.4.10;

import "./TokenERC721Enumerable.sol";
import "./SaleAuction.sol";

/// @title A scalable implementation of all ERC721 NFT standards combined.
/// @author Andrew Parker
/// @dev Extends TokenERC721Metadata, TokenERC721Enumerable
contract WarrantToken is TokenERC721Enumerable {

    struct Warrant {
        string name;
        uint256 qty;
    }

    Warrant[] warrants;

    address saleAuction;

    function WarrantToken() public TokenERC721Enumerable(0) {

    }

    function addReceipt(string _name, uint256 _qty) public {
        issueTokens(1);
        warrants.push(Warrant(_name, _qty));
    }

    function getReceipt(uint256 _tokenId) public constant returns(string,uint256) {
        if (_tokenId == 0 || _tokenId > warrants.length)
            throw;
        return (warrants[_tokenId-1].name, warrants[_tokenId-1].qty);
    }

    function setSaleAuction(address _saleAuction) {
        saleAuction = _saleAuction;
    }

    function saleWarrent(uint256 _tokenId, uint256 _price) {
        require(saleAuction != address(0));
        require(ownerOf(_tokenId) == msg.sender); 

        _approve(saleAuction, _tokenId);

        SaleAuction(saleAuction).createAuction(_tokenId, _price, msg.sender);
    }
}
