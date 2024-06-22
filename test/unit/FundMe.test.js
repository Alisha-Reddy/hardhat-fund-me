const { deployments, ethers, getNamedAccounts } = require("hardhat")
const { assert } = require("chai");

describe("FundMe", async function () {
    let fundMe;
    let deployer;
    let mockV3Aggregator;
    beforeEach(async function () {
        // deploy our fudMe contract using hardhat-deploy

        // const accounts = await ethers.getSigners(); //getSigners() returns whatever is in the accounts: of networks: in hardhat.config.js
        deployer  = (await getNamedAccounts()).deployer;

        // fixture function  allows us to basically run our entire deploy folder with as many as tags we want
        await deployments.fixture(["all"]);
        fundMe = await ethers.getContractAt("FundMe", deployer) //getContract() gives us the recently deployment of whatever the contract we gave in it
        mockV3Aggregator = await ethers.getContractAt("MockV3Aggregator", deployer)
    })

    describe("constructor", async function () {
        it("sets the aggregator addresses correctly", async function () {
            const response = await fundMe.priceFeed;
            assert.equals(response, mockV3Aggregator.address);
        })
    })
})