// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Crowdfunding {
    // Mapping to track contributions by address
    mapping(address => uint256) public funders;

    // Campaign details
    uint256 public deadline;       // Deadline for the campaign
    uint256 public targetFunds;    // The goal amount to be raised
    string public name;            // The name of the campaign
    address public owner;          // The address of the campaign owner
    bool public fundsWithdrawn;    // Flag to track if funds have been withdrawn

    // Events to log significant contract actions
    event Funded(address _funder, uint256 _amount);
    event OwnerWithdraw(uint256 _amount);
    event FunderWithdraw(address _funder, uint256 _amount);

    // Constructor to initialize the campaign
    constructor(string memory _name, uint256 _targetFunds, uint256 _deadline) {
        owner = msg.sender;
        name = _name;
        targetFunds = _targetFunds;
        deadline = _deadline;
    }

    // Function for contributors to fund the campaign
    function fund() public payable {
        // Require that funding is enabled
        require(isFundEnabled() == true, "Funding is now disabled!");

        // Record the contribution and emit an event
        funders[msg.sender] += msg.value;
        emit Funded(msg.sender, msg.value);
    }

    // Function for the owner to withdraw funds when the campaign is successful
    function withdrawOwner() public {
        // Require that the caller is the owner and the campaign is successful
        require(msg.sender == owner, "Not authorized!");
        require(isFundSuccess() == true, "Cannot withdraw!");

        // Calculate the amount to send to the owner
        uint256 amountToSend = address(this).balance;

        // Transfer the funds to the owner and update the withdrawal flag
        (bool success,) = msg.sender.call{value: amountToSend}("");
        require(success, "unable to send!");
        fundsWithdrawn = true;

        // Emit an event to log the withdrawal
        emit OwnerWithdraw(amountToSend);
    }

    // Function for contributors to withdraw their contributions if the campaign is unsuccessful
    function withdrawFunder() public {
        // Require that the campaign is not enabled (past the deadline or already withdrawn) and is unsuccessful
        require(isFundEnabled() == false && isFundSuccess() == false, "Not eligible!");

        // Calculate the amount to send to the contributor
        uint256 amountToSend = funders[msg.sender];

        // Transfer the funds to the contributor, reset their contribution, and emit an event
        (bool success,) = msg.sender.call{value: amountToSend}("");
        require(success, "unable to send!");
        funders[msg.sender] = 0;
        emit FunderWithdraw(msg.sender, amountToSend);
    }

    // Helper function to check if funding is currently enabled
    function isFundEnabled() public view returns(bool) {
        if (block.timestamp > deadline || fundsWithdrawn) {
            return false;
        } else {
            return true;
        }
    }

    // Helper function to check if the campaign is successful
    function isFundSuccess() public view returns(bool) {
        if(address(this).balance >= targetFunds || fundsWithdrawn) {
            return true;
        } else {
            return false;
        }
    }
}
