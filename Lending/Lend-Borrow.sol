//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Loan{

    address public owner;
    address payable[] public participant;
    
    constructor(){
        owner = msg.sender;
    }

    //Deposit section
    mapping(address=>uint) _deposit;
    address payable lender;

    function deposit() external payable{
        //Logging the address and deposit amount
        _deposit[msg.sender] = msg.value;
        lender = payable(msg.sender);

    }

    //Borrow section

        //1. Collateral deposit
    mapping(address=>uint) _collateral_deposit;
    function collateral_deposit()external payable{

        _collateral_deposit[msg.sender] = msg.value;
    
    }

        //2. Borrow
    uint _start; //For timing
    uint _end;
    address payable borrower; //One borrower scenario

    mapping(address => uint) _myBorrower;

    function borrow(uint amount) external {
        assert(amount < (_collateral_deposit[msg.sender])/2);

        borrower = payable(msg.sender);
        borrower.transfer(amount);
        _myBorrower[msg.sender] = amount;

        _start = block.timestamp;
        _end  = _start + 300;
    }

    //If the ether is not returned
    function failsafe() external payable {
        assert(block.timestamp >= _end);
        assert(msg.sender == owner);

        //Transfering to Borrower
        uint left = _collateral_deposit[borrower] - _myBorrower[borrower]-5;   
        borrower.transfer(left);     

        //Transferring to the lender

        uint lender_left = _deposit[lender];
        lender.transfer(lender_left+2);
    }

    //Return section

    function return_money(uint amount) external payable{
        assert(amount >= _myBorrower[msg.sender]+5);

        //Transfering money to the borrower
        payable(msg.sender).transfer(_collateral_deposit[borrower]);

        //Transfering money to the lender
        lender.transfer(_deposit[lender]+2);
    }

    function get_balance()public view returns(uint){
        return address(this).balance;
        
    }

}

