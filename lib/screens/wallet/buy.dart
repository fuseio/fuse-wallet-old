import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'dart:core';
import 'package:fusewallet/logic/common.dart';
import 'package:fusewallet/modals/views/wallet_viewmodel.dart';
import 'package:fusewallet/redux/state/app_state.dart';
import 'package:fusewallet/screens/wallet/business.dart';
import 'package:fusewallet/logic/globals.dart' as globals;
import 'package:fusewallet/screens/wallet/sendAmount.dart';
import 'package:fusewallet/widgets/widgets.dart';

class BuyPage extends StatefulWidget {
  BuyPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BuyPageState createState() => _BuyPageState();
}

//List<Business> businessesList = [];

class _BuyPageState extends State<BuyPage> {
  GlobalKey<ScaffoldState> scaffoldState;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: scaffoldState,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
        ),
        body: ListView(children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.all(20.0),
            child: Text("Buy",
                style: TextStyle(
                    color: const Color(0xFFFFFFFF),
                    fontSize: 38,
                    fontWeight: FontWeight.bold)),
          ),
          new StoreConnector<AppState, WalletViewModel>(
            converter: (store) {
              return WalletViewModel.fromStore(store);
            },
            onInitialBuild: (viewModel) {
              viewModel.loadBusinesses();
            },
            builder: (_, viewModel) {
              return Builder(
                  builder: (context) => !viewModel.isLoading
                      ? new BusinessesListView()
                      : Padding(
                          child: Preloader(),
                          padding: EdgeInsets.only(top: 70),
                        ));
            },
          )
        ]));
  }
}

class BusinessesListView extends StatefulWidget {
  @override
  createState() => new BusinessesListViewState();
}

class BusinessesListViewState extends State<BusinessesListView> {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, WalletViewModel>(
      converter: (store) {
        return WalletViewModel.fromStore(store);
      },
      builder: (_, viewModel) {
        return Builder(
            builder: (context) => new Container(
                  padding: const EdgeInsets.all(8.0),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          new Expanded(
                            child: new Padding(
                                padding: new EdgeInsets.only(bottom: 5.0),
                                child: ListView.separated(
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          new Divider(),
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemCount: viewModel.businesses?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      leading: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            //color: Colors.black12
                                            ),
                                        child: ClipOval(
                                            child: Image.network(
                                          viewModel.businesses[index].image,
                                          fit: BoxFit.cover,
                                          width: 50.0,
                                          height: 50.0,
                                        )),
                                      ),
                                      title: Text(
                                        viewModel.businesses[index].name,
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      subtitle: Text(
                                          viewModel.businesses[index].address),
                                      onTap: () {
                                        openPage(
                                            globals.scaffoldKey.currentContext,
                                            new BusinessPage(
                                              business:
                                                  viewModel.businesses[index],
                                            ));
                                      },
                                      trailing: FlatButton(
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    30.0)),
                                        color: Theme.of(context).accentColor,
                                        padding: EdgeInsets.all(0),
                                        child: Text(
                                          "Pay",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onPressed: () {
                                          viewModel.sendAddress(viewModel.businesses[index].account);
                                          openPage(
                                              globals
                                                  .scaffoldKey.currentContext,
                                              new SendAmountPage());
                                        },
                                      ),
                                    );
                                  },
                                )),
                          )
                        ],
                      )
                    ],
                  ),
                ));
      },
    );
  }
}
