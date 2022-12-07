//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Whitelist{

    //Maximum number of whitelisted address
    uint256 public maxWhitelistno;

    //Current number of whitelisted address
    uint256 public currentWhitelistno;

    constructor(uint256 maxNumber){
        maxWhitelistno = maxNumber;
    }

    //Mapping address whitlisted or not
    mapping(address=>bool) isWhitelisted;

    function addAddressToList() public{

        require(isWhitelisted[msg.sender] == false,"Already whitelisted");
        require(currentWhitelistno < maxWhitelistno,"Whitelist limit reached");
        
        //Whitelisted the address
        isWhitelisted[msg.sender] = true;

        //Incremented the current whitelist number
        currentWhitelistno++;
    }



}