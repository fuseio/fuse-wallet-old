
class Community {
  String communityAddress;
  String homeTokenAddress;
  String foreignTokenAddress;
  String foreignBridgeAddress;
  String homeBridgeAddress;
  String joinBonusText;
  double joinBonusAmount;

  Community(
      {this.communityAddress,
      this.homeTokenAddress,
      this.foreignTokenAddress,
      this.foreignBridgeAddress,
      this.homeBridgeAddress,
      this.joinBonusText,
      this.joinBonusAmount});

  static Community fromJson(dynamic json) => json != null ? Community(
      communityAddress: json["communityAddress"],
      homeTokenAddress: json["homeTokenAddress"],
      foreignTokenAddress: json["foreignTokenAddress"],
      foreignBridgeAddress: json["foreignBridgeAddress"],
      homeBridgeAddress: json["homeBridgeAddress"],
      joinBonusText: json.containsKey('plugins') && json["plugins"].length > 0 && json["plugins"]["joinBonus"] != null ? json["plugins"]["joinBonus"]["joinInfo"]["message"] : "",
      joinBonusAmount: json.containsKey('plugins') && json["plugins"].length > 0 && json["plugins"]["joinBonus"] != null ? double.parse(json["plugins"]["joinBonus"]["joinInfo"]["amount"]) : 0
      ) : null;

  static Community fromJsonState(dynamic json) => json != null ? Community(
      communityAddress: json["communityAddress"],
      homeTokenAddress: json["homeTokenAddress"],
      foreignTokenAddress: json["foreignTokenAddress"],
      foreignBridgeAddress: json["foreignBridgeAddress"],
      homeBridgeAddress: json["homeBridgeAddress"],
      joinBonusText: json["joinBonusText"],
      joinBonusAmount: json["joinBonusAmount"]
      ) : null;

  dynamic toJson() => {
        'communityAddress': communityAddress,
        'homeTokenAddress': homeTokenAddress,
        'foreignTokenAddress': foreignTokenAddress,
        'foreignBridgeAddress': foreignBridgeAddress,
        'homeBridgeAddress': homeBridgeAddress
      };
}
