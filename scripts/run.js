
const main = async () => {
  const [owner, randomPerson] = await hre.ethers.getSigners();
  const waveContractFactory = await hre.ethers.getContractFactory('WavePortal');
  const waveContract = await waveContractFactory.deploy();
  await waveContract.deployed();

  console.log("Contract deployed to:", waveContract.address);
  console.log("Contract deployed by:", owner.address);

  let waveCount;
  let waveTxn;

  waveCount = await waveContract.getTotalWaves();
  
  try {
    // the owner can wave as many times as they want
    for (let i = 0; i < 15; i++) {
      waveTxn = await waveContract.wave();
      await waveTxn.wait();
    }

    // the owner can wave as many times as they want
    for (let i = 0; i < 13; i++) {
      waveTxn = await waveContract.connect(randomPerson).wave();
      await waveTxn.wait();
    }

    // waveTxn = await waveContract.connect(randomPerson).wave();
    // await waveTxn.wait();

    // waveTxn = await waveContract.connect(randomPerson).wave();
    // await waveTxn.wait();

    // waveTxn = await waveContract.connect(randomPerson).wave();
    // await waveTxn.wait();
  }
  catch(err) {
    console.log('Error: ' + err.message)
  }
  
  const ownerWaves = await waveContract.getTotalWavesByAddress( owner.address );
  console.log('Number of time the owner waved: ' + ownerWaves)

  const randoWaves = await waveContract.getTotalWavesByAddress( randomPerson.address );
  console.log('Number of time the rando waved: ' + randoWaves)
  
  waveCount = await waveContract.getTotalWaves();
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