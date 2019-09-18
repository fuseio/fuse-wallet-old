// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fusewallet/redux/state/app_state.dart';
import 'package:fusewallet/modals/views/web_viewmodel.dart';


const String kNavigationExamplePage = '''
<!DOCTYPE html><html>
<head><title>Navigation Delegate Example</title></head>
<body>
<p>
The navigation delegate is set to block navigation to the youtube website.
</p>
<ul>
<ul><a href="https://www.youtube.com/">https://www.youtube.com/</a></ul>
<ul><a href="https://www.google.com/">https://www.google.com/</a></ul>
<ul><a href="javascript:Toaster.postMessage('confirm');">test</a></ul>
</ul>
</body>
</html>
''';

class WebViewExample extends StatefulWidget {
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

      WebViewController _myController;

  TextEditingController address = new TextEditingController(text: 'https://studio.fusenet.io/');

  @override
  Widget build(BuildContext context) {
      return new StoreConnector<AppState, WebViewModel>(
        converter: (store) {
          return WebViewModel.fromStore(store);
        },
        builder: (_, viewModel) {
          return Scaffold(
            appBar: AppBar(
              //automaticallyImplyLeading: false,
              titleSpacing: 0,
              title: 
                new Container(
                  height: 35,
              decoration: new BoxDecoration(
              borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
              shape: BoxShape.rectangle,
              color: const Color(0xFFfe9e9e9),
            ),
              margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Expanded(
                    child:
                    Stack(
                      children: <Widget>[
                        Padding(
                          child: Image.asset('images/lock.png', width: 16, height: 16,),
                          padding: EdgeInsets.only(top: 1, left: 12),
                        )
                        ,
                        TextField(
              controller: address,
              textAlign: TextAlign.left,
              decoration: new InputDecoration(
                contentPadding: EdgeInsets.only(top: 0, left: 35, right: 10),
                hintText: 'Address',
                border: InputBorder.none,
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none
              ),
              onSubmitted: (url) {
                _myController.loadUrl(url);
              },
            )
                      ],
                    )
                    ,
                  )
                ],
              ),
            )
          

        ,
              // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
              actions: <Widget>[
                NavigationControls(_controller.future),
              ],
              iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                  backgroundColor: Theme.of(context).canvasColor,
            ),
            // We're using a Builder here so we have a context that is below the Scaffold
            // to allow calling Scaffold.of(context) so we can show a snackbar.
            body: Builder(builder: (BuildContext context) {
              return WebView(
                initialUrl: 'https://studio.fusenet.io/?isMobile',
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                  _myController = webViewController;
                },
                // TODO(iskakaushik): Remove this when collection literals makes it to stable.
                // ignore: prefer_collection_literals
                javascriptChannels: <JavascriptChannel>[
                  _toasterJavascriptChannel(context),
                ].toSet(),
                navigationDelegate: (NavigationRequest request) {
                  if (request.url.startsWith('https://www.youtube.com/')) {
                    print('blocking navigation to $request}');
                    return NavigationDecision.prevent;
                  }
                  print('allowing navigation to $request');
                  return NavigationDecision.navigate;
                },
                onPageFinished: (String url) {
                  var injectedCode = """
                    console.log('injecting webview')
                    window.pk = '0x${viewModel.user.privateKey}'
                    console.log('done injecting webview')
                  """;
                  print(injectedCode);
                  _myController.evaluateJavascript(injectedCode);
                  print('Page finished loading: $url');
                },
              );
            }),
          );
        });
      }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          if (message.message == "confirm") {
            _settingModalBottomSheet(context);
          } else {
            Scaffold.of(context).showSnackBar(
              SnackBar(content: Text(message.message)),
            );
          }
          
        });
  }

  void _settingModalBottomSheet(context){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
          return Container(
            child: new Wrap(
            children: <Widget>[
new ListTile(
            leading: new Icon(Icons.check),
            title: new Text('Confirm please'),
            onTap: () => {}          
          ),
            ],
          ),
          );
      }
    );
}

}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture)
      : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;
        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller.canGoBack()) {
                        controller.goBack();
                      } else {
                        Scaffold.of(context).showSnackBar(
                          const SnackBar(content: Text("No back history item")),
                        );
                        return;
                      }
                    },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller.canGoForward()) {
                        controller.goForward();
                      } else {
                        Scaffold.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("No forward history item")),
                        );
                        return;
                      }
                    },
            ),
            /*IconButton(
              icon: const Icon(Icons.replay),
              onPressed: !webViewReady
                  ? null
                  : () {
                      controller.reload();
                    },
            ),*/
          ],
        );
      },
    );
  }
}