import {
    time,
    loadFixture,
  } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import hre from "hardhat";
  


describe("PiggyBank", function () {
    // We define a fixture to reuse the same setup in every test.
    // We use loadFixture to run this setup once, snapshot that state,
    // and reset Hardhat Network to that snapshot in every test.
    async function deployPiggyBankFixture() {

      const REASON = "Vacation to doha";
      const developerAddress = "0x812A02c580ed6aC018856514bE2D8DBD3633CD4b";
      const THIRTY_DAYS_IN_SECS = 30 * 24 * 60 * 60;
      const START_TIME = await time.latest();
      const SAVING_DURATION = START_TIME + THIRTY_DAYS_IN_SECS;
  
      const [owner, hacker] = await hre.ethers.getSigners();
  
      const Piggy = await hre.ethers.getContractFactory("PiggyBank");
      const piggy = await Piggy.deploy(owner.address, SAVING_DURATION, REASON);
  
      return { piggy, REASON, START_TIME, owner, SAVING_DURATION, developerAddress, hacker };
    }

    describe("Deployment", function () {
        it("Should set all parameters correctly", async function () {
          const { piggy,owner,REASON,START_TIME,SAVING_DURATION,developerAddress } = await loadFixture(deployPiggyBankFixture);

          const developer = await piggy.DEVELOPER();
          
        //   expect(await piggy.owner()).to.equal(owner.address);
        //   expect(await piggy.reason()).to.equal(REASON);
          expect(await piggy.startTime()).to.equal(START_TIME);
          expect(await piggy.savingDuration()).to.equal(SAVING_DURATION);
        //   expect(developerAddress).to.equal(developer);
        });
    });    

    describe("Deposits", function () {
        it("Should deposit successfully", async function () {
          const { piggy, owner} = await loadFixture(deployPiggyBankFixture);
          const depositAmount = hre.ethers.parseUnits("1000", 18);
    
        //   await tokenContract.mint(depositAmount, anotherUser.address);
        //   expect(await tokenContract.balanceOf(anotherUser.address)).to.equal(depositAmount);
    
        //   await tokenContract.connect(anotherUser).approve(saveErc20.target, depositAmount);
        //   await saveErc20.connect(anotherUser).deposit(depositAmount);
    
        //   expect(await tokenContract.balanceOf(anotherUser.address)).to.equal(0);
        //   expect(await tokenContract.balanceOf(saveErc20.target)).to.equal(depositAmount);
        //   expect(await saveErc20.connect(anotherUser).getUserBalance()).to.equal(depositAmount);
        });
      });
})    