import 'package:flutter/material.dart';
import 'dart:core';
import 'package:fusewallet/logic/common.dart';
//import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';
import 'package:fusewallet/screens/signup/backup1.dart';
import 'package:fusewallet/screens/wallet/protect_wallet.dart';
import 'package:fusewallet/screens/wallet/switch_community.dart';
import 'package:fusewallet/screens/wallet/web2.dart';
//import 'package:local_auth/local_auth.dart';

import 'package:fusewallet/splash.dart';
import 'language-selector.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fusewallet/modals/views/signin_viewmodel.dart';
import 'package:fusewallet/redux/state/app_state.dart';

class DrawerWidget extends StatefulWidget {
  DrawerWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final assetIdController = TextEditingController(text: "");
  String userName = "";

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext _context) {
    return Drawer(
      child: new StoreConnector<AppState, SignInViewModel>(
        converter: (store) {
          return SignInViewModel.fromStore(store);
        },
        builder: (_, viewModel) {
          return viewModel.user != null ? Builder(
              builder: (context) => ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      DrawerHeader(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 15),
                              child:
                                  Image.asset('images/avatar.png', width: 70),
                            ),
                            Text(
                              viewModel.user.firstName + " " + viewModel.user.lastName,
                              style: TextStyle(
                                  color: const Color(0xFF787878), fontSize: 16),
                            )
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      /*
          ListTile(
            title: Text('Delete Account'),
            onTap: () {
              setPrivateKey("");
            },
          ),
          ListTile(
            title: Text('Generate Mnemonic'),
            onTap: () {
              // Update the state of the app
              // ...
            },
          ),
          ListTile(
            title: Text('Change Asset ID'),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text("Asset ID"),
                        content: Column(children: <Widget>[
                          TextField(
                            controller: assetIdController,
                          ),
                          Row(
                            children: <Widget>[
                              FlatButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0)),
                                color: Theme.of(context).accentColor,
                                padding: EdgeInsets.all(12),
                                child: Text(
                                  "Save",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  var v =
                                      "0x308c3b277B05E75Da98b2a961b9189CA139C0De8"; //assetIdController.text
                                  setAssetID(v);
                                  var listAddress =
                                      loadListAddress(v).then((address) {
                                    setListAddress(address);
                                  });
                                  Navigator.of(context).pop(true);
                                },
                              )
                            ],
                          )
                        ]),
                      ));
            },
          ),
          */
                      ListTile(
                        title: Text(
                          'Switch community',
                          style: TextStyle(fontSize: 16),
                        ),
                        onTap: () {
                          openPage(context, SwitchCommunityPage());
                        },
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          'Protect your wallet',
                          style: TextStyle(fontSize: 16),
                        ),
                        onTap: () {
                          openPage(context, ProtectWalletPage());
                        },
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          'Back up wallet',
                          style: TextStyle(fontSize: 16),
                        ),
                        onTap: () {
                          openPage(context, Backup1Page());
                        },
                      ),
                      Divider(),
                      /*
          ListTile(
            title: Text('Start NFC'),
            onTap: () {
              startNFC();
            },
          ),
          ListTile(
            title: Text('Stop NFC'),
            onTap: () {
              stopNFC();
            },
          ),
          */

                      /*
          ListTile(
            title: Text('Enter fingerprint'),
            onTap: () async {
              var localAuth = LocalAuthentication();
              bool didAuthenticate =
                  await localAuth.authenticateWithBiometrics(
                      localizedReason: 'Please authenticate to show account balance');
            },
          ),
          */

                      
                      ListTile(
                        title: Text(
                          'Web',
                          style: TextStyle(fontSize: 16),
                        ),
                        onTap: () {
                          openPage(context, WebViewExample());
                        },
                      ),
                      Divider(),
                      new LanguageSelector(),
                      Divider(),
                      ListTile(
                        title: Text(
                          'Log out',
                          style: TextStyle(fontSize: 16),
                        ),
                        onTap: () async {
                          viewModel.logout();
                          openPageReplace(context, SplashScreen());
                        },
                      ),
                    ],
                  )) : Container();
        },
      ),
    );
  }
}
