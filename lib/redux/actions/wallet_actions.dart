import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fusewallet/modals/businesses.dart';
import 'package:fusewallet/modals/community.dart';
import 'package:fusewallet/modals/token.dart';
import 'package:fusewallet/modals/transactions.dart';
import 'package:fusewallet/services/wallet_service.dart';
import 'package:fusewallet/widgets/bonusDialog.dart';
// import 'package:fusewallet/widgets/widgets.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:flutter/widgets.dart';
import 'package:fusewallet/logic/globals.dart' as globals;

//ThunkAction openWalletCall(BuildContext context, { bool firstTime = false }) {
//  return (Store store) async {
//var localAuth = LocalAuthentication();
//bool didAuthenticate =
//await localAuth.authenticateWithBiometrics(localizedReason: 'Please authenticate to open the wallet');

//    openPageReplace(context, WalletPage());
//  };
//}

// ThunkAction initWalletCall(BuildContext context) {
//   return (Store store) async {

//     var isFirstTime = store.state.walletState.community == null;

//     await loadCommunity(store);

//     /// Show bonus dialog
//     if (isFirstTime && store.state.walletState.community != null) {
//       new Future.delayed(Duration.zero, () {
//         showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return BonusDialog();
//             });

//       });
//     }

//     store.dispatch(new WalletLoadedAction());
//   };
// }

ThunkAction loadBalancesCall(BuildContext context) {
  return (Store store) async {
    await loadBalances(store);
  };
}

Future loadCommunity(Store store, tokenAddress, env, originNetwork) async {
  var token = await getToken(tokenAddress, env, originNetwork);
  var commmunity = await getCommunity(tokenAddress, env, originNetwork);
  store
      .dispatch(new TokenLoadedAction(tokenAddress, token, env, originNetwork));
  store.dispatch(new CommunityLoadedAction(tokenAddress, commmunity));

  loadBalances(store);
  new Timer.periodic(Duration(seconds: 3), (timer) {
    try {
      loadBalances(store);
    } catch (e) {}
  });
}

Future joinCommunity(Store store) async {
  // var tokenAddress = store.state.walletState.community.communityA;
}

Future fundTokenCall(Store store, env, originNetwork) async {
  var tokenAddress = store.state.walletState.tokenAddress;
  var publicKey = store.state.userState.user.publicKey;
  var privateKey = store.state.userState.user.privateKey;
  await fundToken(publicKey, tokenAddress, env, originNetwork, privateKey);
}

Future loadBalances(Store store) async {
  loadBalance(store);
  loadTransactions(store);
}

Future loadBalance(Store store) async {
  var publicKey = store.state.userState.user?.publicKey;
  var tokenAddress = store.state.walletState.tokenAddress;
  if (publicKey != "" && tokenAddress != "") {
    try {
      var balance = await getBalance(publicKey, tokenAddress);
      if (balance != store.state.walletState.balance) {
        store.dispatch(new BalanceLoadedAction(balance));
      }
    } catch (e) {
      print(e);
      print(
          'Balance could not be loaded for account $publicKey, tokenAddress: $tokenAddress');
      store.dispatch(new BalanceLoadedAction('0'));
    }
  }
}

Future loadTransactions(Store store) async {
  var publicKey = store.state.userState.user?.publicKey;
  var tokenAddress = store.state.walletState.tokenAddress;
  if (publicKey != "" && tokenAddress != "") {
    try {
      var list = await getTransactions(publicKey, tokenAddress);
      if (store.state.walletState.transactions != null) {
        if (list.transactions.length !=
            store.state.walletState.transactions.transactions.length) {
          list.pendingTransactions = new List<Transaction>();
        } else {
          list.pendingTransactions =
              store.state.walletState.transactions.pendingTransactions;
        }
      }
      if (list.transactions.length !=
          store.state.walletState.transactions.transactions.length) {
        store.dispatch(new TransactionsLoadedAction(list));
      }
    } catch (e) {
      print(e);
      print(
          'Transactions list could not be loaded for account $publicKey, tokenAddress: $tokenAddress');
      var list = new TransactionList(
          transactions: new List<Transaction>(),
          pendingTransactions: new List<Transaction>());
      store.dispatch(new TransactionsLoadedAction(list));
    }
  }
}

ThunkAction sendAmountCall(amount) {
  return (Store store) async {
    store.dispatch(new SendAmountAction(amount));
    return true;
  };
}

ThunkAction sendToBusinessAddressCall(address) {
  return (Store store) async {
    store.dispatch(new SendToBusinessAddressAction(address));
    return true;
  };
}

ThunkAction sendAddressCall(address) {
  print('address address address address address');
  print(address);
  return (Store store) async {
    store.dispatch(new SendAddressAction(address));
    return true;
  };
}

