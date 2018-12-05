var Web3= require('web3');
var config=require('../web3lib/config');
var fs=require('fs');
var execSync =require('child_process').execSync;
var web3sync = require('../web3lib/web3sync');
var BigNumber = require('bignumber.js');
var sha3 = require("../web3lib/sha3")

/*
*   npm install --save-dev babel-cli babel-preset-es2017
*   echo '{ "presets": ["es2017"] }' > .babelrc
*    npm install secp256k1
*   npm install keccak
*   npm install rlp
*/
if (typeof web3 !== 'undefined') {
	web3 = new Web3(web3.currentProvider);
} else {
	web3 = new Web3(new Web3.providers.HttpProvider(config.HttpProvider));
}

function getAbi(file){
	var abi=JSON.parse(fs.readFileSync(config.Ouputpath+"./"/*+file+".sol:"*/+file+".abi",'utf-8'));
	return abi;
}

function getAbi0(file){
	var abi=fs.readFileSync(config.Ouputpath+"./"/*+file+".sol:"*/+file+".abi",'utf-8');
	return abi;
}

async function sendTx(group, address, funcParam) {
  return new Promise((resolve, reject) => {
    var funcDesc = "{\"contract\":\""+address+"\", \"function\":\""+funcParam+"\"}";
    var func = "setPermission(address,string,string,bool)";
    var params = [address,sha3(funcParam).slice(0, 8),funcDesc,true];
    //console.log(params);
    var receipt = web3sync.sendRawTransaction(config.account, config.privKey, group.address, func, params);
    resolve(receipt);
  });
}

async function addPermission(group, address, funcParam, desc) {
  await sendTx(group, address, funcParam);
  return new Promise((resolve, reject) => {
    var ret = group.getPermission(address,sha3(funcParam).slice(0, 8));
    console.log(desc+funcParam+" authorized："+(ret?"Success":"Fail"));
    resolve(ret);
  });
}

(async function() {

    var MoneyTokenReceipt= await web3sync.rawDeploy(config.account, config.privKey,  "MoneyToken");
    console.log("Money Token deploy success, address: " + MoneyTokenReceipt.contractAddress);

    var WarrantTokenReceipt= await web3sync.rawDeploy(config.account, config.privKey,  "WarrantToken");
    console.log("Warrant Token deploy success, address: " + WarrantTokenReceipt.contractAddress);

    var SaleAuctionReceipt= await web3sync.rawDeploy(config.account, config.privKey,  "SaleAuction", ["address", "address"], [WarrantTokenReceipt.contractAddress, MoneyTokenReceipt.contractAddress]);
    console.log("Sale Auction deploy success, address: " + SaleAuctionReceipt.contractAddress);

})();
