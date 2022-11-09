const {expect} = require("chai");
const {ethers} = require("hardhat");
const {utils, BigNumber} = require("ethers");

describe("Attack", function(){

    it("Should be able to guess exact number", async function(){

        //Deploying game contract
        const GameFactory = await ethers.getContractFactory("Game");
        const gameContract = await GameFactory.deploy({value: utils.parseEther("0.1")});
        await gameContract.deployed();
        console.log("Game contract: ", gameContract.address, " Balance: ", await gameContract.getBalance());

        //Deploying attack contract
        const AttackFactory = await ethers.getContractFactory("Attack");
        const attackContract = await AttackFactory.deploy(gameContract.address);
        await attackContract.deployed();
        console.log("Attack contract: ", attackContract.address, " Balance: ", await attackContract.getBalance());

        //Starting attack
        let tx = await attackContract.attack();
        await tx.wait();

        //Checking balance of game contract is 0 or not
        let gameBalance = await gameContract.getBalance();
        
        expect(gameBalance).to.equal(BigNumber.from("0"));

        console.log("Game contract: ", gameContract.address, " Balance(After attack): ", gameBalance);
        console.log("Attack contract: ", attackContract.address, " Balance(After attack): ", await attackContract.getBalance());


    });
});
