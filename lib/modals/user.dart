import 'dart:convert';

class User {
  int userId;
  String firstName;
  String lastName;
  String email;
  String phone;
  String privateKey;
  String publicKey;
  List<String> mnemonic;

  User(
      {this.userId,
      this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.privateKey,
      this.publicKey,
      this.mnemonic});

  static User fromJson(dynamic json) => json != null ? User(
      userId: json["userId"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      email: json["email"],
      phone: json["phone"],
      privateKey: json["privateKey"],
      publicKey: json["publicKey"],
      mnemonic: List<String>.from(jsonDecode(json["mnemonic"]) as List<dynamic>),
      ) : null;

  dynamic toJson() => {
        'userId': userId,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'privateKey': privateKey,
        'publicKey': publicKey,
        'mnemonic': mnemonic
      };
}
