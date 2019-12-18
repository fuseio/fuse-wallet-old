import './plugins.dart';

class Community {
  String communityAddress;
  String homeTokenAddress;
  String foreignTokenAddress;
  String foreignBridgeAddress;
  String homeBridgeAddress;
  Plugins plugins;

  Community(
      {this.communityAddress,
      this.homeTokenAddress,
      this.foreignTokenAddress,
      this.foreignBridgeAddress,
      this.homeBridgeAddress,
      this.plugins});

  static Community fromJson(dynamic json) => json != null ? Community(
      communityAddress: json["communityAddress"],
      homeTokenAddress: json["homeTokenAddress"],
      foreignTokenAddress: json["foreignTokenAddress"],
      foreignBridgeAddress: json["foreignBridgeAddress"],
      homeBridgeAddress: json["homeBridgeAddress"],
      plugins: Plugins.fromJson(json["plugins"] ?? {})
      ) : null;

  static Community fromJsonState(dynamic json) => json != null ? Community(
      communityAddress: json["communityAddress"],
      homeTokenAddress: json["homeTokenAddress"],
      foreignTokenAddress: json["foreignTokenAddress"],
      foreignBridgeAddress: json["foreignBridgeAddress"],
      homeBridgeAddress: json["homeBridgeAddress"],
      plugins: Plugins.fromJsonState(json["plugins"])
      ) : null;

  dynamic toJson() => {
        'communityAddress': communityAddress,
        'homeTokenAddress': homeTokenAddress,
        'foreignTokenAddress': foreignTokenAddress,
        'foreignBridgeAddress': foreignBridgeAddress,
        'homeBridgeAddress': homeBridgeAddress,
        'plugins': plugins.toJson()
      };
}
