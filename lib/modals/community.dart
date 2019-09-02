
class Community {
  String communityAddress;
  String homeTokenAddress;
  String foreignTokenAddress;
  String foreignBridgeAddress;
  String homeBridgeAddress;
  String joinBonusText;
  int joinBonusAmount;
  String symbol;

  Community(
      {this.communityAddress,
      this.homeTokenAddress,
      this.foreignTokenAddress,
      this.foreignBridgeAddress,
      this.homeBridgeAddress,
      this.joinBonusText,
      this.joinBonusAmount,
      this.symbol});

  static Community fromJson(dynamic json) => json != null ? Community(
      communityAddress: json["communityAddress"],
      homeTokenAddress: json["homeTokenAddress"],
      foreignTokenAddress: json["foreignTokenAddress"],
      foreignBridgeAddress: json["foreignBridgeAddress"],
      homeBridgeAddress: json["homeBridgeAddress"],
      symbol: "",
      joinBonusText: json["plugins"].length > 0 && json["plugins"]["joinBonus"] != null ? json["plugins"]["joinBonus"]["text"] : "",
      joinBonusAmount: json["plugins"].length > 0 && json["plugins"]["joinBonus"] != null ? json["plugins"]["joinBonus"]["amount"] : 0
      ) : null;

  static Community fromJsonState(dynamic json) => json != null ? Community(
      communityAddress: json["communityAddress"],
      homeTokenAddress: json["homeTokenAddress"],
      foreignTokenAddress: json["foreignTokenAddress"],
      foreignBridgeAddress: json["foreignBridgeAddress"],
      homeBridgeAddress: json["homeBridgeAddress"],
      symbol: json["symbol"],
      joinBonusText: json["joinBonusText"],
      joinBonusAmount: json["joinBonusAmount"]
      ) : null;

  dynamic toJson() => {
        'communityAddress': communityAddress,
        'homeTokenAddress': homeTokenAddress,
        'foreignTokenAddress': foreignTokenAddress,
        'foreignBridgeAddress': foreignBridgeAddress,
        'homeBridgeAddress': homeBridgeAddress,
        'symbol': symbol
      };
}
