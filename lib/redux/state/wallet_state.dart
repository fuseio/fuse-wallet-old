import 'package:fusewallet/modals/businesses.dart';
import 'package:fusewallet/modals/transactions.dart';
import 'package:fusewallet/modals/user.dart';
import 'package:meta/meta.dart';

@immutable
class WalletState {
  final String balance;
  final TransactionList transactions;
  final String communityAddress;
  final String tokenAddress;
  final bool isLoading;
  final List<Business> businesses;

  WalletState({
    @required this.balance,
    @required this.transactions,
    @required this.communityAddress,
    @required this.tokenAddress,
    this.isLoading,
    this.businesses
  });

  factory WalletState.initial() {
    return new WalletState(isLoading: false, balance: "0", transactions: null, tokenAddress: "", communityAddress: "", businesses: null);
  }

  WalletState copyWith({String balance, TransactionList transactions, String communityAddress, String tokenAddress, bool isLoading, List<Business> businesses}) {
    return new WalletState(
        balance: balance ?? this.balance, transactions: transactions ?? this.transactions, communityAddress: communityAddress ?? this.communityAddress, tokenAddress: tokenAddress ?? this.tokenAddress, isLoading: isLoading ?? this.isLoading, businesses: businesses ?? this.businesses);
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
      WalletState(balance: json["balance"], transactions: null, tokenAddress: "", communityAddress: "", isLoading: false);

  dynamic toJson() => {'balance': balance};
}
