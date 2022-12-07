const {ethers} = require("hardhat");

async function main(){
  
  //Deploying whitelist contract
  const whitelistFactory = await ethers.getContractFactory("Whitelist");
  const whitelistContract = await whitelistFactory.deploy(10);
  await whitelistContract.deployed();

  console.log("Whitelist contract address: ",whitelistContract.address);
  
}
//0x8EF0fd4e028335f3fEB9aAD8C8ed7B5aED0786c1
main().then(()=> process.exit(0))
      .catch((error)=>{
        console.error(error);
        process.exit(1);
      });


