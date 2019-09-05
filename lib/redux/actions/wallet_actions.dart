import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fusewallet/logic/common.dart';
import 'package:fusewallet/logic/crypto_legacy.dart' as prefix0;
import 'package:fusewallet/modals/businesses.dart';
import 'package:fusewallet/modals/community.dart';
import 'package:fusewallet/modals/token.dart';
import 'package:fusewallet/modals/transactions.dart';
import 'package:fusewallet/screens/wallet/wallet.dart';
import 'package:fusewallet/services/wallet_service.dart';
import 'package:fusewallet/widgets/bonusDialog.dart';
import 'package:fusewallet/widgets/widgets.dart';
import 'package:local_auth/local_auth.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:flutter/widgets.dart';

ThunkAction openWalletCall(BuildContext context, { bool firstTime = false }) {
  return (Store store) async {
    //var localAuth = LocalAuthentication();
    //bool didAuthenticate =
    //await localAuth.authenticateWithBiometrics(localizedReason: 'Please authenticate to open the wallet');

    openPageReplace(context, WalletPage());
  };
}

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


Future loadCommunity(Store store, tokenAddress) async {
  var tokenAddress = store.state.walletState.tokenAddress;
  if ((tokenAddress ?? "") == "") {
    tokenAddress = DEFAULT_TOKEN_ADDRESS;
  }
  var token = await getToken(tokenAddress);
  var commmunity = await getCommunity(tokenAddress);
  store.dispatch(new TokenLoadedAction(tokenAddress, token));
  store.dispatch(new CommunityLoadedAction(tokenAddress, commmunity));
  
  loadBalances(store);
  new Timer.periodic(Duration(seconds: 3), (timer) {
    loadBalances(store);
  });
}

Future joinCommunity(Store store) async {
  // var tokenAddress = store.state.walletState.community.communityA;

}

Future fundTokenCall(Store store) async {
  var tokenAddress = store.state.walletState.tokenAddress;
  var publicKey = store.state.userState.user.publicKey;
  await fundToken(publicKey, tokenAddress);


}

Future loadBalances(Store store) async {
  loadBalance(store);
  loadTransactions(store);
}

Future loadBalance(Store store) async {
  var publicKey = store.state.userState.user.publicKey;
  var tokenAddress = store.state.walletState.tokenAddress;
  if (publicKey != "" && tokenAddress != "") {
    var balance = await getBalance(publicKey, tokenAddress);
    store.dispatch(new BalanceLoadedAction(balance));
  }
}

Future loadTransactions(Store store) {
  var publicKey = store.state.userState.user.publicKey;
  var tokenAddress = store.state.walletState.tokenAddress;
  if (publicKey != "" && tokenAddress != "") {
    getTransactions(publicKey, tokenAddress).then((list) {
      store.dispatch(new TransactionsLoadedAction(list));
    });
  }
}

ThunkAction sendAmountCall(amount) {
  return (Store store) async {
    store.dispatch(new SendAmountAction(amount));
    return true;
  };
}

ThunkAction sendAddressCall(address) {
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
    sendTransaction(cleanAddress(store.state.walletState.sendAddress), store.state.walletState.sendAmount, store.state.walletState.tokenAddress, store.state.userState.user.privateKey)
      .then((ret) {
        if (ret == "000") {
          Navigator.of(context).pop(true);
          sendSuccessBottomSheet(context);
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

ThunkAction loadBusinessesCall() {
  return (Store store) async {
    store.dispatch(new StartLoadingAction());
    getBusinesses(store.state.walletState.community.communityAddress).then((list) {
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

ThunkAction switchCommunityCall(BuildContext context, [tokenAddress = DEFAULT_TOKEN_ADDRESS]) {
  return (Store store) async {
    // store.dispatch(new LogoutAction());
    // store.dispatch(new TokenLoadedAction(tokenAddress, null));
    // store.dispatch(new CommunityLoadedAction(tokenAddress, null));

    await loadCommunity(store, tokenAddress);
    // await joinCommunity(store);
    await fundTokenCall(store);
    // store.dispatch(initWalletCall(context));
    //store.dispatch(new SwitchCommunityAction(communityAddress));
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

  TokenLoadedAction(this.tokenAddress, this.token);
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

class SendAddressAction {
  final String address;

  SendAddressAction(this.address);
}

class LogoutAction {
  LogoutAction();
}
