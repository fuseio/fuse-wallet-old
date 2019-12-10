import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fusewallet/modals/views/signin_viewmodel.dart';
import 'package:fusewallet/redux/state/app_state.dart';
import 'package:fusewallet/screens/signup/backup1.dart';
import 'package:fusewallet/screens/wallet/wallet.dart';
import 'dart:core';
import 'package:fusewallet/widgets/widgets.dart';
import 'package:fusewallet/logic/common.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  GlobalKey<ScaffoldState> scaffoldState;
  bool isLoading = false;
  final firstNameController = TextEditingController(text: "");
  final lastNameController = TextEditingController(text: "");
  final emailController = TextEditingController(text: "");
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(title: "Sign up", children: <Widget>[
      Container(
        //color: Theme.of(context).primaryColor,
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 20.0, bottom: 20.0, top: 0.0),
              child: Text(
                  "This wallet can store private information you can choose to share with service providers.",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.normal)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Image.asset('images/signin.png', width: 300),
            )
          ],
        ),
      ),
      new StoreConnector<AppState, SignInViewModel>(converter: (store) {
        return SignInViewModel.fromStore(store);
      }, builder: (_, viewModel) {
        return Padding(
          padding: EdgeInsets.only(top: 10, left: 30, right: 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: firstNameController,
                  autofocus: false,
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(
                    labelText: 'Full name',
                  ),
                  validator: (String value) {
                    if (value.trim().isEmpty) {
                      return 'Full name is required';
                    }
                  },
                ),
                /*
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: lastNameController,
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(
                    labelText: 'Last name',
                  ),
                  validator: (String value) {
                    if (value.trim().isEmpty) {
                      return 'Last name is required';
                    }
                  },
                ),
                */
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: emailController,
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (String value) {
                    if (value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    if (!isValidEmail(value.trim())) {
                      return 'Please enter valid email';
                    }
                  },
                ),
                const SizedBox(height: 16.0),
                Container(
                  decoration: new BoxDecoration(
                      border: Border.all(
                          color: !viewModel.loginError
                              ? Colors.black.withOpacity(0.1)
                              : Colors.red,
                          width: 1.0),
                      borderRadius:
                          new BorderRadius.all(Radius.circular(30.0))),
                  child: Row(
                    children: <Widget>[
                      CountryCodePicker(
                        padding: EdgeInsets.only(top: 0, left: 30, right: 0),
                        onChanged: (_countryCode) {
                          //countryCode = _countryCode;
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
                        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      Expanded(
                        child: TextFormField(
                          //controller: phoneController,
                          keyboardType: TextInputType.number,
                          autofocus: false,
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
                const SizedBox(height: 16.0),
                Center(
                  child: FlatButton(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.all(new Radius.circular(30.0))
                    ),
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.only(
                                            top: 15,
                                            bottom: 15,
                                            left: 50,
                                            right: 50),
                    child: Text(
                      "Next",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        viewModel.signUp(
                            context,
                            firstNameController.text.trim(),
                            lastNameController.text.trim(),
                            emailController.text.trim());
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                Center(
                  child: TransparentButton(
                      label: "Skip",
                      onPressed: () {
                        viewModel.signUp(
                            context,
                            "",
                            "",
                            "");
                      }),
                ),
                const SizedBox(height: 16.0),
                Center(
                  child: Padding(
                    child: Text(
                      "This data will be enrypted and stored only on this device secured storage.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 14,
                      fontWeight: FontWeight.normal),),
                    padding: const EdgeInsets.only(bottom: 30.0),
                  ) ,
                )
              ],
            ),
          ),
        );
      })
    ]);
  }
}
