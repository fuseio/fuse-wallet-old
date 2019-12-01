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