import './user.dart';

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
    isActive: json["isActive"] || false
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

abstract class DepositPlugin {
  String name;
  bool isActive;
  String widgetUrl;

  final String type = 'deposit';

  DepositPlugin(
      this.name,
      this.isActive,
      this.widgetUrl,
    );
    

  String generateUrl (User user) {
    return this.widgetUrl;
  }

  dynamic toJson() => {
    'name': name,
    'isActive': isActive,
    'type': type
  };
}


class MoonpayPlugin extends DepositPlugin {

    MoonpayPlugin ({
      name,
      isActive,
      widgetUrl}) : super(name, isActive, widgetUrl)  {
      }

    static MoonpayPlugin fromJson(dynamic json) => json != null ? MoonpayPlugin(
      name: json['name'],
      widgetUrl: json['widgetUrl'],
      isActive: json["isActive"] || true,
    ) : null;

    static MoonpayPlugin fromJsonState(dynamic json) => MoonpayPlugin.fromJson(json);

    String generateUrl (User user) {
      String url = this.widgetUrl;
      url += 'externalCustomerId=${user.publicKey}';
      if (user.email != null && user.email != '') {
        url = url + '&email=${user.email}';
      }
      return url;
    }
}

class CarbonPlugin extends DepositPlugin {

    CarbonPlugin ({
      name,
      isActive,
      widgetUrl}) : super(name, isActive, widgetUrl);

    static CarbonPlugin fromJson(dynamic json) => json != null ? CarbonPlugin(
      name: json['name'],
      widgetUrl: json['widgetUrl'],
      isActive: json["isActive"] || true,
    ) : null;

    static CarbonPlugin fromJsonState(dynamic json) => CarbonPlugin.fromJson(json);
}

class WyrePlugin extends DepositPlugin {

    WyrePlugin ({
      name,
      isActive,
      widgetUrl}) : super(name, isActive, widgetUrl);

    static WyrePlugin fromJson(dynamic json) => json != null ? WyrePlugin(
      name: json['name'],
      widgetUrl: json['widgetUrl'],
      isActive: json["isActive"] || true,
    ) : null;

    static WyrePlugin fromJsonState(dynamic json) => WyrePlugin.fromJson(json);
}

class CoindirectPlugin extends DepositPlugin {

    CoindirectPlugin ({
      name,
      isActive,
      widgetUrl}) : super(name, isActive, widgetUrl);

    static CoindirectPlugin fromJson(dynamic json) => json != null ? CoindirectPlugin(
      name: json['name'],
      widgetUrl: json['widgetUrl'],
      isActive: json["isActive"] || true,
    ) : null;

    static CoindirectPlugin fromJsonState(dynamic json) => CoindirectPlugin.fromJson(json);
}

class RampPlugin extends DepositPlugin {

    RampPlugin ({
      name,
      isActive,
      widgetUrl}) : super(name, isActive, widgetUrl);

    static RampPlugin fromJson(dynamic json) => json != null ? RampPlugin(
      name: json['name'],
      widgetUrl: json['widgetUrl'],
      isActive: json["isActive"] || true,
    ) : null;

    static RampPlugin fromJsonState(dynamic json) => RampPlugin.fromJson(json);
}

class Plugins {
  JoinBonusPlugin joinBonus;
  MoonpayPlugin moonpay;
  CarbonPlugin carbon;
  WyrePlugin wyre;
  CoindirectPlugin coindirect;
  RampPlugin ramp;

  Plugins({
    this.joinBonus,
    this.moonpay,
    this.carbon,
    this.wyre,
    this.coindirect,
    this.ramp
  });

  static Plugins fromJson(dynamic json) => json != null ? Plugins(
      joinBonus: JoinBonusPlugin.fromJson(json["joinBonus"]),
      moonpay: MoonpayPlugin.fromJson(json["moonpay"]),
      carbon: CarbonPlugin.fromJson(json["carbon"]),
      wyre: WyrePlugin.fromJson(json["wyre"]),
      coindirect: CoindirectPlugin.fromJson(json["coindirect"]),
      ramp: RampPlugin.fromJson(json["ramp"]),
      ) : {};

  static Plugins fromJsonState(dynamic json) => Plugins.fromJson(json);

  dynamic toJson() => {
        'joinBonus': joinBonus != null ? joinBonus.toJson() : null,
        'moonpay': moonpay != null ? moonpay.toJson() : null,
        'carbon': carbon != null ? carbon.toJson() : null,
        'wyre': wyre != null ? wyre.toJson() : null,
        'coindirect': coindirect != null ? coindirect.toJson() : null,
        'ramp': ramp != null ? ramp.toJson() : null,
      };
    
  List getDepositPlugins() {
    List depositPlugins = [];
    if (this.moonpay != null && this.moonpay.isActive) {
        depositPlugins.add(this.moonpay);
    }
    if (this.carbon != null && this.carbon.isActive) {
      depositPlugins.add(this.carbon);
    }
    if (this.wyre != null && this.wyre.isActive) {
      depositPlugins.add(this.wyre);
    }
    if (this.coindirect != null && this.coindirect.isActive) {
      depositPlugins.add(this.coindirect);
    }
    if (this.ramp != null && this.ramp.isActive) {
      depositPlugins.add(this.ramp);
    }
    return depositPlugins;
  }
}
