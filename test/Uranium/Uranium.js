const { BN, expectRevert, send, ether } = require('@openzeppelin/test-helpers');
const baseContract  = artifacts.require ("./Uranium.sol");

contract("Uranium", async accounts => {

  var deployedContract

  it('should be able to deploy', async () => {
    deployedContract = await baseContract.new({from: accounts[0]})
  });
  
  it('should be able to start', async () => {
    await deployedContract.startAttack({value: web3.utils.toWei("1"), from: accounts[0]})
  });

});