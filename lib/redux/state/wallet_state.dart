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

  WalletState({
    @required this.balance,
    @required this.transactions,
    @required this.tokenAddress,
    @required this.community,
    this.isLoading,
    this.businesses
  });

  factory WalletState.initial() {
    return new WalletState(isLoading: false, balance: "0", transactions: null, tokenAddress: "", community: null, businesses: null);
  }

  WalletState copyWith({String balance, TransactionList transactions, String tokenAddress, Community community, bool isLoading, List<Business> businesses}) {
    return new WalletState(
        balance: balance ?? this.balance, transactions: transactions ?? this.transactions, tokenAddress: tokenAddress ?? this.tokenAddress, community: community ?? this.community, isLoading: isLoading ?? this.isLoading, businesses: businesses ?? this.businesses);
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
      WalletState(balance: json["balance"], transactions: TransactionList.fromJsonState(json["transactions"]), tokenAddress: json["tokenAddress"], community:  Community.fromJsonState(json["community"]), isLoading: false);

  dynamic toJson() => {'balance': balance, 'community': community, 'transactions': transactions};
}
