// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

  TextEditingController address = new TextEditingController(text: 'https://studio-qa.fusenet.io/');

  @override
  Widget build(BuildContext context) {
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
          initialUrl: 'https://studio-qa.fusenet.io/',
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

            String mnemonic = "myth budget song skin carbon general electric swift gadget size right onion"; //await WalletLogic.getMnemonic();
    String userName = "test";


            _myController.evaluateJavascript("""
  var script1 = document.createElement('script');
  script1.type='module';
  script1.src = 'https://cdn.jsdelivr.net/gh/ethereum/web3.js@1.0.0-beta.34/dist/web3.min.js';
  console.log('script1 created');
  script1.onload = function() {
    console.log('script1 loaded'); 
    var script2 = document.createElement('script');
    script2.type='module';
    script2.src = 'https://cdn.jsdelivr.net/gh/ColuLocalNetwork/hdwallet-provider@ab902221eb31c78d08aa1a7021aae1b539d71d7b/dist/hdwalletprovider.client.js';
    console.log('script2 created');
    script2.onload = function() {
      console.log('script2 loaded');
      const mnemonic = '""" +
        mnemonic +
        """';
      let provider = new HDWalletProvider(mnemonic, 'https://rpc.fuse.io');
      provider.networkVersion = '121';
      window.ethereum = provider;
      window.web3 = new window.Web3(provider);
      window.web3.givenProvider = provider;
      window.web3.eth.defaultAccount = provider.addresses[0];
      window.chrome = {webstore: {}};
      console.log('provider.addresses ' + provider.addresses[0]);

      window.ethereum.enable = () =>
            new Promise((resolve, reject) => {
              provider.sendAsync({ method: 'eth_accounts', params: [] }, (error, response) => {
                if (error) {
                  reject(error)
                  } else {
                    resolve(response.result)
                    }
                    })
                    })

      var script3 = document.createElement('script');
      script3.type='module';
      script3.src = 'https://unpkg.com/3box/dist/3box.js';
      console.log('script3 created');
      script3.onload = function() {
        console.log('script3 loaded');
        Box.openBox(provider.addresses[0], provider).then(box => {
          box.onSyncDone(function() {
            console.log('box synced');
            box.public.get('name').then(nickname => {
              console.log('before: ' + nickname);
              console.log('replacing the random num');
              box.public.set('name', '""" +
        userName +
        """').then(() => {
                box.public.get('name').then(nickname => {
                  console.log('after: ' + nickname);
                });
              });
            });
          });
        });
      };
      document.head.appendChild(script3);
    };
    document.head.appendChild(script2);
  };
document.head.appendChild(script1);
""");
            print('Page finished loading: $url');
          },
        );
      }),
    );
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