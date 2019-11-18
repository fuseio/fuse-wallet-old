import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:hex/hex.dart';
// import 'package:web3dart/web3dart.dart';
import 'package:wallet_core/wallet_core.dart';

String generateMnemonic() {
  return bip39.generateMnemonic();
}

Future<bool> approvalCallback() async {
  return true;
}

Future getPublickKey(privateKey) async {
  if (privateKey == null) {
    return "";
  }
  Web3 web3Client = new Web3(approvalCallback);
  await web3Client.setCredentials(privateKey);
  // var credentials = Credentials.fromPrivateKeyHex(privateKey);
  return await web3Client.getAddress();
  // return credentials.address.hex;
}

String getPrivateKeyFromMnemonic(mnemonic) {
  String seed = bip39.mnemonicToSeedHex(mnemonic);
  bip32.BIP32 root = bip32.BIP32.fromSeed(HEX.decode(seed));
  bip32.BIP32 child = root.derivePath("m/44'/60'/0'/0/0");
  String privateKey = HEX.encode(child.privateKey);
  return privateKey;
}