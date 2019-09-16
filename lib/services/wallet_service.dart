import 'dart:convert';
import 'dart:async';
import 'package:absinthe_socket/absinthe_socket.dart';
import 'package:flutter/foundation.dart';
import 'package:fusewallet/modals/businesses.dart';
import 'package:fusewallet/modals/community.dart';
import 'package:fusewallet/modals/transactions.dart';
import 'package:fusewallet/modals/user.dart';
import 'package:fusewallet/modals/token.dart';
import 'package:web3dart/web3dart.dart' as web3dart;
import 'crypto_service.dart';
import 'package:http/http.dart' as http;
import "package:web3dart/src/utils/numbers.dart" as numbers;
import 'package:http/http.dart';

const DEFAULT_TOKEN_ADDRESS = '0xBf5D6570a8B0245fADf2f2111e2AB6F4342fE62C';
const API_ROOT = 'https://studio-ropsten.fusenet.io/api/v1/';
const EXPLORER_ROOT = 'https://explorer.fusenet.io/api?';
const API_FUNDER = 'https://funder-qa.fusenet.io/api';

Future generateWallet(User user) async {
  if (user == null) {
    user = new User();
  }
  String mnemonic = generateMnemonic();
  user.mnemonic = mnemonic.split(" ");
  user.privateKey = await compute(getPrivateKeyFromMnemonic, mnemonic);
  user.publicKey = await getPublickKey(user.privateKey);

  //Call funder
  fundNative(user.publicKey);

  return user;
}

Future fundNative(accountAddress) async {
  print("requesting native funding for account $accountAddress");
  var body = '{ "accountAddress": "$accountAddress"}';

  return await http.post(Uri.encodeFull("$API_FUNDER/fund/native"), body: body, headers: {
    "Content-Type": "application/json"
  }).then((http.Response response) {
    print('native funding for account $accountAddress succeeded');
  });
}

Future fundToken(accountAddress, tokenAddress) async {
  print("requesting token funding of $tokenAddress for account $accountAddress ");
  var body = '{ "accountAddress": "$accountAddress", "tokenAddress": "$tokenAddress"}';

  return await http.post(Uri.encodeFull("$API_FUNDER/fund/token"), body: body, headers: {
    "Content-Type": "application/json"
  }).then((http.Response response) {
    print('token funding of $tokenAddress for account $accountAddress succeeded');
  });
}

Future getCommunity(tokenAddress) async {
  print('Fetching community data by the token address: $tokenAddress');
  return await http.get(Uri.encodeFull(API_ROOT + "communities?homeTokenAddress=" + tokenAddress)).then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }

    Map<String, dynamic> obj = json.decode(response.body);
    if (obj["data"] == null) {
      throw new Exception("No token information found");
    }
    var community = Community.fromJson(obj["data"]);
    print('Done fetching community data for $tokenAddress');
    return community;
  });
}

Future getToken(tokenAddress) async {
  return await http.get(Uri.encodeFull(API_ROOT + "tokens/" + tokenAddress)).then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    Map<String, dynamic> obj = json.decode(response.body);
    if (obj["data"] == null) {
      throw new Exception("No token information found");
    }
    var token = Token.fromJson(obj["data"]);
    print('Done fetching token data for $tokenAddress');
    return token;
  });
}

Future<String> getBalance(accountAddress, tokenAddress) async {
  var uri = Uri.encodeFull(EXPLORER_ROOT + 'module=account&action=tokenbalance&contractaddress=' + tokenAddress + '&address=' + accountAddress);
  var response = await http.get(uri);
  Map<String, dynamic> obj = json.decode(response.body);
  
  if (obj['result'] == "") {
    return "0";
  }
  var balance = (BigInt.parse(obj['result']) / BigInt.from(1000000000000000000)).toStringAsFixed(1);
  print('Fetching balance of token $tokenAddress for account $accountAddress done. balance: $balance');
  return balance;
}

Future<TransactionList> getTransactions(accountAddress, tokenAddress) async {
  print('Fetching transactions of token $tokenAddress for account $accountAddress done.');
  final response =
      await http.get('${EXPLORER_ROOT}module=account&action=tokentx&address=$accountAddress&contractaddress=$tokenAddress');

  if (response.statusCode == 200) {
    return TransactionList.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load transaction');
  }
}

Future<List<Business>> getBusinesses(communityAddress) async {
  print('Fetching businesses for commnuity: $communityAddress');
  return http.get(API_ROOT + "entities/" + communityAddress + "?type=business&withMetadata=true").then((response) {
    List<Business> businessList = new List();
    final dynamic responseJson = json.decode(response.body);
    responseJson["data"].forEach((f) => businessList.add(new Business.fromJson(f)));
    print('Done Fetching businesses for commnuity: $communityAddress. length: ${businessList.length}');
    return businessList;
  });
}

