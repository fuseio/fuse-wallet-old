import 'package:fusewallet/modals/businesses.dart';
import 'package:fusewallet/modals/community.dart';
import 'package:fusewallet/modals/transactions.dart';
import 'package:meta/meta.dart';

@immutable
class WalletState {
  final String balance;
  final TransactionList transactions;
  final String tokenAddress;
  final Community community;
  final bool isLoading;
  final List<Business> businesses;
  final bool showBonusDialog;

  WalletState({
    @required this.balance,
    @required this.transactions,
    @required this.tokenAddress,
    @required this.community,
    this.isLoading,
    this.businesses,
    this.showBonusDialog
  });

  factory WalletState.initial() {
    return new WalletState(isLoading: false, balance: "0", transactions: null, tokenAddress: "", community: null, businesses: null, showBonusDialog: true);
  }

  WalletState copyWith({String balance, TransactionList transactions, String tokenAddress, Community community, bool isLoading, List<Business> businesses, bool showBonusDialog}) {
    return new WalletState(
        balance: balance ?? this.balance, transactions: transactions ?? this.transactions, tokenAddress: tokenAddress ?? this.tokenAddress, community: community ?? this.community, isLoading: isLoading ?? this.isLoading, businesses: businesses ?? this.businesses, showBonusDialog: showBonusDialog ?? this.showBonusDialog);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is WalletState &&
              runtimeType == other.runtimeType &&
              balance == other.balance &&
              transactions == other.transactions;

  //@override
  //int get hashCode => isLoading.hashCode ^ user.hashCode;

  static WalletState fromJson(dynamic json) =>
      WalletState(balance: json["balance"], transactions: null, tokenAddress: "", community: null, isLoading: false, showBonusDialog: json["showBonusDialog"]);

  dynamic toJson() => {'balance': balance, 'showBonusDialog': showBonusDialog};
}
