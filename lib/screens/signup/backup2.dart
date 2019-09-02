import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fusewallet/logic/common.dart';
import 'package:fusewallet/modals/views/signin_viewmodel.dart';
import 'package:fusewallet/redux/state/app_state.dart';
import 'dart:core';
import 'package:fusewallet/screens/wallet/wallet.dart';
import 'package:fusewallet/widgets/widgets.dart';

class Backup2Page extends StatefulWidget {
  Backup2Page({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _Backup2PageState createState() => _Backup2PageState();
}

class _Backup2PageState extends State<Backup2Page> {
  List<int> selectedWordsNum = new List<int>();
  final _formKey = GlobalKey<FormState>();

  List<int> getRandom3Numbers() {
    var list = new List<int>.generate(12, (int index) => index + 1);
    list.shuffle();
    var _l = list.sublist(0, 3);
    _l.sort();
    return _l;
  }

  @override
  void initState() {
    super.initState();

    selectedWordsNum = getRandom3Numbers();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SignInViewModel>(converter: (store) {
      return SignInViewModel.fromStore(store);
    }, builder: (_, viewModel) {
      CustomScaffold(title: "Back up", children: <Widget>[
        Container(
          padding:
              EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0, top: 0.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 0),
                child: Text(
                    "Please write down words " + selectedWordsNum.join(", "),
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
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10, left: 30, right: 30),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: 'Word ' + selectedWordsNum[0].toString(),
                          ),
                          validator: (String value) {
                            if (viewModel
                                    .user.mnemonic[selectedWordsNum[0] - 1] !=
                                value) {
                              return 'The word does not match';
                            }
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: 'Word ' + selectedWordsNum[1].toString(),
                          ),
                          validator: (String value) {
                            if (viewModel
                                    .user.mnemonic[selectedWordsNum[1] - 1] !=
                                value) {
                              return 'The word does not match';
                            }
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: 'Word ' + selectedWordsNum[2].toString(),
                          ),
                          validator: (String value) {
                            if (viewModel
                                    .user.mnemonic[selectedWordsNum[2] - 1] !=
                                value) {
                              return 'The word does not match';
                            }
                          },
                        )
                      ],
                    )),
              )
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        Center(
            child: PrimaryButton(
          label: "NEXT",
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              viewModel.openWallet(context);
            }
          },
        )),
        const SizedBox(height: 30.0),
      ]);
    });
  }
}
