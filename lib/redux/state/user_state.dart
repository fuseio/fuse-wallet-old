import 'package:fusewallet/modals/user.dart';
import 'package:meta/meta.dart';

@immutable
class UserState {
  final bool isLoading;
  final bool loginError;
  final bool isUserLogged;
  final String verificationCode;
  final User user;

  UserState({
    @required this.user,
    this.isLoading,
    this.loginError,
    this.isUserLogged,
    this.verificationCode,
  });

  factory UserState.initial() {

    //WalletLogic.isLogged().then((isLogged) {
    //  if (isLogged) {
    //    openPageReplace(context, WalletPage());
    //  }
    //});
    
    return new UserState(isLoading: false, loginError: false, user: new User(), isUserLogged: false, verificationCode: "");
  }

  UserState copyWith({bool isLoading, bool loginError, bool isUserLogged, User user, String verificationCode}) {
    return new UserState(
        isLoading: isLoading ?? this.isLoading, loginError: loginError ?? this.loginError, isUserLogged: isUserLogged ?? this.isUserLogged, user: user ?? this.user, verificationCode: verificationCode ?? this.verificationCode);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UserState &&
              runtimeType == other.runtimeType &&
              isLoading == other.isLoading &&
              loginError == other.loginError &&
              user == other.user;

  @override
  int get hashCode => isLoading.hashCode ^ user.hashCode;

  static UserState fromJson(dynamic json) =>
      UserState(user: User.fromJson(json["user"]), isLoading: false, isUserLogged: false, loginError: false, verificationCode: "");

  dynamic toJson() => {'user': user, 'isUserLogged': isUserLogged};
}
