const { expect } = require("chai");
const { ethers } = require("hardhat");
const hre = require("hardhat");

describe("ERC721 Upgradeable", function () {
  it("Should deploy an upgradeable ERC721 Contract", async function () {
    const SNFTFactory = await ethers.getContractFactory("SNFT");
    const SNFT2Factory = await ethers.getContractFactory("SNFT2");

    let proxyContract = await hre.upgrades.deployProxy(SNFTFactory, {
      kind: "uups",
    });
    const [owner] = await ethers.getSigners();
    const ownerOfToken1 = await proxyContract.ownerOf(1);

    expect(ownerOfToken1).to.equal(owner.address);

    proxyContract = await hre.upgrades.upgradeProxy(proxyContract, SNFT2Factory);
    expect(await proxyContract.test()).to.equal("upgraded");
  });
});