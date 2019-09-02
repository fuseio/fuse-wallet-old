import 'package:flutter/widgets.dart';
import 'package:fusewallet/modals/user.dart';
import 'package:fusewallet/redux/actions/signin_actions.dart';
import 'package:fusewallet/redux/actions/wallet_actions.dart';
import 'package:fusewallet/redux/state/app_state.dart';
import 'package:redux/redux.dart';

class SignInViewModel {
  final bool isLoading;
  final bool loginError;
  final User user;
  final Function(String, String) login;
  final Function(BuildContext, String) sendCodeToPhoneNumber;
  final Function(BuildContext, String) signInWithPhoneNumber;
  final Function(BuildContext, String, String, String) signUp;
  final Function() generateWallet;
  final Function() logout;
  final Function(BuildContext) openWallet;

  SignInViewModel({
    this.isLoading,
    this.loginError,
    this.user,
    this.login,
    this.sendCodeToPhoneNumber,
    this.signInWithPhoneNumber,
    this.signUp,
    this.generateWallet,
    this.logout,
    this.openWallet
  });

  static SignInViewModel fromStore(Store<AppState> store) {
    return SignInViewModel(
      isLoading: store.state.userState.isLoading,
      loginError: store.state.userState.loginError,
      user: store.state.userState.user,
      sendCodeToPhoneNumber: (BuildContext context, String phone) {
        store.dispatch(sendCodeToPhoneNumberCall(context, phone));
      },
      signInWithPhoneNumber: (BuildContext context, String verificationCode) {
        store.dispatch(signInWithPhoneNumberCall(context, verificationCode));
      },
      signUp: (BuildContext context, String firstName, String lastName, String email) {
        store.dispatch(signUpCall(context, firstName, lastName, email));
      },
      generateWallet: () {
        store.dispatch(generateWalletCall());
      },
      logout: () {
        store.dispatch(logoutUserCall());
        store.dispatch(logoutWalletCall());
      },
      openWallet: (BuildContext context) {
        store.dispatch(openWalletCall(context));
      }
    );
  }
}
