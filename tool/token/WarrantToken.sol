pragma solidity ^0.4.10;

import "./TokenERC721Enumerable.sol";
import "./Market.sol";

/// @title A scalable implementation of all ERC721 NFT standards combined.
/// @author Andrew Parker
/// @dev Extends TokenERC721Metadata, TokenERC721Enumerable
contract WarrantToken is TokenERC721Enumerable {

    struct Warrant {
        string name;
        uint256 qty;
    }

    Warrant[] warrants;
    address[] accounts;

    address public market;

    function WarrantToken() public TokenERC721Enumerable(0) {

    }
    function getWarrantNum()public constant returns(uint256){
        return warrants.length;
    }
    function addWarrant(string _name, uint256 _qty) public {
        addWarrant(_name, _qty, msg.sender);
    }

    function addWarrant(string _name, uint256 _qty, address _to) public {
        supply(1, _to);
        warrants.push(Warrant(_name, _qty));
        accounts.push(_to);
    }

    function getWarrant(uint256 _tokenId) public constant returns(string,uint256,address) {
        if (_tokenId == 0 || _tokenId > warrants.length)
            throw;
        return (warrants[_tokenId-1].name, warrants[_tokenId-1].qty, accounts[_tokenId-1]);
    }

    function setMarket(address _market) {
        market = _market;
    }

    function saleWarrent(uint256 _tokenId, uint256 _price) {
        require(market != address(0));
        require(ownerOf(_tokenId) == msg.sender); 

        _approve(market, _tokenId);

        Market(market).createAuction(_tokenId, _price, msg.sender);
    }
}
