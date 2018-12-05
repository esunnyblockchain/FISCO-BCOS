pragma solidity ^0.4.10;

import "./TokenERC721Enumerable.sol";
import "./TokenERC721Metadata.sol";

/// @title A scalable implementation of all ERC721 NFT standards combined.
/// @author Andrew Parker
/// @dev Extends TokenERC721Metadata, TokenERC721Enumerable
contract ReceiptToken is TokenERC721Enumerable{

    struct Receipt {
        string name;
        uint256 qty;
    }

    Receipt[] receipts;

    function ReceiptToken() public TokenERC721Enumerable(0) {

    }

    function addReceipt(string name, uint256 qty) public {
        issueTokens(1);
        receipts.push(Receipt(name, qty));
    }

    function getReceipt(uint256 tokenId) public constant returns(string,uint256) {
        if (tokenId == 0 || tokenId > receipts.length)
            throw;
        return (receipts[tokenId-1].name, receipts[tokenId-1].qty);
    }
}
