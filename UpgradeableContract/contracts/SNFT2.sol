//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./SNFT.sol";

contract SNFT2 is SNFT {

    function test() pure public returns(string memory) {
        return "upgraded";
    }
}