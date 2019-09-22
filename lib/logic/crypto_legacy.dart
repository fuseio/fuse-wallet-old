import 'dart:async';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'dart:math';
import "package:web3dart/src/utils/numbers.dart" as numbers;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:web3dart/src/contracts/abi.dart';
import 'package:web3dart/src/utils/amounts.dart';
import 'package:absinthe_socket/absinthe_socket.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:hex/hex.dart';

const DEFAULT_COMMUNITY = '0xF846053684960eBF35aEa6Dc4F9317ebb2F7bF84';

const API_ROOT = 'https://studio-ropsten.fusenet.io/api/v1/';
const EXPLORER_ROOT = 'https://explorer.fusenet.io/api?';
// const API_ROOT = 'http://localhost:3000/api/v1/';

const String _ABI_EXTRACT =
    '[ { "constant": true, "inputs": [], "name": "name", "outputs": [ { "name": "", "type": "string" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [ { "name": "_spender", "type": "address" }, { "name": "_value", "type": "uint256" } ], "name": "approve", "outputs": [ { "name": "success", "type": "bool" } ], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": true, "inputs": [], "name": "totalSupply", "outputs": [ { "name": "", "type": "uint256" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [ { "name": "_tokenContract", "type": "address" } ], "name": "withdrawAltcoinTokens", "outputs": [ { "name": "", "type": "bool" } ], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": false, "inputs": [ { "name": "_from", "type": "address" }, { "name": "_to", "type": "address" }, { "name": "_amount", "type": "uint256" } ], "name": "transferFrom", "outputs": [ { "name": "success", "type": "bool" } ], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": true, "inputs": [], "name": "decimals", "outputs": [ { "name": "", "type": "uint256" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [], "name": "withdraw", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": false, "inputs": [ { "name": "_value", "type": "uint256" } ], "name": "burn", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": false, "inputs": [ { "name": "_participant", "type": "address" }, { "name": "_amount", "type": "uint256" } ], "name": "adminClaimAirdrop", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": false, "inputs": [ { "name": "_addresses", "type": "address[]" }, { "name": "_amount", "type": "uint256" } ], "name": "adminClaimAirdropMultiple", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": true, "inputs": [ { "name": "_owner", "type": "address" } ], "name": "balanceOf", "outputs": [ { "name": "", "type": "uint256" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [], "name": "symbol", "outputs": [ { "name": "", "type": "string" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [], "name": "finishDistribution", "outputs": [ { "name": "", "type": "bool" } ], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": false, "inputs": [ { "name": "_tokensPerEth", "type": "uint256" } ], "name": "updateTokensPerEth", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": false, "inputs": [ { "name": "_to", "type": "address" }, { "name": "_amount", "type": "uint256" } ], "name": "transfer", "outputs": [ { "name": "success", "type": "bool" } ], "payable": true, "stateMutability": "payable", "type": "function" }, { "constant": false, "inputs": [], "name": "getTokens", "outputs": [], "payable": true, "stateMutability": "payable", "type": "function" }, { "constant": true, "inputs": [], "name": "minContribution", "outputs": [ { "name": "", "type": "uint256" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [], "name": "distributionFinished", "outputs": [ { "name": "", "type": "bool" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [ { "name": "tokenAddress", "type": "address" }, { "name": "who", "type": "address" } ], "name": "getTokenBalance", "outputs": [ { "name": "", "type": "uint256" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [], "name": "tokensPerEth", "outputs": [ { "name": "", "type": "uint256" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [ { "name": "_owner", "type": "address" }, { "name": "_spender", "type": "address" } ], "name": "allowance", "outputs": [ { "name": "", "type": "uint256" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [], "name": "totalDistributed", "outputs": [ { "name": "", "type": "uint256" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [ { "name": "newOwner", "type": "address" } ], "name": "transferOwnership", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "inputs": [], "payable": false, "stateMutability": "nonpayable", "type": "constructor" }, { "anonymous": false, "inputs": [ { "indexed": true, "name": "_from", "type": "address" }, { "indexed": true, "name": "_to", "type": "address" }, { "indexed": false, "name": "_value", "type": "uint256" } ], "name": "Transfer", "type": "event", "stateMutability": "view" }, { "anonymous": false, "inputs": [ { "indexed": true, "name": "_owner", "type": "address" }, { "indexed": true, "name": "_spender", "type": "address" }, { "indexed": false, "name": "_value", "type": "uint256" } ], "name": "Approval", "type": "event", "stateMutability": "view" }, { "anonymous": false, "inputs": [ { "indexed": true, "name": "to", "type": "address" }, { "indexed": false, "name": "amount", "type": "uint256" } ], "name": "Distr", "type": "event", "stateMutability": "view" }, { "anonymous": false, "inputs": [], "name": "DistrFinished", "type": "event", "stateMutability": "view" }, { "anonymous": false, "inputs": [ { "indexed": true, "name": "_owner", "type": "address" }, { "indexed": false, "name": "_amount", "type": "uint256" }, { "indexed": false, "name": "_balance", "type": "uint256" } ], "name": "Airdrop", "type": "event", "stateMutability": "view" }, { "anonymous": false, "inputs": [ { "indexed": false, "name": "_tokensPerEth", "type": "uint256" } ], "name": "TokensPerEthUpdated", "type": "event", "stateMutability": "view" }, { "anonymous": false, "inputs": [ { "indexed": true, "name": "burner", "type": "address" }, { "indexed": false, "name": "value", "type": "uint256" } ], "name": "Burn", "type": "event", "stateMutability": "view" } ]';
