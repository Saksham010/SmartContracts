const {ethers} = require("hardhat");
const {expect} = require("chai");

describe("Attack",function(){

    it("The attack contract should remain the winner", async function(){

        //Deploying Good contract
        const goodFactory = await ethers.getContractFactory("Good");
        const goodContract = await goodFactory.deploy();
        await goodContract.deployed();
        console.log("Good contract address: ", goodContract.address);


        //Deploying attack contract
        const attackFactory = await ethers.getContractFactory("Attack");
        const attackContract = await attackFactory.deploy(goodContract.address);
        await attackContract.deployed();
        console.log("Bad contract address: ", attackContract.address);

        const [, addr1, addr2] = await ethers.getSigners();

        //Setting addr1 as the first winner
        let tx = await goodContract.connect(addr1).setCurrentAuctionPrice({value: ethers.utils.parseEther("1")});
        await tx.wait();

        //Attacking with attackcontract
        tx = await attackContract.attack({value: ethers.utils.parseEther("3")});
        await tx.wait();

        //Trying to set addr2 as the current winner
        tx =await goodContract.connect(addr2).setCurrentAuctionPrice({value: ethers.utils.parseEther("4")});
        await tx.wait();

        //Checking if the attack contract is still the current winner or not
        expect(await goodContract.currentWinner()).to.equal(attackContract.address);
    });

});