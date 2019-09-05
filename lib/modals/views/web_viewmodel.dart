import 'package:fusewallet/modals/user.dart';
import 'package:fusewallet/redux/state/app_state.dart';
import 'package:redux/redux.dart';

class WebViewModel {
  final User user;

  WebViewModel({
    this.user,
  });

  static WebViewModel fromStore(Store<AppState> store) {
    return WebViewModel(
      user: store.state.userState.user
    );
  }
}
