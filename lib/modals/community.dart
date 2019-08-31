
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
      communityAddress: json["data"]["communityAddress"],
      homeTokenAddress: json["data"]["homeTokenAddress"],
      foreignTokenAddress: json["data"]["foreignTokenAddress"],
      foreignBridgeAddress: json["data"]["foreignBridgeAddress"],
      homeBridgeAddress: json["data"]["homeBridgeAddress"],
      symbol: "",
      joinBonusText: json["data"]["plugins"].length > 0 && json["data"]["plugins"]["joinBonus"] != null ? json["data"]["plugins"]["joinBonus"]["text"] : "",
      joinBonusAmount: json["data"]["plugins"].length > 0 && json["data"]["plugins"]["joinBonus"] != null ? json["data"]["plugins"]["joinBonus"]["amount"] : 0
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
