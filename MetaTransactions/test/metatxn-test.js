const { expect } = require("chai");
const { BigNumber } = require("ethers");
const { arrayify} = require("ethers/lib/utils");
const { ethers } = require("hardhat");

describe("MetaToken Transfer",()=>{

    it("Should let user transfer token through relayer (Signature Replay Vulnerable)",async ()=>{

        //Deploying metatoken contract
        const MetaTokenFactory = await  ethers.getContractFactory("MetaToken");
        const MetaTokenContract = await MetaTokenFactory.deploy();
        await MetaTokenContract.deployed();

        //Deploying TokenSender contract
        const TokenSenderFactory = await  ethers.getContractFactory("TokenSender");
        const TokenSenderContract = await TokenSenderFactory.deploy();
        await TokenSenderContract.deployed();

        //Getting addresses
        const[,sender,relayer,recepient] = await ethers.getSigners();

        //Minting free tokens using sender (1000 tokens)
        let mintTx = await MetaTokenContract.connect(sender).freeMint(ethers.utils.parseEther('1000'));
        await mintTx.wait();

        //Approving tokensender contract to transfer token of user
        let approveTx = await MetaTokenContract.connect(sender).approve(TokenSenderContract.address,
            //Maximum uint256 value
            BigNumber.from("0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff")
        );
        await approveTx.wait();

        //Generating signature from the user
        const amountToTransfer = ethers.utils.parseEther("10");
        const msgHash = await TokenSenderContract.getHash(sender.address,amountToTransfer, recepient.address, MetaTokenContract.address);
        const signature = await sender.signMessage(arrayify(msgHash));
        console.log("That");

        //Relayer executes the transaction
        const metaTxn = await TokenSenderContract.connect(relayer).transfer(
            sender.address,
            amountToTransfer,
            recepient.address,
            MetaTokenContract.address,
            signature
        );
        await metaTxn.wait();

        //Replaying same transaction by the replayer
        // const metaTxn2 = await TokenSenderContract.connect(relayer).transfer(
        //     sender.address,
        //     amountToTransfer,
        //     recepient.address,
        //     MetaTokenContract.address,
        //     signature
        // );
        // await metaTxn2.wait();

        //Check if sender balance decreased and recepient got 10 tokens
        const senderBalance = await MetaTokenContract.balanceOf(sender.address);
        const recepientBalance = await MetaTokenContract.balanceOf(recepient.address);

        console.log("Sender Balance: ", senderBalance);
        console.log("Recepient Balance: ",recepientBalance);
        
        expect(senderBalance.lt(ethers.utils.parseEther('1000'))).to.be.true;
        expect(recepientBalance.gt(BigNumber.from("0"))).to.be.true;
    });

    //Second test case
    it("Should let user transfer tokens through a relayer with different nonces", async ()=>{
        //Deploying metatoken contract
        const MetaTokenFactory = await  ethers.getContractFactory("MetaToken");
        const MetaTokenContract = await MetaTokenFactory.deploy();
        await MetaTokenContract.deployed();

        //Deploying TokenSender contract
        const TokenSenderFactory = await  ethers.getContractFactory("TokenSender");
        const TokenSenderContract = await TokenSenderFactory.deploy();
        await TokenSenderContract.deployed();

        //Getting addresses
        const[,sender,relayer,recepient] = await ethers.getSigners();

        //Minting free tokens using sender (1000 tokens)
        let mintTx = await MetaTokenContract.connect(sender).freeMint(ethers.utils.parseEther('1000'));
        await mintTx.wait();

        //Approving tokensender contract to transfer token of user
        let approveTx = await MetaTokenContract.connect(sender).approve(TokenSenderContract.address,
            //Maximum uint256 value
            BigNumber.from("0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff")
        );
        await approveTx.wait();
        
        //Introducting nonce
        let nonce = 1;

        //Generating signature from the user
        const amountToTransfer = ethers.utils.parseEther("10");
        const msgHash = await TokenSenderContract.getHash(sender.address,amountToTransfer, recepient.address, MetaTokenContract.address,nonce);
        const signature = await sender.signMessage(arrayify(msgHash));

        //Relayer executes the transaction
        const metaTxn = await TokenSenderContract.connect(relayer).transfer(
            sender.address,
            amountToTransfer,
            recepient.address,
            MetaTokenContract.address,
            nonce,
            signature
        );
        await metaTxn.wait();

        //Check if sender balance decreased and recepient got 10 tokens
        let senderBalance = await MetaTokenContract.balanceOf(sender.address);
        let recepientBalance = await MetaTokenContract.balanceOf(recepient.address);

        console.log("Sender Balance: ", senderBalance);
        console.log("Recepient Balance: ",recepientBalance);
        
        expect(senderBalance.eq(ethers.utils.parseEther("990"))).to.be.true;
        expect(recepientBalance.eq(ethers.utils.parseEther("10"))).to.be.true;

        //Incrementing nonce for next transaction
        nonce++;


        //Sending a second transaction with different nonce
        const msgHash2 = await TokenSenderContract.getHash(sender.address, amountToTransfer, recepient.address, MetaTokenContract.address, nonce);
        const signature2 = await sender.signMessage(arrayify(msgHash2));

        //Relayer execute the second transaction
        const metaTxn2 = await TokenSenderContract.connect(relayer).transfer(sender.address, amountToTransfer, recepient.address, MetaTokenContract.address,nonce,signature2);
        await metaTxn2.wait();

        //Check
        senderBalance = await MetaTokenContract.balanceOf(sender.address);
        recepientBalance = await MetaTokenContract.balanceOf(recepient.address);

        console.log("Sender Balance: ", senderBalance);
        console.log("Recepient Balance: ",recepientBalance);
        
        expect(senderBalance.eq(ethers.utils.parseEther("980"))).to.be.true;
        expect(recepientBalance.eq(ethers.utils.parseEther("20"))).to.be.true;
        
        nonce++;
    });

     //Second test case
     it("Should not let signature replay happen", async ()=>{
        //Deploying metatoken contract
        const MetaTokenFactory = await  ethers.getContractFactory("MetaToken");
        const MetaTokenContract = await MetaTokenFactory.deploy();
        await MetaTokenContract.deployed();

        //Deploying TokenSender contract
        const TokenSenderFactory = await  ethers.getContractFactory("TokenSender");
        const TokenSenderContract = await TokenSenderFactory.deploy();
        await TokenSenderContract.deployed();

        //Getting addresses
        const[,sender,relayer,recepient] = await ethers.getSigners();

        //Minting free tokens using sender (1000 tokens)
        let mintTx = await MetaTokenContract.connect(sender).freeMint(ethers.utils.parseEther('1000'));
        await mintTx.wait();

        //Approving tokensender contract to transfer token of user
        let approveTx = await MetaTokenContract.connect(sender).approve(TokenSenderContract.address,
            //Maximum uint256 value
            BigNumber.from("0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff")
        );
        await approveTx.wait();
        
        //Introducting nonce
        let nonce = 1;

        //Generating signature from the user
        const amountToTransfer = ethers.utils.parseEther("10");
        const msgHash = await TokenSenderContract.getHash(sender.address,amountToTransfer, recepient.address, MetaTokenContract.address,nonce);
        const signature = await sender.signMessage(arrayify(msgHash));

        //Relayer executes the transaction
        const metaTxn = await TokenSenderContract.connect(relayer).transfer(
            sender.address,
            amountToTransfer,
            recepient.address,
            MetaTokenContract.address,
            nonce,
            signature
        );
        await metaTxn.wait();

        //Check if sender balance decreased and recepient got 10 tokens
        let senderBalance = await MetaTokenContract.balanceOf(sender.address);
        let recepientBalance = await MetaTokenContract.balanceOf(recepient.address);

        console.log("Sender Balance: ", senderBalance);
        console.log("Recepient Balance: ",recepientBalance);
        
        expect(senderBalance.eq(ethers.utils.parseEther("990"))).to.be.true;
        expect(recepientBalance.eq(ethers.utils.parseEther("10"))).to.be.true;


        //Attack with the same nonce and same signature
        expect(TokenSenderContract.connect(relayer).transfer(
            sender.address,
            amountToTransfer,
            recepient.address,
            MetaTokenContract.address,
            nonce,
            signature
        )).to.be.revertedWith('Transaction already executed once');

        nonce++;
    });
});