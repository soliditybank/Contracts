// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.16;

import "./IERC20.sol";

contract ERC20 is IERC20 {

	address public admin;
	string _name;
	string _symbol;
	uint8 _decimals;
	uint256 _totalSupply;
	mapping(address => uint256) balances;
	mapping(address => mapping(address => uint256)) allowances;
	mapping(address => mapping(address => bool)) approved;

	constructor (string memory n, string memory s, uint8 d, uint256 t) {
		  _name = n;
		  _symbol = s;
		  _decimals = d;
		  _totalSupply = t * 10**_decimals;
			balances[msg.sender] = _totalSupply;
			emit Transfer(address(0), msg.sender, _totalSupply);
	}

	function name() public view returns (string memory) {
		  return _name;
	}

	function symbol() public view returns (string memory) {
		  return _symbol;
	}

	function decimals() public view returns (uint8) {
		  return _decimals;
	}

	function totalSupply() public view returns (uint256) {
		  return _totalSupply;
	}

	function balanceOf(address owner) public view returns (uint256) {
		  return balances[owner];
	}

	function transfer(address to, uint256 amount) public returns (bool) {
		  require(balances[msg.sender] >= amount, "Non-sufficient funds");
		  balances[msg.sender] -= amount;
		  balances[to] += amount;
		  emit Transfer(msg.sender, to, amount);
		  return true;
	}

	function transferFrom(address from, address to, uint256 amount) public returns (bool) {
		  require(approved[from][msg.sender], "Not approved");
		  require(allowances[from][msg.sender] >= amount, "Non-sufficient funds");
		  allowances[from][msg.sender] -= amount;
		  balances[from] -= amount;
		  balances[to] += amount;
		  emit Transfer(msg.sender, to, amount);
		  return true;
	}
	
	function approve(address spender, uint256 amount) public returns (bool) {
		  approved[msg.sender][spender] = true;
		  allowances[msg.sender][spender] = amount;
			emit Approval(msg.sender, spender, amount);
		  return true;
	}

	function allowance(address owner, address spender) public view returns (uint256) {
		  return allowances[owner][spender];
	}

}
