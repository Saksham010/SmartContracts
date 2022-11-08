const {expect} = require("chai");
const {ethers, waffle} = require("hardhat");
const {BigNumber} = require("ethers");

describe("Attack",function(){

    it("Should change the owner of Good Contract", async function(){

        //Deploy the helper contract
        const helperFactory = await ethers.getContractFactory("Helper");
        const helperContract = await helperFactory.deploy();
        await helperContract.deployed();
        console.log("Helper Contract Address: ", helperContract.address);

        //Deploying good contract
        const goodFactory = await ethers.getContractFactory("Good");
        const goodContract = await goodFactory.deploy(helperContract.address);
        await goodContract.deployed();
        console.log("Good contract address: ",goodContract.address);

        //Deploying attack contract
        const attackFactory = await ethers.getContractFactory("Attack");
        const attackContract = await attackFactory.deploy(goodContract.address);
        await attackContract.deployed();
        console.log("Attack contract address: ",attackContract.address);

        //Starting attack
        let tx = await attackContract.attack();
        await tx.wait();

        //Checking if the attack is successfull
        expect(await goodContract.owner()).to.equal(attackContract.address);
    });

});