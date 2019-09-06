import 'package:flutter/material.dart';
import 'package:fusewallet/logic/common.dart';
import 'package:fusewallet/modals/views/signin_viewmodel.dart';
import 'package:fusewallet/screens/wallet/sendAddress.dart';
import 'dart:core';
import 'package:fusewallet/widgets/widgets.dart';
import 'package:fusewallet/modals/views/wallet_viewmodel.dart';
import 'package:fusewallet/redux/state/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:virtual_keyboard/virtual_keyboard.dart';
import 'package:fusewallet/logic/globals.dart' as globals;
import 'package:pin_code_text_field/pin_code_text_field.dart';

class PincodePage extends StatefulWidget {
  PincodePage({Key key}) : super(key: key);

  @override
  _PincodePageState createState() => _PincodePageState();
}

class _PincodePageState extends State<PincodePage> {
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
          body: SendAmountForm());
  }
}

class SendAmountForm extends StatefulWidget {
  SendAmountForm({Key key, this.address}) : super(key: key);

  final String address;

  @override
  _SendAmountFormState createState() => _SendAmountFormState();
}

class _SendAmountFormState extends State<SendAmountForm> {
  TextEditingController controller = TextEditingController();
  bool hasError = false;
  String errorMessage;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, SignInViewModel>(converter: (store) {
      return SignInViewModel.fromStore(store);
    }, builder: (_, viewModel) {

      _onKeyPress(VirtualKeyboardKey key) {
        if (key.keyType == VirtualKeyboardKeyType.String) {
          if (controller.text.length == 4) {
            return;
          }
          controller.text = controller.text + key.text;
        } else if (key.keyType == VirtualKeyboardKeyType.Action) {
          switch (key.action) {
            case VirtualKeyboardKeyAction.Backspace:
              if (controller.text.length == 0) return;
              controller.text = controller.text.substring(0, controller.text.length - 1);
              break;
            case VirtualKeyboardKeyAction.Return:
              controller.text = controller.text + '\n';
              break;
            case VirtualKeyboardKeyAction.Space:
              controller.text = controller.text + key.text;
              break;
            default:
          }
        }
        setState(() {});
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
                    Text("Enter pin code",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 30,
                            fontWeight: FontWeight.w900))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(0.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: PinCodeTextField(
                autofocus: false,
                controller: controller,
                hideCharacter: true,
                highlight: true,
                highlightColor: Colors.blue,
                defaultBorderColor: Colors.black,
                hasTextBorderColor: Colors.green,
                maxLength: 4,
                hasError: hasError,
                maskCharacter: "*",

                onTextChanged: (text) {
                  setState(() {
                    hasError = false;
                    if (text.length == 4) {
                      if (text == viewModel.userState.protectPincode) {
                        viewModel.protectUnlock(context);
                      } else {
                        hasError = true;
                      }
                    }
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
              ),
                    )
                  ],
                ),
              )
            ],
          ),
        )),
        VirtualKeyboard(
            height: 300,
            fontSize: 28,
            textColor: Theme.of(context).primaryColor,
            type: VirtualKeyboardType.Numeric,
            onKeyPress: _onKeyPress),
        const SizedBox(height: 30.0),
        /*
        Center(
            child: PrimaryButton(
          label: "NEXT",
          onPressed: () {
            if (viewModel.walletState.sendAmount <= 0) {
              Scaffold.of(context).showSnackBar(new SnackBar(
                content: new Text("Please enter amount"),
              ));
            } else {
              viewModel.sendAmount(double.parse(amountText));
              openPage(context, new SendAddressPage());
            }
          },
          preload: false,
          width: 300,
        )),
        const SizedBox(height: 40.0),
        */
      ]));
    });
  }
}
