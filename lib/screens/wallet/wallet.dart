import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fusewallet/logic/common.dart';
import 'dart:core';
import 'package:fusewallet/logic/globals.dart' as globals;
import 'package:fusewallet/modals/views/wallet_viewmodel.dart';
import 'package:fusewallet/redux/actions/wallet_actions.dart';
import 'package:fusewallet/redux/state/app_state.dart';
import 'package:fusewallet/screens/wallet/sendAmount.dart';
import 'package:fusewallet/widgets/drawer.dart';
import 'package:fusewallet/widgets/transactions_list.dart';
import 'package:fusewallet/widgets/widgets.dart';
import 'package:fusewallet/generated/i18n.dart';
import 'package:share/share.dart';

class WalletPage extends StatefulWidget {
  WalletPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext _context) {
    return new StoreConnector<AppState, WalletViewModel>(
      converter: (store) {
        return WalletViewModel.fromStore(store);
      },
      onInit: (store) {
        store.dispatch(switchCommunityCall(context, null, null, null));
      },
      builder: (_, viewModel) {

        Future openCameraScan() async {
          viewModel.sendAddress(await BarcodeScanner.scan());
          openPage(context, new SendAmountPage(useSavedAddress: true,));
        }
        return viewModel.user == null ||
                viewModel.community == null ||
                viewModel.isLoading
            ? Scaffold(
                body: Container(
                    child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 20,
                    child: Container(
                        decoration: BoxDecoration(
                          // Box decoration takes a gradient
                          gradient: LinearGradient(
                            // Where the linear gradient begins and ends
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            // Add one stop for each color. Stops should increase from 0 to 1
                            //stops: [0.1, 0.5, 0.7, 0.9],
                            colors: [
                              // Colors are easy thanks to Flutter's Colors class.
                              Theme.of(context).primaryColorLight,
                              Theme.of(context).primaryColorDark,
                            ],
                          ),
                        ),
                        //alignment: FractionalOffset(0.5, 0.5),
                        child: Preloader()),
                  ),
                ],
              )))
            : new Scaffold(
                appBar: AppBar(
                  backgroundColor: Theme.of(context).primaryColor,
                  title: InkWell(
                    child: Image.asset(
                      'images/seedbed.png',
                      width: 95.0,
                      gaplessPlayback: true,
                    ),
                    onTap: () {},
                  ),
                  centerTitle: true,
                  actions: <Widget>[
                    Builder(
                        builder: (context) => IconButton(
                              icon: const Icon(Icons.share),
                              color: const Color(0xFFFFFFFF),
                              tooltip: 'refresh',
                              onPressed: () async {
                                //viewModel.loadBalances(context);
                                Share.share('Hey, your friend shared with you the Fuse wallet: http://fuseio.app.link/PKSgcxA6KZ');
                              },
                            )),
                  ],
                  elevation: 0.0,
                ),
                drawer: new DrawerWidget(),
                body: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView(
                        //physics: const BouncingScrollPhysics(),
                        physics: ClampingScrollPhysics(),
                        children: <Widget>[
                          Container(
                            height: 260.0,
                            alignment: Alignment.bottomLeft,
                            padding: EdgeInsets.all(20.0),
                            color: Theme.of(context).primaryColor,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Expanded(
                                    child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 0.0),
                                    child: new RichText(
                                      text: new TextSpan(
                                        // Note: Styles for TextSpans must be explicitly defined.
                                        // Child text spans will inherit styles from parent
                                        style:
                                            Theme.of(context).textTheme.title,
                                        children: <TextSpan>[
                                          new TextSpan(
                                              text: I18n.of(context).welcome,
                                              style: TextStyle(
                                                  fontSize: 42,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300)),
                                          new TextSpan(
                                              text: ' ' +
                                                  (viewModel.user?.firstName ?? ""),
                                              style: TextStyle(
                                                  fontSize: 42,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Container(
                                    padding: EdgeInsets.only(bottom: 0.0),
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      verticalDirection: VerticalDirection.up,
                                      textDirection: TextDirection.ltr,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new Container(
                                              child: Text(
                                                  I18n.of(context).balance,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.0)),
                                              padding:
                                                  EdgeInsets.only(bottom: 6.0),
                                            ),
                                            new Container(
                                              padding: EdgeInsets.only(
                                                  left: 20.0,
                                                  right: 20.0,
                                                  top: 2.0,
                                                  bottom: 2.0),
                                              decoration: new BoxDecoration(
                                                  border: new Border.all(
                                                      color: const Color(
                                                          0xFFb4bdc4),
                                                      width: 3.0),
                                                  borderRadius:
                                                      new BorderRadius.only(
                                                    topLeft:
                                                        new Radius.circular(
                                                            0.0),
                                                    topRight:
                                                        new Radius.circular(
                                                            30.0),
                                                    bottomRight:
                                                        new Radius.circular(
                                                            30.0),
                                                    bottomLeft:
                                                        new Radius.circular(
                                                            30.0),
                                                  )),
                                              child: new RichText(
                                                text: new TextSpan(
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .title,
                                                  children: <TextSpan>[
                                                    new TextSpan(
                                                        text: viewModel.balance
                                                            .toString(),
                                                        style: new TextStyle(
                                                            fontSize: 32,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    new TextSpan(
                                                        text: " " +
                                                            viewModel.token?.symbol.toString(),
                                                        style: new TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            height: 0.0)),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        new Container(
                                          child: new FloatingActionButton(
                                              backgroundColor:
                                                  const Color(0xFF031c2c),
                                              elevation: 0,
                                              child: Image.asset(
                                                'images/scan.png',
                                                width: 25.0,
                                                color: Colors.white,
                                              ),
                                              onPressed: () async {
                                                openCameraScan();
                                              }),
                                          width: 50.0,
                                          height: 50.0,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          new TransactionsWidget()
                        ],
                      ),
                    ),
                    bottomBar(context)
                  ],
                ));
      },
    );
  }
}
