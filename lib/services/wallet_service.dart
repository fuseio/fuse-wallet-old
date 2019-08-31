import 'dart:convert';
import 'package:absinthe_socket/absinthe_socket.dart';
import 'package:flutter/foundation.dart';
import 'package:fusewallet/modals/community.dart';
import 'package:fusewallet/modals/transactions.dart';
import 'package:fusewallet/modals/user.dart';
import 'crypto_service.dart';
import 'package:http/http.dart' as http;

const DEFAULT_COMMUNITY = '0x2B40007C57a2259bdd21CbE4e0ebDB3270C3D63D'; //'0xF846053684960eBF35aEa6Dc4F9317ebb2F7bF84';
const API_ROOT = 'https://studio-qa-ropsten.fusenet.io/api/v1/';
const EXPLORER_ROOT = 'https://explorer.fusenet.io/api?';

Future generateWallet(User user) async {
  if (user == null) {
    user = new User();
  }
  String mnemonic = generateMnemonic();
  user.mnemonic = mnemonic.split(" ");
  user.privateKey = await compute(getPrivateKeyFromMnemonic, mnemonic);
  user.publicKey = await getPublickKey(user.privateKey);

  //Call funder
  callFunder(user.publicKey);

  return user;
}

Future callFunder(publicKey) async {
  return await http.post(
      Uri.encodeFull("https://funder-qa.fusenet.io/api/balance/request/" + publicKey + "/" + DEFAULT_COMMUNITY),
      body: "",
      headers: {
        "Content-Type": "application/json"
      }).then((http.Response response) {});
}

Future getCommunity(communityAddress) async {
  print('Fetching community data for $communityAddress');
  return await http.get(Uri.encodeFull(API_ROOT + "communities?homeTokenAddress=" + communityAddress)).then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }

    Map<String, dynamic> obj = json.decode(response.body);
    var community = Community.fromJson(obj);

    print('Done fetching community data for $communityAddress');
    return community;
  });
}

Future getTokenInformation(communityAddress) async {
  return await http.get(Uri.encodeFull(API_ROOT + "tokens/" + communityAddress)).then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    Map<String, dynamic> obj = json.decode(response.body);
    return obj["data"]["symbol"];
  });
}

Future<String> getBalance(accountAddress, tokenAddress) async {
  print('Fetching balance of token $tokenAddress for account $accountAddress');
  var uri = Uri.encodeFull(EXPLORER_ROOT + 'module=account&action=tokenbalance&contractaddress=' + tokenAddress + '&address=' + accountAddress);
  var response = await http.get(uri);
  Map<String, dynamic> obj = json.decode(response.body);
  
  var balance = (BigInt.parse(obj['result']) / BigInt.from(1000000000000000000)).toStringAsFixed(1);
  print('Fetching balance of token $tokenAddress for account $accountAddress done. balance: $balance');
  return balance;
}

Future<TransactionList> getTransactions(accountAddress, tokenAddress) async {
  final response =
      await http.get('${EXPLORER_ROOT}module=account&action=tokentx&address=$accountAddress&contractaddress=$tokenAddress');

  if (response.statusCode == 200) {
    return TransactionList.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load transaction');
  }
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