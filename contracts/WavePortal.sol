// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
  uint MAX_WAVES_ALLOWED = 1;

  // This stores to total number of waves sent to this contract.
  uint256 totalWaves;

  // This stored the number of waves made by specific addresses.
  mapping (address => uint) totalWaveByAddress;

  constructor() {
      console.log("Hi Farza!!!");
  }

  modifier notBotheringMeYet {
    console.log("%s waved %d times", msg.sender, totalWaveByAddress[msg.sender]);
    require(totalWaveByAddress[msg.sender] <= MAX_WAVES_ALLOWED, "Now I am bothered by you");
    _;
  }

  function wave() public notBotheringMeYet {
    totalWaves += 1;

    // Update the total waves sent by address
    uint tempWaves = totalWaveByAddress[msg.sender];
    totalWaveByAddress[msg.sender] = ++tempWaves;
    
    console.log("%s has waved!", msg.sender);
  }

  function getTotalWaves() public view returns (uint256) {
    console.log("Total waves so far: %d", totalWaves);
    return totalWaves;
  }

  function getTotalWavesByAddress(address waverAddress) public view returns (uint256) {
    console.log("Total waves so far from: %s are %d", waverAddress, totalWaveByAddress[waverAddress]);
    return totalWaveByAddress[waverAddress];
  }
}