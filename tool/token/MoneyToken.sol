pragma solidity ^0.4.10;

import "./standard/ERC20.sol";
import "./Market.sol";

contract MoneyToken is ERC20 {
    string public constant symbol = "Money";
    string public constant name = "RMB";
    uint256 _totalSupply = 0;
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;
    address public owner;
    address public market;

    modifier onlyOwner {
        if (msg.sender != owner) {
            throw;
        }
        _;
    }

    function setMarket(address _market) external {
        market = _market;
    }

    function MoneyToken() {
        owner = msg.sender;
        balances[msg.sender] = _totalSupply;
    }

    function supply(uint256 _amount) public {
        supply(_amount, msg.sender);
    }

    function supply(uint256 _amount, address _to) public {
        _totalSupply += _amount;
        balances[_to] += _amount;
        Transfer(0x0, _to, _amount);
    }

    function totalSupply() constant public returns (uint256 totalSupply) {
        totalSupply = _totalSupply;
    }

    function balanceOf(address _owner) constant public returns (uint256 balance) {
          return balances[_owner];
    }

    function transfer(address to, uint256 amount) public returns (bool success) {
        if (balances[msg.sender] >= amount && amount > 0 && balances[to] + amount > balances[to]) {
            balances[msg.sender] -= amount;
            balances[to] += amount;
            Transfer(msg.sender, to, amount);
            return true;
        } else {
            return false;
        }
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool success) {
        if (balances[from] >= amount && allowed[from][msg.sender] >= amount && amount > 0 && balances[to] + amount > balances[to]) {
            balances[from] -= amount;
            balances[to] += amount;
            allowed[from][msg.sender] -= amount;
            Transfer(from, to, amount);
            return true;
        } else {
            return false;
        }
    }

    function bid(uint256 _tokenId, uint256 _price) {
        require(market != address(0));
        approve(market, _price);
        Market(market).bid(_tokenId, _price, msg.sender);
    }

    function approve(address spender, uint256 amount) public returns (bool success) {
        allowed[msg.sender][spender] += amount;
        Approval(msg.sender, spender, amount);
        return true;
    }

    function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
}
