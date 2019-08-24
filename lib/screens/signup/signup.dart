import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fusewallet/modals/views/signin_viewmodel.dart';
import 'package:fusewallet/redux/state/app_state.dart';
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
                  "Enter your information, this will only be shared with your consent",
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
                  autofocus: true,
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(
                    labelText: 'First name',
                  ),
                  validator: (String value) {
                    if (value.trim().isEmpty) {
                      return 'First name is required';
                    }
                  },
                ),
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
                Center(
                  child: PrimaryButton(
                    label: "NEXT",
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
              ],
            ),
          ),
        );
      })
    ]);
  }
}
