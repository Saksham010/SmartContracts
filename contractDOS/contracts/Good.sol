//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Good{

    address public currentWinner;
    uint public currentAuctionPrice;

    constructor(){
        currentWinner = msg.sender;
    }

    function setCurrentAuctionPrice()public payable{
        require(msg.value > currentAuctionPrice, "You can only set price higher than the current price");
        (bool sent, ) = currentWinner.call{value: currentAuctionPrice}("");
        if(sent){ //Since attack contract has no receive or fall back function ether transfer fails so sent is always false so no winner is changed
            currentWinner = msg.sender;
            currentAuctionPrice = msg.value;
        }
    }

}