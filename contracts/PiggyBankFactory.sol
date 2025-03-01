// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.28;

import { PiggyBank } from "./PiggyBank.sol";

contract PiggyBankFactory {

    address[] public piggyBanks;


    // The Owner creating a new PiggyBank for another purpose..
    function createPiggyBank(uint256 duration, string memory reason) external returns (address) {
        bytes32 salt = keccak256(abi.encode(msg.sender, reason, block.timestamp));
        PiggyBank bank = new PiggyBank{salt: salt}(
            msg.sender,  
            duration,
            reason
        );
        piggyBanks.push(address(bank));
        return address(bank);
    }

    function get() external view returns (address[] memory) {
        return piggyBanks;
    }
}