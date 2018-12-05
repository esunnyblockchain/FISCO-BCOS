//Write your own contracts here. Currently compiles using solc v0.4.15+commit.bbb8e64f.
pragma solidity ^0.4.11;

import "./standard/ERC721.sol";
import "./standard/ERC20.sol";

contract SaleAuction {

  struct Auction {
    address seller;
    uint256 price;
  }

  address public tokenAddress;
  address public moneyAddress;

  mapping (uint256 => Auction) private tokenIdToAuction;
  uint256[] auctionTokens;
  mapping (uint256 => uint256) private auctionTokenIndex;

  event AuctionStart(uint256 tokenId, uint256 price);
  event AuctionCancel(uint256 tokenId);
  event AuctionSuccess(uint256 tokenId, uint256 price);

  function SaleAuction(address _tokenAddress, address _moneyAddress) public {
    require(_tokenAddress != address(0));
    require(_moneyAddress != address(0));
    tokenAddress = _tokenAddress;
    moneyAddress = _moneyAddress;
  }

  function createAuction(uint256 _tokenId, uint256 _price, address _seller) external { 
    //require (msg.sender == tokenAddress); // check operation from token address, someone want to sell token
    require (_seller == ERC721(tokenAddress).ownerOf(_tokenId)); // check owner of token is seller

    require (address(this) == ERC721(tokenAddress).getApproved(_tokenId)); // check auction contract is approved
    _escrow(_seller, _tokenId);

    Auction storage auction = tokenIdToAuction[_tokenId];
    auction.seller = _seller;
    auction.price = _price;

    auctionTokens.push(_tokenId);
    auctionTokenIndex[_tokenId] = auctionTokens.length;

    AuctionStart(_tokenId, _price);
  }

  function cancelAuction(uint256 _tokenId) {
    //require (msg.sender == tokenAddress); // check operation from token address, someone want to sell token

    require (address(this) == ERC721(tokenAddress).ownerOf(_tokenId)); // check auction contract is approved
    require (tokenIdToAuction[_tokenId].seller == msg.sender);

    _transfer(tokenIdToAuction[_tokenId].seller, _tokenId);
    
    _remove(_tokenId);

    AuctionCancel(_tokenId);
  }

  function bid(uint256 _tokenId, uint256 _price) external {
    require(_price > 0);

    Auction storage auction = tokenIdToAuction[_tokenId];
    require(_price >= auction.price);

    bool transferSuccess = ERC20(moneyAddress).transferFrom(msg.sender, auction.seller, _price);
    if (transferSuccess) {
        _transfer(msg.sender, _tokenId);
        AuctionSuccess(_tokenId, _price);
    }
  }

  function _remove(uint256 _tokenId) internal {
    uint256 tokenIndex = auctionTokenIndex[_tokenId];
    if (tokenIndex > 0) {
      for (uint256 i = tokenIndex - 1; i < auctionTokens.length - 1; ++i) {
        auctionTokens[i] = auctionTokens[i+1];
      }
      --auctionTokens.length;
    }
    delete tokenIdToAuction[_tokenId];
    delete auctionTokenIndex[_tokenId];
  }

  function _escrow(address _owner, uint256 _tokenId) internal {
    ERC721(tokenAddress).transferFrom(_owner, this, _tokenId);
  }

  function _transfer(address _receiver, uint256 _tokenId) internal {
    ERC721(tokenAddress).transferFrom(this, _receiver, _tokenId);
  }

}
