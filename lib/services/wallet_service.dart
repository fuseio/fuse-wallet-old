import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:fusewallet/modals/user.dart';
import 'crypto_service.dart';
import 'package:http/http.dart' as http;

const DEFAULT_COMMUNITY = '0xF846053684960eBF35aEa6Dc4F9317ebb2F7bF84';
const API_ROOT = 'https://ropsten-qa.cln.network/api/v1/';
const EXPLORER_ROOT = 'https://explorer.fuse.io/api?';

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
      Uri.encodeFull(
          "https://funder-qa.fuse.io/api/balance/request/" + publicKey),
      body: "",
      headers: {
        "Content-Type": "application/json"
      }).then((http.Response response) {});
}

Future getTokenAddress(communityAddress) async {
  var community = await getCommunity(communityAddress);
  return community['homeTokenAddress'];
}

Future getCommunity(communityAddress) async {
  print('Fetching community data for $communityAddress');
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

Future<String> getBalance(accountAddress, tokenAddress) async {
  print('Fetching balance of token $tokenAddress for account $accountAddress');
  var uri = Uri.encodeFull(EXPLORER_ROOT + 'module=account&action=tokenbalance&contractaddress=' + tokenAddress + '&address=' + accountAddress);
  var response = await http.get(uri);
  Map<String, dynamic> obj = json.decode(response.body);
  
  var balance = (BigInt.parse(obj['result']) / BigInt.from(1000000000000000000)).toStringAsFixed(1);
  print('Fetching balance of token $tokenAddress for account $accountAddress done. balance: $balance');
  return balance;
}