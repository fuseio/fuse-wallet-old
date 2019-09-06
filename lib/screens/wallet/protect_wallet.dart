import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fusewallet/modals/views/signin_viewmodel.dart';
import 'package:fusewallet/modals/views/wallet_viewmodel.dart';
import 'package:fusewallet/redux/state/app_state.dart';
import 'dart:core';
import 'package:fusewallet/widgets/widgets.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class ProtectWalletPage extends StatefulWidget {
  ProtectWalletPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ProtectWalletPageState createState() => _ProtectWalletPageState();
}

class _ProtectWalletPageState extends State<ProtectWalletPage> {
  GlobalKey<ScaffoldState> scaffoldState;
  final assetIdController = TextEditingController(text: "");
  List<BiometricType> availableBiometrics;

  getAvailableBiometrics() async {
    var localAuth = LocalAuthentication();
    availableBiometrics = await localAuth.getAvailableBiometrics();
    setState(() {
    });
  }

  @override
  void initState() {
    super.initState();

    getAvailableBiometrics();
    //bool didAuthenticate = await localAuth.authenticateWithBiometrics(localizedReason: 'Please authenticate to open the wallet');
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: scaffoldState,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          backgroundColor: Theme.of(context).canvasColor,
        ),
        backgroundColor: const Color(0xFFF8F8F8),
        body: Container(
            child: Column(children: <Widget>[
          Expanded(
            child: Container(
              //color: Theme.of(context).primaryColor,
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("Protect your wallet",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                  Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Text(
                        "Now it's time to choose an identification method, Your private key and information will be encrypted using this key",
                        //textAlign: TextAlign.center,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.normal)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Image.asset('images/protect-pic.png', width: 170),
                  )
                  
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0, bottom: 50, left: 30, right: 30),
            child: Form(
              child: new StoreConnector<AppState, SignInViewModel>(
                converter: (store) {
                  return SignInViewModel.fromStore(store);
                },
                builder: (_, viewModel) {
                  return Builder(
                      builder: (context) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(height: 16.0),
                              availableBiometrics.length > 0 ? Center(
                                child: PrimaryButton(
                                  label: "USE FACE ID",
                                  onPressed: () async {
                                    //var assetId = await BarcodeScanner.scan();
                                    //viewModel.switchCommunity(context, assetId);
                                    Navigator.of(context).pop(true);
                                    Navigator.of(context).pop(true);
                                  },
                                  width: 300,
                                ),
                              ) : Container(),
                              const SizedBox(height: 22.0),
                              availableBiometrics.length > 0 ?
                              Stack(
                                children: <Widget>[
                                  new SizedBox(
                                    height: 10.0,
                                    child: new Center(
                                      child: new Container(
                                        margin: new EdgeInsetsDirectional.only(
                                            start: 1.0, end: 1.0),
                                        height: 1.0,
                                        color: const Color(0xFF666666),
                                      ),
                                    ),
                                  ),
                                  Center(
                                      child: Container(
                                    padding:
                                        EdgeInsets.only(left: 18, right: 18),
                                    child: Text(
                                      "OR",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    decoration: const BoxDecoration(
                                        color: const Color(0xFFF8F8F8)),
                                  ))
                                ],
                              ) : Container(),
                              const SizedBox(height: 22.0),
                              Center(
                                child: PrimaryButton(
                                  label: "SET UP PINCODE",
                                  onPressed: () async {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: Text("Enter pin code",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              content: Container(
                                                height: 150,
                                                child:
                                                    Column(children: <Widget>[
                                                      PinCodeTextField(
                autofocus: true,
                controller: assetIdController,
                hideCharacter: true,
                highlight: true,
                highlightColor: Colors.blue,
                defaultBorderColor: Colors.black,
                hasTextBorderColor: Colors.green,
                maxLength: 4,
                //hasError: hasError,
                maskCharacter: "*",

                onTextChanged: (text) {
                  setState(() {
                   
                  });
                },
                /*onDone: (text){
                  if (text != viewModel.userState.protectPincode) {
                    setState(() {
                      hasError = true;
                    });
                  }
                },*/
                pinCodeTextFieldLayoutType: PinCodeTextFieldLayoutType.AUTO_ADJUST_WIDTH,
                wrapAlignment: WrapAlignment.start,
                pinBoxDecoration: ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
                pinTextStyle: TextStyle(fontSize: 30.0),
                pinTextAnimatedSwitcherTransition: ProvidedPinBoxTextAnimation.scalingTransition,
                pinTextAnimatedSwitcherDuration: Duration(milliseconds: 300),
              )
                                                  ,
                                                  const SizedBox(height: 22.0),
                                                  Row(
                                                    children: <Widget>[
                                                      Center(
                                                        child: PrimaryButton(
                                                          label: "SAVE",
                                                          onPressed: () {
                                                            viewModel.setProtectMethod("pincode", assetIdController.text);
                                                            Navigator.of(context).pop(true);
                                                            Navigator.of(context).pop(true);
                                                          },
                                                          width: 250,
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ]),
                                              ),
                                            ));
                                  },
                                  width: 300,
                                ),
                              )
                            ],
                          ));
                },
              ),
            ),
          )
        ])));
  }
}
