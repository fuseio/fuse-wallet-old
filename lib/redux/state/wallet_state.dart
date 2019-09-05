import 'package:fusewallet/modals/businesses.dart';
import 'package:fusewallet/modals/community.dart';
import 'package:fusewallet/modals/token.dart';
import 'package:fusewallet/modals/transactions.dart';
import 'package:meta/meta.dart';

@immutable
class WalletState {
  final String balance;
  final TransactionList transactions;
  final String tokenAddress;
  final Community community;
  final Token token;
  final bool isLoading;
  final List<Business> businesses;
  final String sendAddress;
  final double sendAmount;
  final String sendStep;

  WalletState({
    @required this.balance,
    @required this.transactions,
    @required this.tokenAddress,
    @required this.community,
    this.token,
    this.isLoading,
    this.businesses,
    this.sendAddress,
    this.sendAmount,
    this.sendStep
  });

  factory WalletState.initial() {
    return new WalletState(isLoading: false, balance: "0", transactions: null, tokenAddress: "", community: null, token: null, businesses: null, sendAddress: "", sendAmount: 0, sendStep: "amount");
  }

  WalletState copyWith({String balance, Nullable<TransactionList> transactions, String tokenAddress, Nullable<Community> community, bool isLoading, List<Business> businesses, String sendAddress, double sendAmount, String sendStep, Nullable<Token> token}) {
    return new WalletState(
        balance: balance ?? this.balance,
        transactions: transactions == null ? this.transactions : transactions.value,
        tokenAddress: tokenAddress ?? this.tokenAddress,
        community: community == null ? this.community : community.value,
        token: token == null ? this.token : token.value,
        isLoading: isLoading ?? this.isLoading,
        businesses: businesses ?? this.businesses,
        sendAddress: sendAddress ?? this.sendAddress,
        sendAmount: sendAmount ?? this.sendAmount,
        sendStep: sendStep ?? this.sendStep);
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

class Nullable<T> {
  final T value;

  const Nullable(this.value);
  const Nullable.fromNull() : this.value = null;
}