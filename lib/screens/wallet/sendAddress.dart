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
    openPage(globals.scaffoldKey.currentContext, new SendAddressPage());
  } on PlatformException catch (e) {
    if (e.code == BarcodeScanner.CameraAccessDenied) {
    } else {}
  } on FormatException {} catch (e) {}
}

class SendAddressPage extends StatefulWidget {
  SendAddressPage({Key key, this.useSavedAddress}) : super(key: key);
  final bool useSavedAddress;

  @override
  _SendAddressPageState createState() => _SendAddressPageState();
}

class _SendAddressPageState extends State<SendAddressPage> {
  GlobalKey<ScaffoldState> scaffoldState;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0.0,
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            backgroundColor: Theme.of(context).canvasColor,
          ),
          backgroundColor: const Color(0xFFF8F8F8),
          body: SendAddressForm(useSavedAddress: widget.useSavedAddress));
  }
}

class SendAddressForm extends StatefulWidget {
  SendAddressForm({Key key, this.address, this.useSavedAddress}) : super(key: key);

  final String address;
  final bool useSavedAddress;

  @override
  _SendAddressFormState createState() => _SendAddressFormState();
}

class _SendAddressFormState extends State<SendAddressForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, WalletViewModel>(converter: (store) {
      return WalletViewModel.fromStore(store);
    }, builder: (_, viewModel) {

      print('useSavedAddress useSavedAddress useSavedAddress useSavedAddress');
      print(widget.useSavedAddress);
      final addressController = widget.useSavedAddress ? TextEditingController(text: viewModel.walletState.sendAddress) : TextEditingController();

      Future openCameraScan(openPage) async {
        viewModel.sendAddress(await BarcodeScanner.scan());
        if (openPage) {
          openPage(globals.scaffoldKey.currentContext, new SendAddressPage());
        }
      }

      return Container(
          child: Column(children: <Widget>[
        Expanded(
            child: Container(
          child: Column(
            children: <Widget>[
              Container(
                //color: Theme.of(context).primaryColor,
                padding: EdgeInsets.only(bottom: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text("Send",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 30,
                            fontWeight: FontWeight.w900))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 0),
                child: Text(I18n.of(context).sendDescription,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.normal)),
              ),
              Padding(
                padding: EdgeInsets.all(30),
                child: Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: <Widget>[
                      TextFormField(
                        controller: addressController,
                        autofocus: false,
                        style: const TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              right: 60, left: 30, top: 18, bottom: 18),
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
                          child: Image.asset('images/scan.png', width: 28.0),
                          onTap: () {
                            openCameraScan(false);
                          },
                        ),
                        padding: EdgeInsets.only(bottom: 14, right: 20),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Amount",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.normal)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(viewModel.walletState.sendAmount.toString(),
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 60,
                                  fontWeight: FontWeight.w900)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 11.0, left: 5),
                          child: Text(viewModel.token.symbol,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal)),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        )),
        const SizedBox(height: 30.0),
        Center(
            child: PrimaryButton(
          label: "SEND",
          onPressed: () async {
            viewModel.sendAddress(addressController.text);
            viewModel.sendTransaction(context);
          },
          preload: viewModel.isLoading,
          width: 300,
        )),
        const SizedBox(height: 40.0),
      ]));
    });
  }
}
