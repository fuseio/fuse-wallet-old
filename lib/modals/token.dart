

class Token {
  String address;
  String name;
  String symbol;
  String totalSupply;
  String tokenURI;
  String owner;

  Token({
    this.address,
    this.name,
    this.symbol,
    this.totalSupply,
    this.tokenURI,
    this.owner
  });

  static Token fromJson(dynamic json) => json != null ? Token(
      address: json["address"],
      name: json["name"],
      symbol: json["symbol"],
      totalSupply: json["totalSupply"],
      tokenURI: json["tokenURI"],
      owner: json["owner"]
      ) : null;

  static Token fromJsonState(dynamic json) => json != null ? Token(
    address: json["address"],
    name: json["name"],
    symbol: json["symbol"],
    totalSupply: json["totalSupply"],
    tokenURI: json["tokenURI"],
    owner: json["owner"]
    ) : null;

  dynamic toJson() => {
        'address': address,
        'name': name,
        'symbol': symbol,
        'totalSupply': totalSupply,
        'tokenURI': tokenURI,
        'owner': owner
      };
}
