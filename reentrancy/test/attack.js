const { parse } = require("@ethersproject/transactions");
const {expect} = require("chai");
const {BigNumber} = require("ethers");
const { parseEther, parseBytes32String } = require("ethers/lib/utils");
const { ethers } = require("hardhat");


describe("Attack", function (){

    it("Should empty the balance of smart contract", async function(){

        //Deploy the good contract
        const goodContractFactory = await ethers.getContractFactory("GoodContract");
        const goodContract = await goodContractFactory.deploy();
        await goodContract.deployed();

        //Deploy Bad contract
        const badContractFactory = await ethers.getContractFactory("BadContract");
        const badContract = await badContractFactory.deploy(goodContract.address);
        await badContract.deployed();

        //Get two address
        const [, innocentAddress, attackerAddress]  = await ethers.getSigners();

        //innocent Address deposits 10 ether into the goodContract
        let tx = await goodContract.connect(innocentAddress).addBalance({value: parseEther("10")});
        await tx.wait();


        //Checking the balance of goodContract
        let balanceEth = await ethers.provider.getBalance(goodContract.address);
        expect(balanceEth).to.equal(parseEther("10"));


        //Initiating reentrancy attack with attacker addresss
        tx  = await badContract.connect(attackerAddress).attack({value: parseEther("1")})
        await tx.wait();


        //Checking balance of goodContract is zero or not
        balanceEth = await ethers.provider.getBalance(goodContract.address);
        expect(balanceEth).to.equal(BigNumber.from("0"));

        //Checking the balance of the badContract
        balanceEth = await ethers.provider.getBalance(badContract.address);
        expect(balanceEth).to.equal(parseEther("11"));

    })







})
