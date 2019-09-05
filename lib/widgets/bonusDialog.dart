import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'dart:core';
import 'package:fusewallet/modals/transactions.dart';
import 'package:fusewallet/modals/views/wallet_viewmodel.dart';
import 'package:fusewallet/redux/state/app_state.dart';

class BonusDialog extends StatefulWidget {
  BonusDialog();

  @override
  createState() => new BonusDialogState();
}

class BonusDialogState extends State<BonusDialog> {
  BonusDialogState();

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
      builder: (_, viewModel) {

        if (viewModel.community == null) {
          return Container();
        }
        var letters = new List<Widget>();
        var lettersStr = viewModel.community.joinBonusAmount != null ? viewModel.community.joinBonusAmount.toString().split("") : new List<String>();
        for (var i = 0; i < lettersStr.length; i++) {
          letters.add(BonusLetter(lettersStr[i]));
        }
        letters.add(Text(".",
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500)));
        letters.add(BonusLetter("0"));
        letters.add(BonusLetter("0"));

        return AlertDialog(
          contentPadding: EdgeInsets.all(5.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
          content: Stack(
            children: <Widget>[
              Image.asset(
                'images/join-community-back.png',
              ),
              Container(
                //height: 400,
                width: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 30, bottom: 20),
                      child: Text(
                          "Hello " + viewModel.user.firstName + "!\n" + viewModel.community.joinBonusText.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Theme.of(context).textTheme.body1.color,
                              fontSize: 24,
                              fontWeight: FontWeight.w500)),
                    ),
                    Text("You got",
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 18,
                            fontWeight: FontWeight.w500)),
                    Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: letters,
                      ),
                    ),
                    Text("new " + viewModel.community.symbol + "'s!",
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 18,
                            fontWeight: FontWeight.w500)),
                    Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: Image.asset(
                        'images/join-community-pic.png',
                        width: 150,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        color: Theme.of(context).primaryColor,
                        padding: EdgeInsets.only(
                            top: 20, bottom: 20, left: 70, right: 70),
                        child: Text(
                          "Start",
                          style: TextStyle(
                              color: const Color(0xFFfae83e),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class BonusLetter extends StatelessWidget {
  const BonusLetter(this._letter);

  final String _letter;

  @override
  Widget build(BuildContext context) {
    return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 5),
                            decoration: new BoxDecoration(
                                border: new Border.all(color: Colors.black12),
                                borderRadius: BorderRadius.circular(5.0)),
                            child: Text(_letter,
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500)),
                          );
  }
}