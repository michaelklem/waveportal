// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract WavePortal is Ownable{
  uint MAX_WAVES_ALLOWED = 10;

  // This stores to total number of waves sent to this contract.
  uint256 totalWaves;

  // This stored the number of waves made by specific addresses.
  mapping (address => uint) totalWaveByAddress;

  constructor() {
      console.log("Hi Farza!!!");
  }

  modifier notBotheringMeYet {
    // We ignore this logic for the owner of the contract so they can wave as many times as needed.
    if (! isOwner()) {
      console.log("%s waved %d times", msg.sender, totalWaveByAddress[msg.sender]);
      require(totalWaveByAddress[msg.sender] <= MAX_WAVES_ALLOWED, "I have been bothered.");
    }
    _;
  }

  function isOwner() internal view virtual returns (bool) {
    return msg.sender == owner();
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