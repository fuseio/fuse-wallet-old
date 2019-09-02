import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'dart:core';
import 'package:flutter/services.dart';
import 'package:fusewallet/services/wallet_service.dart';
import 'package:fusewallet/widgets/widgets.dart';
import 'package:fusewallet/logic/common.dart';
import 'package:fusewallet/logic/globals.dart' as globals;
import 'package:fusewallet/generated/i18n.dart';
import 'package:fusewallet/modals/views/wallet_viewmodel.dart';
import 'package:fusewallet/redux/state/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';

Future scan() async {
  try {
    openPage(globals.scaffoldKey.currentContext, new SendPage());
  } on PlatformException catch (e) {
    if (e.code == BarcodeScanner.CameraAccessDenied) {
    } else {}
  } on FormatException {} catch (e) {}
}

final addressController = TextEditingController(text: "");

Future openCameraScan(openPage) async {
  addressController.text = await BarcodeScanner.scan();
  if (openPage) {
    openPage(globals.scaffoldKey.currentContext, new SendPage());
  }
}

class SendPage extends StatefulWidget {
  SendPage({Key key, this.title, this.address, this.privateKey})
      : super(key: key);

  final String title;
  final String address;
  final String privateKey;

  @override
  _SendPageState createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  GlobalKey<ScaffoldState> scaffoldState;
  //bool isLoading = false;

  final amountController = TextEditingController(text: "");

  @override
  void initState() {
    addressController.text = widget.address;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    /*
    void sendTransaction(_context) {
      setState(() {
        isLoading = true;
      });
      try {
        sendNIS(cleanAddress(addressController.text),
                int.parse(amountController.text), widget.privateKey)
            .then((ret) {
          Navigator.of(context).pop();

          Scaffold.of(_context).showSnackBar(new SnackBar(
            content: new Text('Transaction sent successfully'),
            //duration: new Duration(seconds: 5),
          ));

          setState(() {
            isLoading = false;
          });
        });
      } catch (e) {
        print(e.toString());
        Scaffold.of(_context).showSnackBar(new SnackBar(
          content: new Text("Error sending transaction: " + e.toString()),
        ));
        setState(() {
          isLoading = false;
        });
      }
    }
    */

    return CustomScaffold(title: I18n.of(context).send, children: <Widget>[
      new StoreConnector<AppState, WalletViewModel>(
        converter: (store) {
          return WalletViewModel.fromStore(store);
        },
        builder: (_, viewModel) {
          return Builder(
              builder: (context) => Container(
                    padding: EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 20.0, top: 0.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 0),
                          child: Text(I18n.of(context).sendDescription,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal)),
                        ),
                        Container(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(top: 10),
                                child: Stack(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  children: <Widget>[
                                    TextFormField(
                                      controller: addressController,
                                      autofocus: true,
                                      style: const TextStyle(fontSize: 18),
                                      decoration: InputDecoration(
                                        labelText: I18n.of(context).address,
                                      ),
                                      validator: (String value) {
                                        if (value.trim().isEmpty) {
                                          return 'Address is required';
                                        }
                                      },
                                    ),
                                    Padding(
                                      child: InkWell(
                                        child: Image.asset('images/scan.png',
                                            width: 28.0),
                                        onTap: () {
                                          openCameraScan(false);
                                        },
                                      ),
                                      padding: EdgeInsets.only(
                                          bottom: 14, right: 20),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 30),
                                child: Stack(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  children: <Widget>[
                                    TextFormField(
                                      controller: amountController,
                                      autofocus: true,
                                      keyboardType: TextInputType.number,
                                      style: const TextStyle(fontSize: 18),
                                      decoration: InputDecoration(
                                        labelText: I18n.of(context).amount,
                                      ),
                                      validator: (String value) {
                                        if (value.trim().isEmpty) {
                                          return 'Amount is required';
                                        }
                                      },
                                    ),
                                    Padding(
                                      child: Text(
                                        "\$",
                                        style: TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.normal,
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                      padding: EdgeInsets.only(
                                          bottom: 12, right: 18),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30.0),
                              Center(
                                  child: PrimaryButton(
                                label: I18n.of(context).send,
                                onPressed: () async {
                                  viewModel.sendTransaction(context, cleanAddress(addressController.text), amountController.text);
                                },
                                preload: viewModel.isLoading,
                              ))
                            ],
                          ),
                        )
                      ],
                    ),
                  ));
        },
      ),
    ]);
  }
}
