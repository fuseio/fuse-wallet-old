import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fusewallet/modals/views/wallet_viewmodel.dart';
import 'package:fusewallet/redux/state/app_state.dart';
import 'dart:core';
import 'package:fusewallet/widgets/widgets.dart';

class SwitchCommunityPage extends StatefulWidget {
  SwitchCommunityPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SwitchCommunityPageState createState() => _SwitchCommunityPageState();
}

class _SwitchCommunityPageState extends State<SwitchCommunityPage> {
  GlobalKey<ScaffoldState> scaffoldState;
  bool isLoading = false;
  final assetIdController = TextEditingController(text: "");
  bool isValid = true;

  @override
  void initState() {
    super.initState();
  }

/*
  void saveCommunityAddress(communityAddress) {
    intializeCommunity(communityAddress);
    Navigator.of(context).pop(true);
    Navigator.of(context).pop(true);
  }
*/

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: scaffoldState,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          backgroundColor: Theme.of(context).canvasColor,
        ),
        backgroundColor: const Color(0xFFF8F8F8),
        body: Container(
            child: Column(children: <Widget>[
          Expanded(
            child: Container(
              //color: Theme.of(context).primaryColor,
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("Switch community",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                  Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Text(
                        "You can switch to a new community by entering your Asset ID (available from the Fuse Studio) or scanning a QR code",
                        //textAlign: TextAlign.center,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.normal)),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0, bottom: 50, left: 30, right: 30),
            child: Form(
              child: new StoreConnector<AppState, WalletViewModel>(
                converter: (store) {
                  return WalletViewModel.fromStore(store);
                },
                builder: (_, viewModel) {
                  return Builder(
                      builder: (context) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(height: 16.0),
                              Center(
                                child: PrimaryButton(
                                  label: "SCAN QR CODE",
                                  onPressed: () async {
                                    var assetId = await BarcodeScanner.scan();
                                    viewModel.switchCommunity(assetId);
                                    Navigator.of(context).pop(true);
                                    Navigator.of(context).pop(true);
                                  },
                                  width: 300,
                                ),
                              ),
                              const SizedBox(height: 22.0),
                              Stack(
                                children: <Widget>[
                                  new SizedBox(
                                    height: 10.0,
                                    child: new Center(
                                      child: new Container(
                                        margin: new EdgeInsetsDirectional.only(
                                            start: 1.0, end: 1.0),
                                        height: 1.0,
                                        color: const Color(0xFF666666),
                                      ),
                                    ),
                                  ),
                                  Center(
                                      child: Container(
                                    padding:
                                        EdgeInsets.only(left: 18, right: 18),
                                    child: Text(
                                      "OR",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    decoration: const BoxDecoration(
                                        color: const Color(0xFFF8F8F8)),
                                  ))
                                ],
                              ),
                              const SizedBox(height: 22.0),
                              Center(
                                child: PrimaryButton(
                                  label: "ENTER COMMUNITY ADDRESS",
                                  onPressed: () async {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: Text("Community Address",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              content: Container(
                                                height: 150,
                                                child:
                                                    Column(children: <Widget>[
                                                  TextField(
                                                    controller:
                                                        assetIdController,
                                                  ),
                                                  const SizedBox(height: 22.0),
                                                  Row(
                                                    children: <Widget>[
                                                      Center(
                                                        child: PrimaryButton(
                                                          label: "SAVE",
                                                          onPressed: () {
                                                            viewModel.switchCommunity(assetIdController.text);
                                                            Navigator.of(context).pop(true);
                                                            Navigator.of(context).pop(true);
                                                          },
                                                          width: 250,
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ]),
                                              ),
                                            ));
                                  },
                                  width: 300,
                                ),
                              )
                            ],
                          ));
                },
              ),
            ),
          )
        ])));
  }
}
