//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Lottery{

    address public owner;
    address payable[] public participants;

    constructor(){
        //Deployer
        owner = msg.sender;
    }

    receive() external payable{
        require(msg.value >= 3 ether);
        //Logging the participant address
        participants.push(payable(msg.sender));

    }

    function winner()public {
        require(msg.sender == owner);
        require(participants.length >= 3);

        uint rand = uint(keccak256(abi.encodePacked(block.difficulty,block.number,block.timestamp,block.coinbase))) % participants.length;
        participants[rand].transfer(address(this).balance); //Sending winner the prize amount
        
        //Resetting the participant list
        participants = new address payable[](0);
    } 


    //Balance of the smart contract
    function getbalance()public view returns(uint){
        require(msg.sender == owner);
        return address(this).balance;
    }

}