//const String _URL = "http://etheth653-dns-reg1.westeurope.cloudapp.azure.com:8540";
const String _URL = "https://rpc.fusenet.io";
//const String _Asset = "0xf386d8d1dc00749e50fe5b7fae185aff42f7f30f";
String _Asset = "0x415c11223bca1324f470cf72eac3046ea1e755a3";
final storage = new FlutterSecureStorage();

Future getBalance(accountAddress, tokenAddress) async {
  print('Fetching balance of token $tokenAddress for account $accountAddress');
  var uri = Uri.encodeFull(EXPLORER_ROOT + 'module=account&action=tokenbalance&contractaddress=' + tokenAddress + '&address=' + accountAddress);
  var response = await http.get(uri);
  Map<String, dynamic> obj = json.decode(response.body);
  
  var balance = (BigInt.parse(obj['result']) / BigInt.from(1000000000000000000)).toStringAsFixed(1);
  print('Fetching balance of token $tokenAddress for account $accountAddress done. balance: $balance');
  return balance;
}

Future sendNIS(address, amount, privateKey) async {
  var httpClient = new Client();
  var ethClient = new Web3Client(_URL, httpClient);

  if (privateKey == null) {
    privateKey = await getPrivateKey();
  }

  var credentials = Credentials.fromPrivateKeyHex(privateKey);
  var contractABI = ContractABI.parseFromJSON(_ABI_EXTRACT, "cln");
  var contract = new DeployedContract(
      contractABI, new EthereumAddress(await getTokenAddress()), ethClient, credentials);

//, EtherAmount.fromUnitAndValue(EtherUnit.gwei, 1)
  var getKittyFn = contract.findFunctionsByName("transfer").first;
  address = cleanAddress(address);
  var n = BigInt.parse(numbers.strip0x(address), radix: 16);
  var kittenResponse = await new Transaction(
          keys: credentials,
          maximumGas: 100000,
          gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 3))
      .prepareForPaymentCall(
          contract,
          getKittyFn,
          [n, BigInt.from(amount) * BigInt.from(1000000000000000000)],
          EtherAmount.zero())
      .send(ethClient, chainId: 121);
  print(kittenResponse);

  return true;
}

String cleanAddress(address) {
  address = address.toString().replaceAll("ethereum:", "");
  return address;
}

Future callFunder(publicKey) async {
  return await http.post(Uri.encodeFull("https://funder-qa.fuse.io/api/balance/request/" + publicKey), body: "", headers: {
    "Content-Type": "application/json"
  }).then((http.Response response) {

  });
}

Future generatePrivateKey() async {
  var rng = new Random.secure();
  Credentials random = Credentials.createRandom(rng);
  return numbers.toHex(random.privateKey);
}

String generateMnemonic() {
  return bip39.generateMnemonic();
}


void setPrivateKey(pk) async {
  //final prefs = await SharedPreferences.getInstance();
  //prefs.setString("pk", pk);
  await storage.write(key: "privateKey", value: pk);
}

