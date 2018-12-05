pragma solidity ^0.4.10;

import "./standard/ERC20.sol";

contract MoneyToken is ERC20 {
    string public constant symbol = "Micraft";
    string public constant name = "Micraft Token";
    uint256 _totalSupply = 0;
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;
    address public owner;

    modifier onlyOwner {
        if (msg.sender != owner) {
            throw;
        }
        _;
    }

    function MyToken() {
        owner = msg.sender;
        balances[msg.sender] = _totalSupply;
    }

    function supply(uint256 amount) onlyOwner {
        _totalSupply += amount;
        balances[msg.sender] += amount;
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
        if (balances[from] >= amount && allowed[from][to] >= amount && amount > 0 && balances[to] + amount > balances[to]) {
            balances[from] -= amount;
            balances[to] += amount;
            allowed[from][to] -= amount;
            Transfer(from, to, amount);
            return true;
        } else {
            return false;
        }
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

