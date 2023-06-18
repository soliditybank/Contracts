// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.16;

/**
 * @title MultiSig Wallet
 * @author admin.soliditybank.eth
 */

interface IERC20 {

	event Transfer(address indexed from, address indexed to, uint256 amount);
	event Approval(address indexed owner, address indexed spender, uint256 amount);

	function name() external view returns (string memory);
	function symbol() external view returns (string memory);
	function decimals() external view returns (uint8);
	function totalSupply() external view returns (uint256);
	function balanceOf(address owner) external view returns (uint256 balance);
	function transfer(address to, uint256 amount) external returns (bool success);
	function transferFrom(address from, address to, uint256 amount) external returns (bool success);
	function approve(address spender, uint256 amount) external returns (bool success);
	function allowance(address owner, address spender) external view returns (uint256 remaining);

}

contract MultiSig_Wallet {

    address [] public owners;
    uint public total_owners;
    mapping(address => bool) isOwner;
    mapping(uint => mapping(address => bool)) public tx_signatures;
    mapping(uint => Tx) public transactions;
    uint public nonce;

    struct Tx {
        uint id;
        address erc20;
        address recipient;
        uint256 amount;
        uint8 signatures;
        bool status;
    }

    constructor (address [] memory _owners) payable {
        owners = _owners;
        total_owners = owners.length;
        for (uint i=0; i<total_owners; i++) {
            isOwner[owners[i]] = true;
        }
    }

    function new_Ether_Tx(address recipient, uint256 amount) public {
        require(isOwner[msg.sender], "Not an owner");
        Tx memory t;
        t.id = nonce;
        t.erc20 = address(0);
        t.recipient = recipient;
        t.amount = amount;
        t.signatures = 0;
        transactions[nonce] = t;
        nonce++;
    }

    function new_ERC20_Tx(address erc20, address recipient, uint256 amount) public {
        require(isOwner[msg.sender], "Not an owner");
        Tx memory t;
        t.id = nonce;
        t.erc20 = erc20;
        t.recipient = recipient;
        t.amount = amount;
        t.signatures = 0;
        transactions[nonce] = t;
        nonce++;
    }

    function sign_Ether_Tx(uint tx_id, uint8 owner_id) public {
        require(isOwner[msg.sender], "Not an owner");
        require(msg.sender == owners[owner_id], "Not the corret ID");
        require(!tx_signatures[tx_id][msg.sender], "Already signed");
        tx_signatures[tx_id][msg.sender] = true;
        transactions[tx_id].signatures += 1;
    }

    function sign_ERC20_Tx(uint tx_id, uint8 owner_id) public {
        require(isOwner[msg.sender], "Not an owner");
        require(msg.sender == owners[owner_id], "Not the corret ID");
        require(!tx_signatures[tx_id][msg.sender], "Already signed");
        tx_signatures[tx_id][msg.sender] = true;
        transactions[tx_id].signatures += 1;
    }

    function transfer_ether(uint tx_id) public {
        require(transactions[tx_id].erc20 == address(0), "Not a Ether tx");
        require(transactions[tx_id].signatures == owners.length, "All signatures required");
        require(!transactions[tx_id].status, "Old transaction");
        address payable to = payable(transactions[tx_id].recipient);
        uint256 amount = transactions[tx_id].amount;
        to.transfer(amount);
        transactions[tx_id].status = true;
        nonce++;
    }

    function transfer_erc20(uint tx_id) public {
        require(transactions[tx_id].erc20 != address(0), "Not a ERC20 tx");
        require(transactions[tx_id].signatures == owners.length, "All signatures required");
        require(!transactions[tx_id].status, "Old transaction")
        address erc20 = transactions[tx_id].erc20;
        address to = transactions[tx_id].recipient;
        uint256 amount = transactions[tx_id].amount;
        IERC20(erc20).transfer(to, amount);
        transactions[tx_id].status = true;
        nonce++;
    }

}
