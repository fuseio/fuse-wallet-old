import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:core';
import 'package:fusewallet/logic/common.dart';
//import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';
import 'package:fusewallet/screens/signup/backup1.dart';
import 'package:fusewallet/screens/wallet/protect_wallet.dart';
import 'package:fusewallet/screens/wallet/switch_community.dart';
import 'package:fusewallet/screens/wallet/studio_webview.dart';
import 'package:fusewallet/screens/wallet/deposit_webview.dart';
import 'package:intl/intl.dart';
//import 'package:local_auth/local_auth.dart';

import 'package:fusewallet/splash.dart';
import 'language-selector.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fusewallet/modals/views/drawer_viewmodel.dart';
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
      child: new StoreConnector<AppState, DrawerViewModel>(
        converter: (store) {
          return DrawerViewModel.fromStore(store);
        },
        builder: (_, viewModel) {
          dynamic widgets = <Widget>[
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
            ListTile(
              title: Text(
                'Fuse studio',
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {
                openPage(context, FuseStudioWebView());
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
                Navigator.of(context).pop();
                viewModel.logout();
                openPageReplace(context, SplashScreen());
              },
            ),
          ];
          dynamic plugins = viewModel.community != null ? viewModel.community.plugins.getDepositPlugins() : [];
          for (dynamic plugin in plugins) {
                widgets.add(Divider());
            widgets.add(ListTile(
              title: Text(
                'Top up with ${toBeginningOfSentenceCase(plugin.name)}',
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DepositWebView(depositPlugin: plugin)),
                );
                // openPage(context, DepositWebView(builder: (context) => ));
              },
            ));
          }
          return viewModel.user != null ? Builder(
              builder: (context) => ListView(
                    padding: EdgeInsets.zero,
                    children: widgets,
                  )) : Container();
        },
      ),
    );
  }
}
