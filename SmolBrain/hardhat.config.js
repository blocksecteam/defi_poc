require("@nomiclabs/hardhat-waffle");

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.11",
  networks: {
    hardhat: {
      forking: {
        url: "https://speedy-nodes-nyc.moralis.io/${MORALIS_KEY}/arbitrum/mainnet",
        blockNumber: 7322585
      },
      loggingEnabled: false
    }
  }
};
