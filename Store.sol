// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.27;

/**
 * @title Store
 * @author admin.soliditybank.eth
 */

interface IERC20 {

	event Transfer(address indexed from, address indexed to, uint256 amount);
	event Approval(address indexed owner, address indexed spender, uint256 amount);

	function name() external view returns (string memory);
	function symbol() external view returns (string memory);
	function decimals() external view returns (uint8);
	function totalSupply() external view returns (uint256);
	function balanceOf(address owner) external view returns (uint256);
	function transfer(address to, uint256 amount) external returns (bool);
	function transferFrom(address from, address to, uint256 amount) external returns (bool);
	function approve(address spender, uint256 amount) external returns (bool);
	function allowance(address owner, address spender) external view returns (uint256);

}

contract Store {

  uint public revenue;
  uint public sales_tax;
  address public taxRecipient;
  address public USDC;
  address public EURC;

  struct Product {
    uint id;
    uint stock;
    address erc20;
    uint price;
    uint tax;
    uint fee;
  }

  mapping(uint => Product) public products;

  event Change_Tax_Recipient(address old_recipient, address new_recipient);

  function getBalance(address erc20) public view returns (uint) {
    return IERC20(erc20).balanceOf(address(this));
  }

  function buy(uint id, uint quantity, address referral) public {
    require(products[id].stock >= quantity, "Out of stock");
    require(IERC20(products[id].erc20).balanceOf(msg.sender) >= quantity * products[id].price + products[id].tax + products[id].fee);
    IERC20(products[id].erc20).transferFrom(msg.sender, address(this), quantity * products[id].price - products[id].tax - products[id].fee);
    IERC20(products[id].erc20).transferFrom(msg.sender, taxRecipient, products[id].tax);
    IERC20(products[id].erc20).transferFrom(msg.sender, referral, products[id].fee);
    revenue += quantity * products[id].price - products[id].tax - products[id].fee;
    sales_tax += products[id].tax;
    products[id].stock -= quantity;
  }

  function set_tax_recipient(address new_recipient) public {
    address old_recipient = taxRecipient;
    taxRecipient = new_recipient;
    emit Change_Tax_Recipient(old_recipient, new_recipient);
  }

}
