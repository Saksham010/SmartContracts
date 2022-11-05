// SPDX-License Identifier: MIT
pragma solidity ^0.8.4;

contract GoodContract{

    mapping(address => uint) public balances;

    // Update the `balances` mapping to include the new ETH deposited by msg.sender

    function addBalance() public payable{
        balances[msg.sender] += msg.value;
    }

    //Send balance back to msg.sender
    function withdraw() public{

        require(balances[msg.sender] > 0, "Your deposited balance is empty");

        //Sending the ether back to the user
        // payable(msg.sender).transfer(balances[msg.sender]); 
        (bool sent, ) = payable(msg.sender).call{value: balances[msg.sender]}("");   
        require(sent,"Failed to send ether");

        //Updating balances
        balances[msg.sender] = 0;    

    }

}