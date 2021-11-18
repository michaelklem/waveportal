
const main = async () => {
  const [owner, randomPerson] = await hre.ethers.getSigners();
  const waveContractFactory = await hre.ethers.getContractFactory('WavePortal');
  const waveContract = await waveContractFactory.deploy({
    value: hre.ethers.utils.parseEther('0.1'),
  });
  await waveContract.deployed();

  console.log("Contract deployed to:", waveContract.address);
  console.log("Contract deployed by:", owner.address);

  /*
   * Get Contract balance
   */
  let contractBalance = await hre.ethers.provider.getBalance(
    waveContract.address
  );
  console.log(
    'Contract balance:',
    hre.ethers.utils.formatEther(contractBalance)
  );

  let waveCount;
  let waveTxn;

  waveCount = await waveContract.getTotalWaves();
  console.log('Total waves at start: ' + waveCount.toNumber());

  try {
    // the owner can wave as many times as they want
    for (let i = 0; i < 15; i++) {
      waveTxn = await waveContract.wave('my message');
      await waveTxn.wait();
    }

    // the owner can wave as many times as they want
    for (let i = 0; i < 13; i++) {
      waveTxn = await waveContract.connect(randomPerson).wave('some other message');
      await waveTxn.wait();
    }
  }
  catch(err) {
    console.log('Error: ' + err.message)
  }
  
  const ownerWaves = await waveContract.getTotalWavesByAddress( owner.address );
  console.log('Number of time the owner waved: ' + ownerWaves)

  const randoWaves = await waveContract.getTotalWavesByAddress( randomPerson.address );
  console.log('Number of time the rando waved: ' + randoWaves)
  
  waveCount = await waveContract.getTotalWaves();
  console.log('Total waves at end: ' + waveCount.toNumber());


  /*
   * Get Contract balance to see what happened!
   */
  contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log(
    'Final Contract balance:',
    hre.ethers.utils.formatEther(contractBalance)
  );

};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();