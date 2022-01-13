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
 
    //Request to vote
    struct Request{
        string description;
        address payable recipient;
        uint value;
        bool completed;
        uint noOfVoters;
        mapping(address=>bool) voted;
    }
    mapping(uint=>Request) public request;
    uint public numofRequest;

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
    
    function createRequests(string memory _description, address payable _recipient,uint _value) public{
        require(msg.sender == owner);
        Request storage newRequest = request[numofRequest]; //=> Request var -> [0 -> Request block]
        numofRequest++;

        newRequest.description = _description;
        newRequest.recipient = _recipient;
        newRequest.value = _value;
        newRequest.completed = false;
        newRequest.noOfVoters =0;
    }


    function voteOnRequest(uint requestNo)public {
        require(msg.sender != owner);
        require(participant[msg.sender] > 0,"You are not eligible to vote");
        Request storage newRequest = request[requestNo];
        require(newRequest.voted[msg.sender] == false, "You have already voted");

        newRequest.voted[msg.sender] = true;
        newRequest.noOfVoters++;    
    }

    function payfund(uint requestNo)public{
        require(msg.sender == owner);
        require(raisedAmount >= target);
        Request storage newRequest = request[requestNo];
        require(newRequest.completed == false,"Already funded");
        require(newRequest.noOfVoters > (numofparticipants)/2,"Majority approval consensus not reached");

        //Transferring funds
        newRequest.recipient.transfer(newRequest.value); 
        newRequest.completed = true;
    }

    function getBalanceContract() public view returns(uint){
        return address(this).balance;
    }
    
}