const String _URL = "https://rpc.fusenet.io";
const String _ABI_EXTRACT =
    '[ { "constant": true, "inputs": [], "name": "name", "outputs": [ { "name": "", "type": "string" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [ { "name": "_spender", "type": "address" }, { "name": "_value", "type": "uint256" } ], "name": "approve", "outputs": [ { "name": "success", "type": "bool" } ], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": true, "inputs": [], "name": "totalSupply", "outputs": [ { "name": "", "type": "uint256" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [ { "name": "_tokenContract", "type": "address" } ], "name": "withdrawAltcoinTokens", "outputs": [ { "name": "", "type": "bool" } ], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": false, "inputs": [ { "name": "_from", "type": "address" }, { "name": "_to", "type": "address" }, { "name": "_amount", "type": "uint256" } ], "name": "transferFrom", "outputs": [ { "name": "success", "type": "bool" } ], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": true, "inputs": [], "name": "decimals", "outputs": [ { "name": "", "type": "uint256" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [], "name": "withdraw", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": false, "inputs": [ { "name": "_value", "type": "uint256" } ], "name": "burn", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": false, "inputs": [ { "name": "_participant", "type": "address" }, { "name": "_amount", "type": "uint256" } ], "name": "adminClaimAirdrop", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": false, "inputs": [ { "name": "_addresses", "type": "address[]" }, { "name": "_amount", "type": "uint256" } ], "name": "adminClaimAirdropMultiple", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": true, "inputs": [ { "name": "_owner", "type": "address" } ], "name": "balanceOf", "outputs": [ { "name": "", "type": "uint256" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [], "name": "symbol", "outputs": [ { "name": "", "type": "string" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [], "name": "finishDistribution", "outputs": [ { "name": "", "type": "bool" } ], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": false, "inputs": [ { "name": "_tokensPerEth", "type": "uint256" } ], "name": "updateTokensPerEth", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": false, "inputs": [ { "name": "_to", "type": "address" }, { "name": "_amount", "type": "uint256" } ], "name": "transfer", "outputs": [ { "name": "success", "type": "bool" } ], "payable": true, "stateMutability": "payable", "type": "function" }, { "constant": false, "inputs": [], "name": "getTokens", "outputs": [], "payable": true, "stateMutability": "payable", "type": "function" }, { "constant": true, "inputs": [], "name": "minContribution", "outputs": [ { "name": "", "type": "uint256" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [], "name": "distributionFinished", "outputs": [ { "name": "", "type": "bool" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [ { "name": "tokenAddress", "type": "address" }, { "name": "who", "type": "address" } ], "name": "getTokenBalance", "outputs": [ { "name": "", "type": "uint256" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [], "name": "tokensPerEth", "outputs": [ { "name": "", "type": "uint256" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [ { "name": "_owner", "type": "address" }, { "name": "_spender", "type": "address" } ], "name": "allowance", "outputs": [ { "name": "", "type": "uint256" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [], "name": "totalDistributed", "outputs": [ { "name": "", "type": "uint256" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [ { "name": "newOwner", "type": "address" } ], "name": "transferOwnership", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "inputs": [], "payable": false, "stateMutability": "nonpayable", "type": "constructor" }, { "anonymous": false, "inputs": [ { "indexed": true, "name": "_from", "type": "address" }, { "indexed": true, "name": "_to", "type": "address" }, { "indexed": false, "name": "_value", "type": "uint256" } ], "name": "Transfer", "type": "event", "stateMutability": "view" }, { "anonymous": false, "inputs": [ { "indexed": true, "name": "_owner", "type": "address" }, { "indexed": true, "name": "_spender", "type": "address" }, { "indexed": false, "name": "_value", "type": "uint256" } ], "name": "Approval", "type": "event", "stateMutability": "view" }, { "anonymous": false, "inputs": [ { "indexed": true, "name": "to", "type": "address" }, { "indexed": false, "name": "amount", "type": "uint256" } ], "name": "Distr", "type": "event", "stateMutability": "view" }, { "anonymous": false, "inputs": [], "name": "DistrFinished", "type": "event", "stateMutability": "view" }, { "anonymous": false, "inputs": [ { "indexed": true, "name": "_owner", "type": "address" }, { "indexed": false, "name": "_amount", "type": "uint256" }, { "indexed": false, "name": "_balance", "type": "uint256" } ], "name": "Airdrop", "type": "event", "stateMutability": "view" }, { "anonymous": false, "inputs": [ { "indexed": false, "name": "_tokensPerEth", "type": "uint256" } ], "name": "TokensPerEthUpdated", "type": "event", "stateMutability": "view" }, { "anonymous": false, "inputs": [ { "indexed": true, "name": "burner", "type": "address" }, { "indexed": false, "name": "value", "type": "uint256" } ], "name": "Burn", "type": "event", "stateMutability": "view" } ]';

Future sendTransaction(address, amount, tokenAddress, privateKey) async {
  var httpClient = new Client();
  var ethClient = new web3dart.Web3Client(_URL, httpClient);

  var credentials = web3dart.Credentials.fromPrivateKeyHex(privateKey);
  var contractABI = web3dart.ContractABI.parseFromJSON(_ABI_EXTRACT, "cln");
  var contract = new web3dart.DeployedContract(
      contractABI, new web3dart.EthereumAddress(tokenAddress), ethClient, credentials);

  var getKittyFn = contract.findFunctionsByName("transfer").first;
  address = cleanAddress(address);
  var n = BigInt.parse(numbers.strip0x(address), radix: 16);

  try {
      var response = await new web3dart.Transaction(
          keys: credentials,
          maximumGas: 100000,
          gasPrice: web3dart.EtherAmount.fromUnitAndValue(web3dart.EtherUnit.gwei, 3))
      .prepareForPaymentCall(
          contract,
          getKittyFn,
          [n, BigInt.from(amount) * BigInt.from(1000000000000000000)],
          web3dart.EtherAmount.zero())
      .send(ethClient, chainId: 122);

      return "000";
  } catch (e) {
    return e.toString();
  }
}

String cleanAddress(address) {
  address = address.toString().replaceAll("ethereum:", "");
  return address;
}

initSocket(_onStart) async {
  var _socket = AbsintheSocket("wss://explorer.fusenet.io/socket/websocket");
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