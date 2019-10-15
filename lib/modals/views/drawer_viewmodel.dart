import 'package:fusewallet/modals/community.dart';
import 'package:fusewallet/modals/user.dart';
import 'package:fusewallet/redux/actions/signin_actions.dart';
import 'package:fusewallet/redux/actions/wallet_actions.dart';
import 'package:fusewallet/redux/state/app_state.dart';
import 'package:redux/redux.dart';

class DrawerViewModel {
  final User user;
  final Community community;
  final Function() logout;


  DrawerViewModel({
    this.user,
    this.community,
    this.logout
  });

  static DrawerViewModel fromStore(Store<AppState> store) {
    return DrawerViewModel(
      user: store.state.userState.user,
      community: store.state.walletState.community,
      logout: () {
        store.dispatch(logoutUserCall());
        store.dispatch(logoutWalletCall());
      }
    );
  }
}
