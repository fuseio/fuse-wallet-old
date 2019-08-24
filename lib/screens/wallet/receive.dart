import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fusewallet/modals/views/wallet_viewmodel.dart';
import 'package:fusewallet/redux/state/app_state.dart';
import 'package:fusewallet/widgets/widgets.dart';
import 'dart:core';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:fusewallet/generated/i18n.dart';

class ReceivePage extends StatefulWidget {
  ReceivePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ReceivePageState createState() => _ReceivePageState();
}

String sendAddress = "";

class _ReceivePageState extends State<ReceivePage> {
  bool isLoading = false;
  final myController = TextEditingController(text: "10");

  @override
  void initState() {
    super.initState();

    //startNFC();
  }

  @override
  Widget build(BuildContext _context) {
    final scaffoldState = new GlobalKey<ScaffoldState>();

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: CustomScrollView(
        physics: NeverScrollableScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 100,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(I18n.of(context).receive,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w900)),
              centerTitle: true,
              collapseMode: CollapseMode.parallax,
            ),
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            backgroundColor: Theme.of(context).canvasColor,
          ),
          SliverFillRemaining(
              child: new StoreConnector<AppState, WalletViewModel>(
            converter: (store) {
              return WalletViewModel.fromStore(store);
            },
            builder: (_, viewModel) {
              return Builder(
                  builder: (context) => Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                bottom: 20.0,
                                top: 0.0),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 0),
                                  child: Text(
                                      I18n.of(context).receiveDescription,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal)),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: Container(
                                  padding: EdgeInsets.only(top: 0),
                                  width: 220,
                                  child: viewModel.user.publicKey != ""
                                      ? new QrImage(
                                          data: viewModel.user.publicKey,
                                          //onError: (ex) {
                                          //  print("[QR] ERROR - $ex");
                                          //},
                                        )
                                      : new Text("No public key found"),
                                ),
                              ),
                              Container(
                                width: 220,
                                padding: EdgeInsets.only(top: 20),
                                child: new Text(viewModel.user.publicKey,
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Container(
                                width: 250,
                                padding: EdgeInsets.only(top: 20),
                                child: Opacity(
                                  opacity: 0.5,
                                  child: Center(
                                    child: CopyToClipboard(
                                      scaffoldState: scaffoldState,
                                      content: viewModel.user.publicKey,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                        ],
                      ));
            },
          )),
        ],
      ),
    );
  }
}
