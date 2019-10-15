
class JoinBonusPlugin {

  String message;
  double amount;
  bool isActive;

  JoinBonusPlugin({
    this.message,
    this.amount,
    this.isActive,
  });

  static JoinBonusPlugin fromJson(dynamic json) => json != null ? JoinBonusPlugin(
    message: json["joinInfo"]["message"],
    amount: double.parse(json["joinInfo"]["amount"]),
    isActive: json["isActive"] || true
    ) : null;

  dynamic toJson() => {
      'message': message,
      'amount': amount,
      'isActive': isActive
    };

  static JoinBonusPlugin fromJsonState(dynamic json) => json != null ? JoinBonusPlugin(
    message: json['message'],
    amount: json['amount'],
    isActive: json['isActive']
  ) : null;
}

class DepositPlugin {
    String provider;
    String apiKey;
    String currencyCode;
    String walletAddress;
    bool isActive;

    DepositPlugin({
      this.provider,
      this.apiKey,
      this.currencyCode,
      this.walletAddress,
      this.isActive
    });

    static DepositPlugin fromJson(dynamic json) => json != null ? DepositPlugin(
      provider: json['provider'],
      apiKey: json['apiKey'],
      currencyCode: json['currencyCode'],
      walletAddress: json['walletAddress'],
      isActive: json["isActive"] || true
    ) : null;

    static DepositPlugin fromJsonState(dynamic json) => DepositPlugin.fromJson(json);

    dynamic toJson() => {
      'provider': provider,
      'apiKey': apiKey,
      'currencyCode': currencyCode,
      'walletAddress': walletAddress,
      'isActive': isActive
    };

    
}

class Plugins {
  JoinBonusPlugin joinBonus;
  DepositPlugin deposit;

  Plugins({
    this.joinBonus,
    this.deposit,
  });

  static Plugins fromJson(dynamic json) => json != null ? Plugins(
      joinBonus: JoinBonusPlugin.fromJson(json["joinBonus"]),
      deposit: DepositPlugin.fromJson(json["deposit"]),
      ) : {};

  static Plugins fromJsonState(dynamic json) => json != null ? Plugins(
      joinBonus: JoinBonusPlugin.fromJsonState(json['joinBonus']),
      deposit: DepositPlugin.fromJsonState(json['joinBonus']),
      ) : null;

  dynamic toJson() => {
        'joinBonus': joinBonus != null ? joinBonus.toJson() : null,
        'deposit': deposit != null ? deposit.toJson() : null
      };
}
