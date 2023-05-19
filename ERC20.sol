// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

import "./IERC20.sol";

contract ERC20 is IERC20 {

	string public name;
	string public symbol;
	uint8 public decimals;
	uint256 public totalSupply;
	mapping(address => uint256) balances;
	mapping(address => mapping(address => uint256)) allowances;
	mapping(address => mapping(address => bool)) approved;

	constructor (string memory _name, string memory _symbol, uint8 _decimals, uint256 _totalSupply) {
		name = _name;
		symbol = _symbol;
		decimals = _decimals;
		totalSupply = _totalSupply * 10**_decimals;
		balances[msg.sender] += totalSupply;
		emit Transfer(address(0), owner, totalSupply);
	}

	function balanceOf(address owner) public view returns (uint256 balance) {
		return balances[owner];
	}

	function transfer(address to, uint256 amount) public returns (bool success) {
		require(balances[msg.sender] >= amount, "Non-sufficient funds");
		balances[msg.sender] -= amount;
		balances[to] += amount;
		emit Transfer(msg.sender, to, amount);
		return true;
	}

	function transferFrom(address from, address to, uint256 amount) public returns (bool success) {
		require(approved[from][msg.sender], "Not approved");
		require(allowances[from][msg.sender] >= amount, "Non-sufficient funds");
		allowances[from][msg.sender] -= amount;
		balances[from] -= amount;
		balances[to] += amount;
		emit Transfer(msg.sender, to, amount);
		return true;
	}

	function approve(address spender, uint256 amount) public returns (bool success) {
		approved[msg.sender][spender] = true;
		allowances[msg.sender][spender] = amount;
		return true;
	}

	function allowance(address owner, address spender) public view returns (uint256 remaining) {
		return allowances[owner][spender];
	}

}
