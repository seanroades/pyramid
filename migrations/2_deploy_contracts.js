const TriangleCoin = artifacts.require("./TriangleCoin.sol");

// The second argument is the total inital supply, e.g., how much the original supplier will get.
module.exports = function(deployer) {
  deployer.deploy(TriangleCoin);
};