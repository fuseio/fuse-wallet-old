
import 'package:fusewallet/modals/user.dart';
import 'package:fusewallet/redux/actions/signin_actions.dart';
import 'package:fusewallet/redux/state/user_state.dart';
import 'package:redux/redux.dart';

final userReducer = combineReducers<UserState>([
  TypedReducer<UserState, LoadUserAction>(_loadUserState),
  TypedReducer<UserState, LoginCodeSentSuccessAction>(_loginCodeSentSuccess),
  TypedReducer<UserState, LoginFailedAction>(_loginFailed),
  TypedReducer<UserState, StartLoadingAction>(_startLoading),
  TypedReducer<UserState, UpdateUserAction>(_walletCreated),
  TypedReducer<UserState, SetProtectMethodAction>(_setProtectMethod),
  TypedReducer<UserState, ProtectUnlockedAction>(_protectUnlocked),
  TypedReducer<UserState, LogoutAction>(_logout),
]);

UserState _loadUserState(UserState state, LoadUserAction action) {
  return state.copyWith(user: null, isLoading: false, loginError: false, isUserLogged: action.isUserLogged);
}

UserState _loginCodeSentSuccess(UserState state, LoginCodeSentSuccessAction action) {
  return state.copyWith(verificationCode: action.verificationCode, isLoading: false, loginError: false, isUserLogged: true);
}

UserState _loginFailed(UserState state, LoginFailedAction action) {
  return state.copyWith(user: null, isLoading: false, loginError: true);
}

UserState _startLoading(UserState state, StartLoadingAction action) {
  return state.copyWith(isLoading: true, loginError: false);
}

UserState _walletCreated(UserState state, UpdateUserAction action) {
  return state.copyWith(isLoading: false, user: action.user);
}

UserState _setProtectMethod(UserState state, SetProtectMethodAction action) {
  return state.copyWith(isLoading: false, protectMethod: action.method, protectPincode: action.code);
}

UserState _protectUnlocked(UserState state, ProtectUnlockedAction action) {
  return state.copyWith(protectTimestamp: action.timestamp);
}

UserState _logout(UserState state, LogoutAction action) {
  return new UserState(user: null, );
}