ThunkAction sendTransactionCall(BuildContext context) {
  return (Store store) async {
    if (store.state.walletState.sendAddress == "") {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("Please enter a valid address"),
      ));
      return false;
    }
    if (store.state.walletState.sendAmount <= 0) {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("Please enter amount"),
      ));
      return false;
    }

    store.dispatch(new StartLoadingAction());
    sendTransaction(
            cleanAddress(store.state.walletState.sendAddress),
            store.state.walletState.sendAmount,
            store.state.walletState.tokenAddress,
            store.state.userState.user.privateKey)
        .then((ret) {
      if (ret == "000") {
        store.dispatch(new ResetAddresses());
        Navigator.of(context).pop(true);
        Navigator.of(context).pop(true);
        //new Future.delayed(Duration(seconds: 1), () {
        //sendSuccessBottomSheet(globals.scaffoldKey.currentContext);
        //});

        store.dispatch(addPendingTransaction(store.state.walletState.sendAmount,
            store.state.userState.user.publicKey, ""));
      } else {
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text(ret),
          //duration: new Duration(seconds: 5),
        ));
      }
      store.dispatch(new TransactionSentAction());
    });
    return true;
  };
}

ThunkAction addPendingTransaction(amount, from, to) {
  return (Store store) async {
    TransactionList transactions = store.state.walletState.transactions;
    if (transactions == null) {
      transactions = new TransactionList(
          transactions: new List<Transaction>(),
          pendingTransactions: new List<Transaction>());
    }
    transactions.pendingTransactions.add(Transaction(
        from: from,
        to: to,
        tokenSymbol: store.state.walletState.token.symbol,
        pending: true,
        date: DateTime.now(),
        amount: amount));
    store.dispatch(new TransactionsLoadedAction(transactions));
    return true;
  };
}

ThunkAction loadBusinessesCall() {
  return (Store store) async {
    store.dispatch(new StartLoadingAction());
    getBusinesses(
            store.state.walletState.community.communityAddress,
            store.state.walletState.environment,
            store.state.walletState.originNetwork)
        .then((list) {
      store.dispatch(new BusinessesLoadedAction(list));
    });
    return true;
  };
}

// ThunkAction switchCommunityCall(BuildContext context, communityAddress) {
//   return (Store store) async {

//     store.dispatch(new LogoutAction());
//     store.dispatch(new CommunityLoadedAction(communityAddress, null));
//     store.dispatch(initWalletCall(context));
//     //store.dispatch(new SwitchCommunityAction(communityAddress));
//     return true;
//   };
// }

ThunkAction switchCommunityCall(
    BuildContext context, _tokenAddress, _env, _originNetwork) {
  return (Store store) async {
    // store.dispatch(new LogoutAction());
    // store.dispatch(new TokenLoadedAction(tokenAddress, null));
    // store.dispatch(new CommunityLoadedAction(tokenAddress, null));

    var isFirstTime = store.state.walletState.community == null;
    var tokenAddress = store.state.walletState.tokenAddress;
    var env = store.state.walletState.environment;
    var originNetwork = store.state.walletState.originNetwork;

    if (_tokenAddress != null) {
      tokenAddress = _tokenAddress;
    }

    if (_env != null) {
      env = _env;
    }

    if (_originNetwork != null) {
      originNetwork = _originNetwork;
    }

    if (tokenAddress == null || tokenAddress == "") {
      tokenAddress = DEFAULT_TOKEN_ADDRESS;
    }

    if (env == null || env == "") {
      env = DEFAULT_ENV;
    }

    if (originNetwork == null || originNetwork == "") {
      originNetwork = DEFAULT_ORIGIN_NETWORK;
    }

    await loadCommunity(store, tokenAddress, env, originNetwork);
    // await joinCommunity(store);
    await getPeriodicStream(
        store.state.userState.user,
        store.state.walletState.community.communityAddress,
        tokenAddress,
        env,
        originNetwork);
    fundTokenCall(store, env, originNetwork);

    store.dispatch(new WalletLoadedAction());
    // store.dispatch(initWalletCall(context));
    //store.dispatch(new SwitchCommunityAction(communityAddress));
    dynamic joinBonus = store.state.walletState.community.plugins.joinBonus;
    if (isFirstTime &&
        joinBonus != null &&
        joinBonus.isActive &&
        joinBonus.amount > 0) {
      store.dispatch(addPendingTransaction(
          joinBonus.amount, "", store.state.userState.user.publicKey));
      new Future.delayed(Duration(seconds: 3), () {
        showDialog(
            context: globals.scaffoldKey.currentContext,
            builder: (BuildContext context) {
              return BonusDialog();
            });
      });
    }

    return true;
  };
}

ThunkAction logoutWalletCall() {
  return (Store store) async {
    store.dispatch(new LogoutAction());
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
  final Community community;
  final String tokenAddress;

  CommunityLoadedAction(this.tokenAddress, this.community);
}

class TokenLoadedAction {
  final Token token;
  final String tokenAddress;
  final String environment;
  final String originNetwork;

  TokenLoadedAction(
      this.tokenAddress, this.token, this.environment, this.originNetwork);
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

class SendAmountAction {
  final double amount;

  SendAmountAction(this.amount);
}

class SendToBusinessAddressAction {
  final String address;

  SendToBusinessAddressAction(this.address);
}

class ResetAddresses {
  ResetAddresses();
}

class SendAddressAction {
  final String address;

  SendAddressAction(this.address);
}

class LogoutAction {
  LogoutAction();
}
