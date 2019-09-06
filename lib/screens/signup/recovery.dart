import 'package:flutter/material.dart';
import 'dart:core';
import 'package:flutter/services.dart';
import 'package:fusewallet/logic/common.dart';
import 'package:fusewallet/screens/wallet/wallet.dart';
import 'package:fusewallet/widgets/widgets.dart';

class RecoveryPage extends StatefulWidget {
  RecoveryPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RecoveryPageState createState() => _RecoveryPageState();
}

class _RecoveryPageState extends State<RecoveryPage> {
  GlobalKey<ScaffoldState> scaffoldState;
  bool isLoading = false;
  final wordsController = TextEditingController(text: "");
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return 
    CustomScaffold(
      title:"Recover your wallet",
    children: <Widget>[
      
          Container(
            //color: Theme.of(context).primaryColor,
            padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0, top: 0.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: Text(
                      "This is a 12 word phrase you were given when you created your previous wallet",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.normal)),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 30, right: 30),
            child: Form(
              key: _formKey,
              child: Column(
              children: <Widget>[
                TextFormField(
                  controller: wordsController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  autofocus: false,
                  decoration: const InputDecoration(
                    labelText: 'Write down your 12 words...',
                  ),
                  validator: (String value) {
                    if (value.split(" ").length != 12) {
                      return 'Please enter 12 words';
                    }
                  },
                )
              ],
            ),
            ),
          ),
          const SizedBox(height: 16.0),
          Center(
              child: PrimaryButton(
            label: "NEXT",
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                //await WalletLogic.setMnemonic(wordsController.text);
                openPageReplace(context, WalletPage());
              }
            },
          )),
        
    ]);

  }

}
