const DStorage = artifacts.require("DStorage");
const StringUtils = artifacts.require("StringUtils");

module.exports = async function (deployer) {
  await deployer.deploy(StringUtils);
  const stringUtils = await StringUtils.deployed();

  await deployer.deploy(DStorage, stringUtils.address);
};
