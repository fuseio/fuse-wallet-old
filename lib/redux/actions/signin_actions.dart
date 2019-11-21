import 'package:flutter/widgets.dart';
import 'package:interactive_webview/interactive_webview.dart';
import 'package:fusewallet/logic/common.dart';
import 'package:fusewallet/modals/user.dart';
import 'package:fusewallet/screens/signup/backup1.dart';
import 'package:fusewallet/screens/signup/signup.dart';
import 'package:fusewallet/screens/wallet/pincode.dart';
import 'package:fusewallet/screens/wallet/wallet.dart';
import 'package:fusewallet/services/wallet_service.dart';
import 'package:local_auth/local_auth.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction loadUserState(BuildContext context) {
  return (Store store) async {

    var _isLogged = store.state.userState.user != null && store.state.userState.user.firstName != null;

    store.dispatch(new LoadUserAction(_isLogged));
    if (_isLogged) {
      store.dispatch(openWalletCall(context));
    }

  };
}

ThunkAction sendCodeToPhoneNumberCall(BuildContext context, String phone) {
  return (Store store) async {

/*
    phone = phone.trim();
    var _user = store.state.userState.user;
    if (_user == null) {
      _user = new User();
    }
    _user.firstName = currentUser.displayName;
    _user.lastName = currentUser.photoUrl;
    _user.email = currentUser.email;
    _user.phone = currentUser.phoneNumber;
    store.dispatch(new UpdateUserAction(_user));

    if (currentUser.displayName != null) {
      openPage(context, new Backup1Page());
    } else {
      openPage(context, new SignUpPage());
    }

    if (phone.isEmpty || !isValidPhone(phone)) {
      store.dispatch(new LoginFailedAction());
    } else {
      store.dispatch(new StartLoadingAction());
    }
    */

    openPage(context, new SignUpPage());

  };
}

ThunkAction signInWithPhoneNumberCall(BuildContext context, String smsCode) {
  return (Store store) async {

    /*
    store.dispatch(new StartLoadingAction());

    var _user = store.state.userState.user;
      if (_user == null) {
        _user = new User();
      }
      _user.firstName = currentUser.displayName;
      _user.lastName = currentUser.photoUrl;
      _user.email = currentUser.email;
      _user.phone = currentUser.phoneNumber;
      store.dispatch(new UpdateUserAction(_user));

      if (currentUser.displayName != null) {
        openPage(context, new Backup1Page());
      } else {
        openPage(context, new SignUpPage());
      }
*/

    openPage(context, new SignUpPage());

    return true;
  };
}

ThunkAction signUpCall(BuildContext context, String firstName, String lastName, String email) {
  return (Store store) async {
    
    var _user = store.state.userState.user;
    if (_user == null) {
      _user = new User();
    }
    _user.firstName = firstName;
    _user.lastName = lastName;
    _user.email = email;
    _user.phone = "";
    store.dispatch(new UpdateUserAction(_user));

    openPage(context, new Backup1Page());
    return true;
  };
}

ThunkAction create3boxAccountCall() {
    return (Store store) async {
      final _webView = new InteractiveWebView();
      print('Loading 3box webview for account ${store.state.userState.user.publicKey}');
      final html = '''<html>
        <head></head>
        <script>
          window.pk = '0x${store.state.userState.user.privateKey}';
          window.user = { name: '${store.state.userState.user.firstName}', account: '${store.state.userState.user.publicKey}', email: '${store.state.userState.user.email}', phoneNumber: '${store.state.userState.user.phone}', address: '${''}'};
        </script>
        <script src='https://3box.fuse.io/main.js'></script>
        <body></body>
      </html>''';
      _webView.loadHTML(html, baseUrl: "https://beta.3box.io");
      String firstName = store.state.userState.user.firstName;
      String account = store.state.userState.user.publicKey;
      String email = store.state.userState.user.email;
      saveUserToDb('', '', account, firstName, email);
      saveUserToDb('qa', '', account, firstName, email);
      createUserProfile('', '', account, firstName);
      createUserProfile('qa', '', account, firstName);
      createUserProfile('qa', 'ropsten', account, firstName);
    };
}

ThunkAction generateWalletCall() {
  return (Store store) async {
    store.dispatch(new StartLoadingAction());
    var user = await generateWallet(store.state.userState.user);
    store.dispatch(new UpdateUserAction(user));
    store.dispatch(create3boxAccountCall());
  };
}

ThunkAction setProtectMethodCall(method, { code = ""}) {
  return (Store store) async {
    store.dispatch(new SetProtectMethodAction(method, code));
  };
}

ThunkAction openWalletCall(context) {
  return (Store store) async {
    var method = store.state.userState.protectMethod;
    var lastEnter = store.state.userState.protectTimestamp == null ? DateTime.now().subtract(Duration(minutes: 30)) : store.state.userState.protectTimestamp;
    Duration difference = DateTime.now().difference(lastEnter);
    if (method == "pincode" && difference.inMinutes > 10) {
      openPage(context, new PincodePage());
    } else if (method == "fingerprint" && difference.inMinutes > 10) {
      var localAuth = LocalAuthentication();
      bool didAuthenticate = await localAuth.authenticateWithBiometrics(localizedReason: 'Please authenticate to open the wallet');
      if (didAuthenticate) {
        openPageReplace(context, new WalletPage());
      }
    } else {
      openPageReplace(context, new WalletPage());
    }
  };
}

ThunkAction protectUnlockCall(context) {
  return (Store store) async {
    store.dispatch(new ProtectUnlockedAction(DateTime.now()));
    store.dispatch(openWalletCall(context));
  };
}

ThunkAction logoutUserCall() {
  return (Store store) async {
    store.dispatch(new LogoutAction());
    return true;
  };
}

class LoadUserAction {
  final bool isUserLogged;
  LoadUserAction(this.isUserLogged);
}

class StartLoadingAction {
  StartLoadingAction();
}

class LoginCodeSentSuccessAction {
  final String verificationCode;

  LoginCodeSentSuccessAction(this.verificationCode);
}

class UpdateUserAction {
  final User user;

  UpdateUserAction(this.user);
}

class LoginFailedAction {
  LoginFailedAction();
}

class SetProtectMethodAction {
  final String method;
  final String code;

  SetProtectMethodAction(this.method, this.code);
}

class ProtectUnlockedAction {
  final DateTime timestamp;

  ProtectUnlockedAction(this.timestamp);
}

class LogoutAction {
  LogoutAction();
}
