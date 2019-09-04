import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:core';
import 'package:fusewallet/logic/globals.dart' as globals;
import 'package:fusewallet/logic/common.dart';
import 'package:fusewallet/screens/wallet/buy.dart';
import 'package:fusewallet/screens/wallet/receive.dart';
import 'package:fusewallet/generated/i18n.dart';
import 'package:fusewallet/screens/wallet/sendAmount.dart';

class CustomScaffold extends StatelessWidget {
  CustomScaffold({this.title, this.children, this.key});
  final String title;
  final List<Widget> children;
  final Key key;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      backgroundColor: Theme.of(context).canvasColor,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
//              title: Text("hello"),
            expandedHeight: 100,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(title,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.body1.color,
                      fontSize: 20,
                      fontWeight: FontWeight.w900)),
              centerTitle: true,
              collapseMode: CollapseMode.parallax,
              //background: Container(
              //color: Theme.of(context).canvasColor,
              //),
            ),
            iconTheme: IconThemeData(color: Theme.of(context).textTheme.body1.color),
            backgroundColor: Theme.of(context).canvasColor,
          ),
          SliverList(
            delegate: SliverChildListDelegate(children),
          )
        ],
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  PrimaryButton(
      {this.onPressed, this.label, this.width, this.height, this.preload});
  final GestureTapCallback onPressed;
  final String label;
  final double width;
  final double height;
  final bool preload;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 200.0,
      height: height ?? 50.0,
      decoration: BoxDecoration(
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
          borderRadius: new BorderRadius.all(new Radius.circular(30.0))),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onPressed,
            child: Center(
              child: (preload == null || preload == false)
                  ? Text(
                      label,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.button.color,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    )
                  : Container(
                      child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor)),
                      width: 21.0,
                      height: 21.0,
                      margin: EdgeInsets.only(left: 28, right: 28),
                    ),
            )),
      ),
    );
  }
}

class TransparentButton extends StatelessWidget {
  TransparentButton({this.onPressed, this.label, this.width, this.height});
  final GestureTapCallback onPressed;
  final String label;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new InkWell(
        highlightColor: Colors.transparent,
        onTap: onPressed,
        child: new Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: Text(label,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500)),
        ),
      ),
      color: Colors.transparent,
    );
  }
}

class Preloader extends StatelessWidget {
  Preloader({this.width, this.height});
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: new AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor)),
        width: width ?? 60.0,
        height: height ?? 60.0,
        margin: EdgeInsets.only(left: 28, right: 28),
      ),
    );
  }
}

Widget bottomBar(context) {
  return new Container(
    padding: EdgeInsets.only(
        top: 0.0, bottom: isIPhoneX() ? 16 : 0, right: 0.0, left: 0.0),
    color: const Color(0xFFFFFFFF),
    child: new Directionality(
      textDirection: TextDirection.rtl,
      child: new Row(
        //crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          bottomBarItem("send.png", I18n.of(context).send, () {
            openPage(globals.scaffoldKey.currentContext, new SendAmountPage());
          }),
          bottomBarItem("buy.png", I18n.of(context).buy, () {
            openPage(globals.scaffoldKey.currentContext, new BuyPage());
          }),
          bottomBarItem("recieve.png", I18n.of(context).receive, () {
            openPage(globals.scaffoldKey.currentContext, new ReceivePage());
          })
        ],
      ),
    ),
  );
}

Widget bottomBarItem(String img, String text, ontap) {
  return new Material(
    color: Colors.transparent,
    child: new InkWell(
      borderRadius: BorderRadius.all(new Radius.circular(30.0)),
      child: new Container(
        width: 100,
        padding:
            const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 0.0, left: 0.0),
        child: new Column(
          children: <Widget>[
            Image.asset('images/' + img,
                width: 28.0, color: const Color(0xFF979797)),
            new Text(text,
                style: new TextStyle(
                    fontSize: 14.0, color: const Color(0xFF979797)))
          ],
        ),
      ),
      onTap: ontap,
    ),
  );
}

class CopyToClipboard extends StatelessWidget {
  CopyToClipboard({this.scaffoldState, this.context, this.content});
  final GlobalKey<ScaffoldState> scaffoldState;
  final BuildContext context;
  final String content;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      child: Text("Copy to clipboard",
          style: TextStyle(
              color: const Color(0xFF546c7c),
              fontSize: 16,
              fontWeight: FontWeight.w500)),
      onTap: () async {
        Clipboard.setData(
            new ClipboardData(text: content));
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text(
            "Copied to Clipboard",
            textAlign: TextAlign.center,
          ),
        ));
      },
    );
  }
}
