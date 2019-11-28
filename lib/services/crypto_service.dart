import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:hex/hex.dart';
// import 'package:web3dart/web3dart.dart';
import 'package:wallet_core/wallet_core.dart';

Future<bool> approvalCallback() async {
  return true;
}

Future getPublickKey(privateKey) async {
  if (privateKey == null) {
    return "";
  }
  Web3 web3Client = new Web3(approvalCallback);
  await web3Client.setCredentials(privateKey);
  return await web3Client.getAddress();
}

String generateMnemonic() {
  return Web3.generateMnemonic();
}

String getPrivateKeyFromMnemonic(mnemonic) {
  return Web3.privateKeyFromMnemonic(mnemonic);
}