String getPrivateKeyFromMnemonic(mnemonic) {
  String seed = bip39.mnemonicToSeedHex(mnemonic);
  bip32.BIP32 root = bip32.BIP32.fromSeed(HEX.decode(seed));
  bip32.BIP32 child = root.derivePath("m/44'/60'/0'/0/0");
  String privateKey = HEX.encode(child.privateKey);
  return privateKey;
}

Future getPrivateKey() async {
  /*
  String mnemonic = await storage.read(key: "mnemonic");
  if (mnemonic == "" || mnemonic == null) {
    return "";
  }
  String privateKey = getPrivateKeyFromMnemonic(mnemonic);
  return privateKey;
  */
  
  return await storage.read(key: "privateKey");
}

Future getPublickKey() async {
  var privateKey = await getPrivateKey();
  if (privateKey == null) {
    return "";
  }
  var credentials = Credentials.fromPrivateKeyHex(privateKey);
  return credentials.address.hex;
}

Future getAssetID() async {
  var id = await storage.read(key: "assetID");
  if (id == null || id == "") {
    id = "0x415c11223bca1324f470cf72eac3046ea1e755a3";
  }
  return id;
}

Future setAssetID(value) async {
  await storage.write(key: "assetID", value: value);
}

Future setCommunityAddress(communityAddress) async {
  await storage.write(key: "communityAddress", value: communityAddress);
}

Future getCommunityAddress() async {
  var id = await storage.read(key: "communityAddress");
  if (id == null || id == "") {
    id = DEFAULT_COMMUNITY;
  }
  return id;
}

Future getCommunity(communityAddress) async {
  print('Fetching community data for $communityAddress');
  print('yoyoyo');
  return await http.get(Uri.encodeFull(API_ROOT + "communities/" + communityAddress)).then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    Map<String, dynamic> obj = json.decode(response.body);

    print('Done fetching community data for $communityAddress');
    return obj["data"];
  });
}

Future intializeCommunity(communityAddress) async {
  setCommunityAddress(communityAddress);
  getCommunity(communityAddress).then((community) {
    setTokenAddress(community['homeTokenAddress']);
  });
}

Future setCommunity(community) async {
  await storage.write(key: "tokenAddress", value: community.homeTokenAddress);
}

Future setTokenAddress(tokenAddress) async {
  await storage.write(key: "tokenAddress", value: tokenAddress);
}

Future getTokenAddress() async {
  var token = await storage.read(key: "tokenAddress");
  if (token == null || token == "") {
    token = DEFAULT_COMMUNITY;
  }
  return token;
}

Future<dynamic> getEntityCount() async {
  String url = "http://etheth653-dns-reg1.westeurope.cloudapp.azure.com:8540";

  var body =
      '{ "jsonrpc":"2.0", "method": "eth_call", "params":[ { "to": "0x381ac27b55e0c30ed214ab560b1f73b921080c2c", "data": "0x5d1b45b5" } ], "id": 1  }';

  return await http.post(Uri.encodeFull(url), body: body, headers: {
    "Content-Type": "application/json"
  }).then((http.Response response) {
    //      print(response.body);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    Map<String, dynamic> obj = json.decode(response.body);

    return numbers.hexToInt(obj["result"].toString()) /
        BigInt.from(1000000000000000000);
  });
}

Future<dynamic> getEntityList() async {
  String url = "http://etheth653-dns-reg1.westeurope.cloudapp.azure.com:8540";

  var body =
      '{ "jsonrpc":"2.0", "method": "eth_call", "params":[ { "to": "0x381ac27b55e0c30ed214ab560b1f73b921080c2c", "data": "0x404cbffb0000000000000000000000000000000000000000000000000000000000000000" } ], "id": 1  }';

  return await http.post(Uri.encodeFull(url), body: body, headers: {
    "Content-Type": "application/json"
  }).then((http.Response response) {
    print(response.body);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    Map<String, dynamic> obj = json.decode(response.body);

    return numbers.hexToInt(obj["result"].toString()) /
        BigInt.from(1000000000000000000);
  });
}

