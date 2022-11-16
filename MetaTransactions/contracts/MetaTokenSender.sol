//SPDX-Licensce-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract MetaToken is ERC20 {

    constructor() ERC20("",""){}

    function freeMint(uint amount) public{
        _mint(msg.sender,amount);
    }
}

contract TokenSender{
    
    using ECDSA for bytes32;

    //Mapping to check whether the transaction has already been executed or not
    mapping(bytes32 => bool) executed; //Test 2,3
    //Nonce : Test 2,3

    function transfer(address sender, uint amount,address recepient, address tokenContract,uint nonce, bytes memory signature) public{

        bytes32 messageHash = getHash(sender, amount, recepient,tokenContract,nonce);
        bytes32 signedMessageHash = messageHash.toEthSignedMessageHash();

        //Check whether the transaction is being replayed
        require(!executed[signedMessageHash], "Transaction already executed once"); //Test 2,3

        address signer = signedMessageHash.recover(signature);
        require(signer == sender, "Signature does not come from sender");

        //Setting transaction execution to true
        executed[signedMessageHash] = true; //Test 2,3
        bool sent = ERC20(tokenContract).transferFrom(sender, recepient, amount);
        require(sent, "Transfer failed");
    }

    function getHash(address sender, uint amount, address recipient, address tokenContract, uint nonce) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(sender, amount, recipient, tokenContract, nonce));
    }
}