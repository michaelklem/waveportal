// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract WavePortal is Ownable{
  uint MAX_WAVES_ALLOWED = 10;

  event NewWave(address indexed from, uint256 timestamp, string message);
  struct Wave {
      address waver; // The address of the user who waved.
      string message; // The message the user sent.
      uint256 timestamp; // The timestamp when the user waved.
  }

  /*
    * I declare a variable waves that lets me store an array of structs.
    * This is what lets me hold all the waves anyone ever sends to me!
    */
  Wave[] waves;

  // This stores to total number of waves sent to this contract.
  uint256 totalWaves;

  // This stored the number of waves made by specific addresses.
  mapping (address => uint) totalWaveByAddress;

  /*
    * This is an address => uint mapping, meaning I can associate an address with a number!
    * In this case, I'll be storing the address with the last time the user waved at us.
    */
  mapping(address => uint256) public lastWavedAt;



  /*
    * We will be using this below to help generate a random number
    */
  uint256 private seed;

  constructor() payable {
    console.log("Contructed!!!");
    /*
    * Set the initial seed
    */
    seed = getRando();
  }

  /*
  * Generate a new seed for the next user that sends a wave
  */
  function getRando() internal view returns (uint256) {
    uint256 tempSeed = (block.timestamp + block.difficulty) % 100;
    console.log("Random number generated: %d", tempSeed);
    return tempSeed;
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

  function wave(string memory _message) public notBotheringMeYet {
    /*
      * We need to make sure the current timestamp is at least 15-minutes bigger than the last timestamp we stored
      */
    require(
        lastWavedAt[msg.sender] + 30 seconds < block.timestamp,
        "Wait 30 seconds before you can wave at me again."
    );


    /*
      * Update the current timestamp we have for the user
      */
    lastWavedAt[msg.sender] = block.timestamp;


    totalWaves += 1;

    // Update the total waves sent by address
    uint tempWaves = totalWaveByAddress[msg.sender];
    totalWaveByAddress[msg.sender] = ++tempWaves;

    waves.push(Wave(msg.sender, _message, block.timestamp));

    seed = getRando();
    /*
      * Give a 50% chance that the user wins the prize.
      */
    if (seed <= 50) {
        console.log("%s won!", msg.sender);

        /*
        * The same code we had before to send the prize.
        */
        uint256 prizeAmount = 0.0001 ether;
        require(
            prizeAmount <= address(this).balance,
            "Trying to withdraw more money than the contract has."
        );
        (bool success, ) = (msg.sender).call{value: prizeAmount}("");
        require(success, "Failed to withdraw money from contract.");
    }

    emit NewWave(msg.sender, block.timestamp, _message);

    console.log("%s has waved!", msg.sender);
  }

  /*
    * I added a function getAllWaves which will return the struct array, waves, to us.
    * This will make it easy to retrieve the waves from our website!
    */
  function getAllWaves() public view returns (Wave[] memory) {
      return waves;
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