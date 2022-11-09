// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Game {
    constructor() payable {
        
    }

    function pickAcard() private view returns(uint){
        // Abiencode => bytearray => keccak256 => byte32 => uint256
        uint randomNum = uint(keccak256(abi.encodePacked(blockhash(block.number), block.timestamp)));
        return randomNum;
    }

    function guessNumber(uint256 _guess) public {
        uint num = pickAcard();
        if(_guess == num){
            (bool sent, ) = msg.sender.call{value: 0.1 ether}("");
            require(sent, "Transfer unsuccessfull");
        }

    }

    function getBalance()public view returns(uint){
        return address(this).balance;
    }
}

