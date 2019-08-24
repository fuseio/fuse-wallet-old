import 'package:flutter/material.dart';
import 'package:fusewallet/modals/businesses.dart';
import 'package:fusewallet/modals/transactions.dart';
import 'package:fusewallet/services/wallet_service.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:fusewallet/logic/crypto.dart' as crypto;
import 'package:flutter/widgets.dart';

ThunkAction initWalletCall() {
  return (Store store) async {
    loadCommunity(store);
    store.dispatch(new WalletLoadedAction());
  };
}

Future loadCommunity(Store store) async {
  var communityAddress = store.state.walletState.communityAddress;
  if ((communityAddress ?? "") == "") {
    communityAddress = DEFAULT_COMMUNITY;
  }
  var tokenAddress = await getTokenAddress(communityAddress);
  store.dispatch(new CommunityLoadedAction(communityAddress, tokenAddress));
  loadBalance(store);
  loadTransactions(store);
}

Future loadBalance(Store store) async {
  var publicKey = store.state.userState.user.publicKey;
  var tokenAddress = store.state.walletState.tokenAddress;
  var balance = await getBalance(publicKey, tokenAddress);
  store.dispatch(new BalanceLoadedAction(balance));
}

Future loadTransactions(Store store) {
  var publicKey = store.state.userState.user.publicKey;
  var tokenAddress = store.state.walletState.tokenAddress;
  getTransactions(publicKey, tokenAddress).then((list) {
    store.dispatch(new TransactionsLoadedAction(list));
  });
}

ThunkAction sendTransactionCall(BuildContext context, address, amount) {
  return (Store store) async {
    store.dispatch(new StartLoadingAction());
    crypto.sendNIS(crypto.cleanAddress(address), int.parse(amount), store.state.userState.user.privateKey)
      .then((ret) {
          Navigator.of(context).pop();
          Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text('Transaction sent successfully'),
            //duration: new Duration(seconds: 5),
          ));
        store.dispatch(new TransactionSentAction());
      });
    return true;
  };
}

ThunkAction loadBusinessesCall() {
  return (Store store) async {
    store.dispatch(new StartLoadingAction());
    getBusinesses().then((list) {
      store.dispatch(new BusinessesLoadedAction(list));
    });
    return true;
  };
}

ThunkAction switchCommunityCall(communityAddress) {
  return (Store store) async {
    store.dispatch(new SwitchCommunityAction(communityAddress));
    return true;
  };
}

class WalletLoadedAction {
  WalletLoadedAction();
}

class StartLoadingAction {
  StartLoadingAction();
}

class CommunityLoadedAction {
  final String communityAddress;
  final String tokenAddress;

  CommunityLoadedAction(this.communityAddress, this.tokenAddress);
}

class TransactionsLoadedAction {
  final TransactionList transactions;

  TransactionsLoadedAction(this.transactions);
}

class BalanceLoadedAction {
  final String balance;

  BalanceLoadedAction(this.balance);
}

class SendTransactionAction {
  SendTransactionAction();
}

class TransactionSentAction {
  TransactionSentAction();
}

class BusinessesLoadedAction {
  final List<Business> businessList;

  BusinessesLoadedAction(this.businessList);
}

class SwitchCommunityAction {
  final String address;

  SwitchCommunityAction(this.address);
}