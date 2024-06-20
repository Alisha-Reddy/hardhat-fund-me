// module.exports = async (hre) => {
//     const { getNamedAccounts, deployments } = hre;
//     // This is the same as hre.getNamedAccounts and hre.deployments.
//     // So lets just put them as arguments of the function instead of hre

// }

const { networkConfig } = require("../helper-hardhat-config")
    //  Its the same as:
    // const helperConfig = require("../helper-hardhat-config")
    // const networkConfig = helperConfig.networkConfig


module.exports = async (getNamedAccounts, deployments) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId


    const ethUsdPricceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"];

    // Now we create a mock. It's cuz if the contract doesn't exist, we deploy a minimal version of it for our local testing

    // when going for localhost or hardhat network we want to use a mock

    // deploy("our contract name", list of overrides)
    const fundMe = await deploy("FundMe", {
        from: deployer,
        aegs: [
            // address
        ], //List of arguments. We put pricefeed address here
        log: true,
    })
}