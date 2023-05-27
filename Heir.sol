// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.16;

contract Heir {

    address public beneficiary;
    uint public allowance;
    uint private delay;
    uint private timer;

    event Withdrawal(address recipient);
    event New_Beneficiary(address old_beneficiary, address new_beneficiary);

    modifier onlyHeir {
        require(msg.sender == beneficiary, "Prohibited");
        _;
    }

    constructor (address _beneficiary) payable {
        beneficiary = _beneficiary;
        allowance = block.timestamp * 1 weeks * 100;
        delay = 1 minutes; // Testing purposes
        timer = block.timestamp + delay;
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function getBalance_USD(uint ether_usd_integer) public view returns (uint) {
        return address(this).balance * ether_usd_integer / 1 ether;
    }

    function getAllowance_USD(uint ether_usd_integer) public view returns (uint) {
        return allowance * ether_usd_integer / 1 ether;
    }

    function withdraw(address payable recipient) public onlyHeir {
        require(block.timestamp >= timer, "Not allowed yet");
        require(address(this).balance >= allowance);
        recipient.transfer(allowance);
        timer = block.timestamp + delay;
        emit Withdrawal(recipient);
    }

    function time_left() public view returns (uint t) {
        require(timer > block.timestamp, "Withdrawal is allowed");
        t = timer - block.timestamp;
    }

    function new_beneficiary(address _beneficiary) public onlyHeir {
        beneficiary = _beneficiary;
        emit New_Beneficiary(msg.sender, _beneficiary);
    }

}
