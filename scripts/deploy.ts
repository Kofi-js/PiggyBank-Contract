const { ethers } = require("hardhat");

async function main() {
  console.log("...............Deploying PiggyBankFactory................");
  
  // Deploy PiggyBankFactory
  const PiggyBankFactory = await ethers.getContractFactory("PiggyBankFactory");
  const factory = await PiggyBankFactory.deploy();

  await factory.waitForDeployment();
  console.log("PiggyBankFactory deployed to:", await factory.getAddress());
  
  console.log("...............Creating Test PiggyBank................");
  // Create a sample PiggyBank for testing
  const testDuration = 60 * 60 * 24 * 30; // 30 days in seconds
  const testReason = "Emergency Fund";
  
  const tx = await factory.createPiggyBank(testDuration, testReason);
  await tx.wait();
  console.log("..................Test PiggyBank created!................");
  
  // Get deployed PiggyBank addresses
  const allPiggyBanks = await factory.get();
  console.log(`Created PiggyBank at ${allPiggyBanks[0]}`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });