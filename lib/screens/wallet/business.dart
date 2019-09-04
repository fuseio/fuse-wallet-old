import 'package:flutter/material.dart';
import 'dart:core';
import 'package:fusewallet/logic/common.dart';
import 'package:fusewallet/logic/globals.dart' as globals;
import 'package:fusewallet/modals/businesses.dart';
import 'package:fusewallet/screens/wallet/sendAmount.dart';

class BusinessPage extends StatefulWidget {
  BusinessPage({Key key, this.title, this.business}) : super(key: key);

  final String title;
  final Business business;

  @override
  _BusinessPageState createState() => _BusinessPageState();
}

class _BusinessPageState extends State<BusinessPage> {
  GlobalKey<ScaffoldState> scaffoldState;
  bool isLoading = false;
  final addressController = TextEditingController(text: "");
  final amountController = TextEditingController(text: "");

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
            height: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(widget.business.name,
                      style: TextStyle(
                          color: const Color(0xFFFFFFFF),
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                ),
                Text(widget.business.address,
                    style: TextStyle(
                        color: const Color(0xFFFFFFFF),
                        fontSize: 14,
                        fontWeight: FontWeight.normal))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(widget.business.description,
                style: TextStyle(
                    color: const Color(0xFF666666),
                    height: 1.3,
                    fontSize: 14,
                    fontWeight: FontWeight.normal)),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0, bottom: 0, left: 20, right: 20),
            child: Container(width: 200, child: FlatButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              color: Theme.of(context).accentColor,
              padding: EdgeInsets.all(0),
              child: Text(
                "Pay",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                //widget.business.account
                openPage(globals.scaffoldKey.currentContext,
                    new SendAmountPage());
              },
            )),
          ),
          Container(
            height: 200,
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: const Color(0xFFEAEAEA),
                borderRadius: new BorderRadius.all(new Radius.circular(15.0))),
            child: Image.network(
              widget.business.image,
              fit: BoxFit.cover,
              width: 50.0,
              height: 50.0,
            ),
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
    return new Container(
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
                      separatorBuilder: (BuildContext context, int index) =>
                          new Divider(),
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: 50,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: new CircleAvatar(
                              backgroundColor: const Color(0xFFEAEAEA)),
                          title: Text('Nina | מסעדת נינא'),
                          subtitle: Text('Herzel st'),
                          onTap: () {},
                        );
                      },
                    )),
              )
            ],
          )
        ],
      ),
    );
  }
}
