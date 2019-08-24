import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fusewallet/modals/views/signin_viewmodel.dart';
import 'package:fusewallet/redux/state/app_state.dart';
import 'dart:core';
import 'package:fusewallet/widgets/widgets.dart';
import 'package:country_code_picker/country_code_picker.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  GlobalKey<ScaffoldState> scaffoldState;
  final phoneController = TextEditingController(text: "");
  CountryCode countryCode;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Sign in",
      children: <Widget>[
        Container(
          padding:
              EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0, top: 0.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 0),
                child: Text("Verify that you are a real person",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.body1.color,
                        fontSize: 18,
                        fontWeight: FontWeight.normal)),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: Image.asset('images/signin2.png', width: 220),
              )
            ],
          ),
        ),
        new StoreConnector<AppState, SignInViewModel>(
          converter: (store) {
            return SignInViewModel.fromStore(store);
          },
          builder: (_, viewModel) {
            return Padding(
              padding:
                  EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 30),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      decoration: new BoxDecoration(
                          border: Border.all(
                              color: !viewModel.loginError
                                  ? const Color(0xFF05283e)
                                  : Colors.red,
                              width: 1.0),
                          borderRadius:
                              new BorderRadius.all(Radius.circular(30.0))),
                      child: Row(
                        children: <Widget>[
                          CountryCodePicker(
                            padding:
                                EdgeInsets.only(top: 0, left: 30, right: 0),
                            onChanged: (_countryCode) {
                              countryCode = _countryCode;
                            },
                            initialSelection: 'IL',
                            favorite: [],
                            showCountryOnly: false,
                            textStyle: const TextStyle(fontSize: 18),
                          ),
                          Icon(Icons.arrow_drop_down),
                          new Container(
                            height: 35,
                            width: 1,
                            color: const Color(0xFFc1c1c1),
                            margin:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.number,
                              autofocus: true,
                              style: const TextStyle(fontSize: 18),
                              decoration: const InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 10),
                                  hintText: 'Phone number',
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none)),
                            ),
                          )
                        ],
                      ),
                    ),
                    viewModel.loginError
                        ? Padding(
                            child: Center(
                              child: Text("Please enter a valid phone number",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 14)),
                            ),
                            padding: const EdgeInsets.only(top: 7.0),
                          )
                        : SizedBox(height: 18.0),
                    const SizedBox(height: 16.0),
                    Center(
                      child: PrimaryButton(
                        label: "NEXT",
                        onPressed: () async {
                          viewModel.sendCodeToPhoneNumber(
                              context,
                              "+972" + //countryCode.dialCode +
                                  phoneController.text.trim());
                        },
                        preload: viewModel.isLoading,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
