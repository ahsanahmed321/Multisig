const path = require("path");
const fs = require("fs");
const solc = require("solc");

const multisigPath = path.resolve(__dirname, "contracts", "MultiSig.sol");
const source = fs.readFileSync(multisigPath, "utf8");

const input = {
  language: "Solidity",
  sources: {
    "MultiSig.sol": {
      content: source,
    },
  },
  settings: {
    outputSelection: {
      "*": {
        "*": ["*"],
      },
    },
  },
};

module.exports = JSON.parse(solc.compile(JSON.stringify(input))).contracts[
  "MultiSig.sol"
].MultiSig;
