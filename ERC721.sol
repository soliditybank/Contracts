// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

import "./IERC721.sol";
import "./IERC721Metadata.sol";

contract ERC721 is IERC721, IERC721Metadata {

    string private _name;
    string private _symbol;

    mapping(uint256 => address) private owners;
    mapping(address => uint256) private balances;
    mapping(uint256 => address) private tokenApprovals;
    mapping(address => mapping(address => bool)) private operatorApprovals;

    mapping(uint => string) URI;
    
    constructor(string memory _n, string memory _s) {
        _name = _n;
        _symbol = _s;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function tokenURI(uint256 tokenId) public view returns (string memory) {
        return URI[tokenId];
    }

    function balanceOf(address owner) public view returns (uint256) {
        return balances[owner];
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        return owners[tokenId];
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public payable {
        require(ownerOf(tokenId) == msg.sender || getApproved(tokenId) == msg.sender, "ERC721: transfer caller is not owner nor approved");
        require(data.length > 0);
        transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public payable {
        safeTransferFrom(from, to, tokenId, "");
    }

    function transferFrom(address from, address to, uint256 tokenId) public payable {
        require(from == msg.sender);
        owners[tokenId] = to;
        balances[to] += 1;
        balances[from] -= 1;
        emit Transfer(from, to, tokenId);
    }

    function approve(address approved, uint256 tokenId) public payable {
        operatorApprovals[msg.sender][approved] = true;
        tokenApprovals[tokenId] = approved;
        emit Approval(msg.sender, approved, tokenId);
    }

    function setApprovalForAll(address operator, bool approved) public {
        operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function getApproved(uint256 tokenId) public view returns (address) {
        return tokenApprovals[tokenId];
    }

    function mint(address to, uint256 tokenId, string memory _URI) public {
        require(to != address(0), "ERC721: mint to the zero address");
        balances[to] += 1;
        owners[tokenId] = to;
        URI[tokenId] = _URI;
        emit Transfer(address(0), to, tokenId);
    }

    function burn(uint256 tokenId) public {
        require(owners[tokenId] == msg.sender);
        delete tokenApprovals[tokenId];
        balances[msg.sender] -= 1;
        delete owners[tokenId];
        emit Transfer(msg.sender, address(0), tokenId);
    }

}
