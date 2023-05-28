// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.16;

interface IERC721Metadata {

    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function tokenURI(uint256 tokenId) external view returns (string memory);
    
}