Future<dynamic> getEntity() async {

  var body =
      '{ "jsonrpc":"2.0", "method": "eth_call", "params":[ { "to": "0x6eca7b83135c70bdbd4d862792b8c73225362990", "data": "0x070c412b000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000013100000000000000000000000000000000000000000000000000000000000000" } ], "id": 1  }';

  var assetID = await getAssetID();
  return await http.post(Uri.encodeFull(_URL), body: body, headers: {
    "Content-Type": "application/json"
  }).then((http.Response response) {
    print(response.body);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    Map<String, dynamic> obj = json.decode(response.body);
    
    var abi = '[ { "constant": true, "inputs": [ { "name": "", "type": "uint256" } ], "name": "entityList", "outputs": [ { "name": "", "type": "string" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [ { "name": "", "type": "address" } ], "name": "admins", "outputs": [ { "name": "", "type": "uint256" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [], "name": "renounceOwnership", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": true, "inputs": [], "name": "owner", "outputs": [ { "name": "", "type": "address" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [], "name": "isOwner", "outputs": [ { "name": "", "type": "bool" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [ { "name": "newOwner", "type": "address" } ], "name": "transferOwnership", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "inputs": [], "payable": false, "stateMutability": "nonpayable", "type": "constructor" }, { "anonymous": false, "inputs": [ { "indexed": true, "name": "previousOwner", "type": "address" }, { "indexed": true, "name": "newOwner", "type": "address" } ], "name": "OwnershipTransferred", "type": "event" }, { "constant": true, "inputs": [], "name": "getEntityCount", "outputs": [ { "name": "", "type": "uint256" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [ { "name": "_entityId", "type": "string" }, { "name": "_account", "type": "address" }, { "name": "_name", "type": "string" }, { "name": "_description", "type": "string" }, { "name": "_address", "type": "string" }, { "name": "_image", "type": "string" } ], "name": "newEntity", "outputs": [ { "name": "", "type": "bool" } ], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": false, "inputs": [ { "name": "_entityId", "type": "string" }, { "name": "_account", "type": "address" }, { "name": "_name", "type": "string" }, { "name": "_description", "type": "string" }, { "name": "_address", "type": "string" }, { "name": "_image", "type": "string" } ], "name": "updateEntity", "outputs": [ { "name": "", "type": "bool" } ], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": true, "inputs": [ { "name": "_entityId", "type": "string" } ], "name": "getEntity", "outputs": [ { "components": [ { "name": "_account", "type": "address" }, { "name": "_name", "type": "string" }, { "name": "_description", "type": "string" }, { "name": "_address", "type": "string" }, { "name": "_image", "type": "string" }, { "name": "_listPointer", "type": "uint256" } ], "name": "", "type": "tuple" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [ { "name": "_entityId", "type": "string" } ], "name": "deleteEntity", "outputs": [ { "name": "", "type": "bool" } ], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": false, "inputs": [ { "name": "_address", "type": "address" } ], "name": "addAdmin", "outputs": [ { "name": "", "type": "bool" } ], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": false, "inputs": [ { "name": "_address", "type": "address" } ], "name": "removeAdmin", "outputs": [ { "name": "", "type": "bool" } ], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": true, "inputs": [ { "name": "_address", "type": "address" } ], "name": "isAdmin", "outputs": [ { "name": "", "type": "bool" } ], "payable": false, "stateMutability": "view", "type": "function" } ]';
    var privateKey = getPrivateKey().then((privateKey) {
      var httpClient = new Client();
      var ethClient = new Web3Client(_URL, httpClient);
      var credentials = Credentials.fromPrivateKeyHex(privateKey);
      var contractABI = ContractABI.parseFromJSON(abi, "cln");
      var contract = new DeployedContract(
          contractABI, new EthereumAddress(assetID), ethClient, credentials);
      var getFn = contract.findFunctionsByName("getEntity").first;
      print(getFn.decodeReturnValues(obj["result"].toString()));
    });

//print(HEX.decode(obj["result"].toString()));

    return numbers.hexToInt(obj["result"].toString()) /
        BigInt.from(1000000000000000000);
  });
}

  initSocket(_onStart) async {
    var _socket = AbsintheSocket("wss://explorer.fuse.io/socket/websocket");
    Observer _categoryObserver = Observer(
        //onAbort: _onStart,
        //onCancel: _onStart,
        //onError: _onStart,
        onResult: _onStart,
        //onStart: _onStart
        );

    Notifier notifier = _socket.send(GqlRequest(
        operation:
            "subscription { tokenTransfers(tokenContractAddressHash: \"0x415c11223bca1324f470cf72eac3046ea1e755a3\") { amount, fromAddressHash, toAddressHash }}"));
    notifier.observe(_categoryObserver);
  }
