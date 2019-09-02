import 'package:flutter/widgets.dart';
import 'package:fusewallet/logic/common.dart';
import 'package:fusewallet/modals/user.dart';
import 'package:fusewallet/screens/signup/backup1.dart';
import 'package:fusewallet/screens/signup/signup.dart';
import 'package:fusewallet/screens/wallet/wallet.dart';
import 'package:fusewallet/services/wallet_service.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction loadUserState(BuildContext context) {
  return (Store store) async {

    var _isLogged = store.state.userState.user != null && store.state.userState.user.firstName != null;

    store.dispatch(new LoadUserAction(_isLogged));
    if (_isLogged) {
      openPageReplace(context, new WalletPage());
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

ThunkAction generateWalletCall() {
  return (Store store) async {
    store.dispatch(new StartLoadingAction());
    var user = await generateWallet(store.state.userState.user);
    store.dispatch(new UpdateUserAction(user));
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

class LogoutAction {
  LogoutAction();
}
