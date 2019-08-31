import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Transaction {
  final String value;
  final String to;
  final String from;
  final String hash;
  final String timeStamp;
  final String tokenSymbol;
  final DateTime date;
  final double amount;

  Transaction({this.value, this.to, this.from, this.hash, this.timeStamp, this.tokenSymbol, this.date, this.amount});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      value: json['value'],
      to: json['to'],
      from: json['from'],
      hash: json['hash'],
      timeStamp: json['timeStamp'],
      tokenSymbol: json['tokenSymbol'],
      date: new DateTime.fromMillisecondsSinceEpoch(int.tryParse(json['timeStamp']) * 1000),
      amount: BigInt.tryParse(json['value']) / BigInt.from(1000000000000000000)
    );
  }
}

class TransactionList {
  final List<Transaction> transactions;

  TransactionList({this.transactions});

  factory TransactionList.fromJson(Map<String, dynamic> json) {

    var list = json['result'] as List;

    List<Transaction> transactions = new List<Transaction>();
    transactions = list.map((i)=>Transaction.fromJson(i)).toList();

    return new TransactionList(
      transactions: transactions
    );
  }
}
