//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract CrowdFunding{
    
    mapping(address => uint) participant;
    address public owner;
    uint public numofparticipants;
    uint public target;
    uint public raisedAmount;
    uint public deadline;
    uint public minimumContribution;


    constructor(){
        owner = msg.sender;
        minimumContribution = 1 ether;
        target = 70 ether;
        deadline = block.timestamp + 180;        
    }

    function sendEther() payable external{
        require(block.timestamp < deadline, "Deadline has passed");
        require(msg.value >= minimumContribution);

        if(participant[msg.sender] == 0){
            numofparticipants++;
        }

        participant[msg.sender] += msg.value;
        raisedAmount += msg.value;
    }

    function refund() external{
        require(block.timestamp > deadline && raisedAmount < target,"Refund not possible");
        require(participant[msg.sender] != 0); //Rejecting refunding for non participants

        address payable user = payable(msg.sender);
        uint amount = participant[msg.sender];

        //Refunding the contributed amount
        user.transfer(amount);
    }

    function getBalanceContract() public view returns(uint){
        return address(this).balance;
    }

}
