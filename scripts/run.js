
const main = async () => {
  const [owner, randomPerson] = await hre.ethers.getSigners();
  const waveContractFactory = await hre.ethers.getContractFactory('WavePortal');
  const waveContract = await waveContractFactory.deploy();
  await waveContract.deployed();

  console.log("Contract deployed to:", waveContract.address);
  console.log("Contract deployed by:", owner.address);

  let waveCount;
  waveCount = await waveContract.getTotalWaves();
  
  let waveTxn = await waveContract.wave();
  await waveTxn.wait();

  waveTxn = await waveContract.connect(randomPerson).wave();
  await waveTxn.wait();

  waveTxn = await waveContract.connect(randomPerson).wave();
  await waveTxn.wait();

  await waveContract.getTotalWavesByAddress('0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266');
  await waveContract.getTotalWavesByAddress( randomPerson.address );
  
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