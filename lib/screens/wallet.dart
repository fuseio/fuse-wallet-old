import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fusewallet/modals/views/wallet_wrappermodel.dart';
import 'dart:core';
import 'package:fusewallet/globals.dart' as globals;
import 'package:fusewallet/modals/views/wallet_viewmodel.dart';
import 'package:fusewallet/redux/actions/wallet_actions.dart';
import 'package:fusewallet/redux/state/app_state.dart';
import 'package:fusewallet/screens/send.dart';
import 'package:fusewallet/widgets/drawer.dart';
import 'package:fusewallet/widgets/transactions_list.dart';
import 'package:fusewallet/widgets/widgets.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WalletPage extends StatefulWidget {
  WalletPage({Key key, this.title, this.walletWrapperViewModel})
      : super(key: key);

  final String title;
  final WalletWrapperViewModel walletWrapperViewModel;

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final flutterWebviewPlugin = FlutterWebviewPlugin();
  bool isLoading = true;
  String _firstName;
  String _lastName;
  String _account;
  String _pk;
  bool _has3boxAccount;

  StreamSubscription _onDestroy;
  StreamSubscription _onUrlChange;
  StreamSubscription<WebViewStateChanged> _onStateChanged;


  void launchJoinWebview() async {
    var communityAddress = widget.walletWrapperViewModel.communityAddress;
    await flutterWebviewPlugin.launch(
        'https://communities-qa.cln.network/view/join/$communityAddress',
        hidden: true,
        withJavascript: true);
  }

  void launchWebview() async {
    await flutterWebviewPlugin.launch(
        'https://communities-qa.cln.network/view/sign/isMobileApp',
        hidden: true,
        withJavascript: true);
  }

  String getInjectString() {
    return ("""
      window.user = {
        firstName: '$_firstName',
        lastName: '$_lastName',
        account: '$_account'
      }
      window.pk = '0x$_pk'
    """);
  }

  @override
  void didUpdateWidget(WalletPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.walletWrapperViewModel.communityChanged) {
      launchJoinWebview();


      _onUrlChange = flutterWebviewPlugin.onUrlChanged.listen((String url) {
        if (mounted) {
          if (url == 'https://communities-qa.cln.network/') {
            widget.walletWrapperViewModel.toggleCommunityChange(false);
            flutterWebviewPlugin.close();
          }
        }
      });

      _onStateChanged = flutterWebviewPlugin.onStateChanged
          .listen((WebViewStateChanged state) {
        if (mounted) {
          if (state.type == WebViewState.finishLoad &&
              state.url.contains('/join')) {
            String jsCode = getInjectString();
            flutterWebviewPlugin.evalJavascript(jsCode);
          }

          if (state.type == WebViewState.startLoad &&
              state.url == 'https://communities-qa.cln.network/') {
            widget.walletWrapperViewModel.toggleCommunityChange(false);
            flutterWebviewPlugin.close();
          }
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.close();
    _firstName = widget.walletWrapperViewModel.user?.firstName;
    _lastName = widget.walletWrapperViewModel.user?.lastName;
    _account = widget.walletWrapperViewModel.user?.publicKey;
    _pk = widget.walletWrapperViewModel.user?.privateKey;
    _has3boxAccount = widget.walletWrapperViewModel.has3boxAccount;

    if (_has3boxAccount == false) {
      launchWebview();

      _onUrlChange = flutterWebviewPlugin.onUrlChanged.listen((String url) {
        if (mounted) {
          if (url == 'https://communities-qa.cln.network/') {
            widget.walletWrapperViewModel.updateHas3boxAccount();
            flutterWebviewPlugin.close();
          }
        }
      });

      _onStateChanged = flutterWebviewPlugin.onStateChanged
          .listen((WebViewStateChanged state) {
        if (mounted) {
          if (state.type == WebViewState.finishLoad &&
              state.url.contains('/sign')) {
            String jsCode = getInjectString();
            flutterWebviewPlugin.evalJavascript(jsCode);
          }

          if (state.url == 'https://communities-qa.cln.network/') {
            widget.walletWrapperViewModel.updateHas3boxAccount();
            flutterWebviewPlugin.close();
          }
        }
      });
    }

  }

  @override
  void dispose() {
    _onDestroy.cancel();
    _onUrlChange.cancel();
    _onStateChanged.cancel();

    flutterWebviewPlugin.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext _context) {
    return new Scaffold(
        key: globals.scaffoldKey,
        appBar: AppBar(
          title: InkWell(
            child: Image.asset(
              'images/' + globals.walletLogo,
              width: 95.0,
              gaplessPlayback: true,
              //color: Theme.of(context).accentColor,
            ),
            onTap:
                () {}, //sendToken("0x1b36c26c8f3b330787f6be03083eb8b9b2f1a6d5"); },
          ),
          centerTitle: true,
          actions: <Widget>[
            Builder(
                builder: (context) => IconButton(
                      icon: const Icon(Icons.refresh),
                      color: const Color(0xFFFFFFFF),
                      tooltip: 'refresh',
                      onPressed: () async {
                        //loadBalance();
                        //loadTransactions();

                        //print(generateMnemonic());
                      },
                    )),
          ],
          elevation: 0.0,
        ),
        drawer: new DrawerWidget(),
        body: new StoreConnector<AppState, WalletViewModel>(onInit: (store) {
          store.dispatch(initWalletCall());
        }, converter: (store) {
          return WalletViewModel.fromStore(store);
        }, builder: (_, viewModel) {
          return Column(
            children: <Widget>[
              Expanded(
                child: ListView(
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
                                  style: Theme.of(context).textTheme.title,
                                  children: <TextSpan>[
                                    new TextSpan(
                                        text: 'Welcome',
                                        style: TextStyle(
                                            fontSize: 42,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300)),
                                    new TextSpan(
                                        text: ' ' + viewModel.user.firstName,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Container(
                                        child: Text("Balance",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.0)),
                                        padding: EdgeInsets.only(bottom: 6.0),
                                      ),
                                      new Container(
                                        padding: EdgeInsets.only(
                                            left: 20.0,
                                            right: 20.0,
                                            top: 2.0,
                                            bottom: 2.0),
                                        decoration: new BoxDecoration(
                                            border: new Border.all(
                                                color: const Color(0xFFb4bdc4),
                                                width: 3.0),
                                            borderRadius: new BorderRadius.only(
                                              topLeft: new Radius.circular(0.0),
                                              topRight:
                                                  new Radius.circular(30.0),
                                              bottomRight:
                                                  new Radius.circular(30.0),
                                              bottomLeft:
                                                  new Radius.circular(30.0),
                                            )),
                                        child:
                                            /*
                                      isLoading
                                          ? Container(
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 3),
                                              width: 22.0,
                                              height: 22.0,
                                              margin: EdgeInsets.only(
                                                  left: 28,
                                                  right: 28,
                                                  top: 8,
                                                  bottom: 8))
                                          : 
                                          */
                                            new RichText(
                                          text: new TextSpan(
                                            // Note: Styles for TextSpans must be explicitly defined.
                                            // Child text spans will inherit styles from parent
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
                                                          FontWeight.bold)),
                                              new TextSpan(
                                                  text: " \$",
                                                  style: new TextStyle(
                                                      fontSize: 26,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.normal,
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
                                          openCameraScan(false);
                                          //sendToken("0x1b36c26c8f3b330787f6be03083eb8b9b2f1a6d5", 52);
                                          //getEntity();
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
                    new TransactionsWidget(viewModel.transactions?.transactions)
                  ],
                ),
              ),
              bottomBar()
            ],
          );
        }));
  }
}
