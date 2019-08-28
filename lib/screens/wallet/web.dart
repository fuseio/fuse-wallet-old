/*
import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

String injectScript = "";

class WebPage extends StatefulWidget {
  WebPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  GlobalKey<ScaffoldState> scaffoldState;
  bool isLoading = false;
  final assetIdController = TextEditingController(text: "");
  bool isValid = true;
  final flutterWebviewPlugin = new FlutterWebviewPlugin();



  Future getInjectString() async {
    String mnemonic = "myth budget song skin carbon general electric swift gadget size right onion"; //await WalletLogic.getMnemonic();
    String userName = "test";

    return ("""
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
  }

  @override
  Future initState() {
    super.initState();

    flutterWebviewPlugin.onStateChanged.listen((viewState) async {
      if (viewState.type == WebViewState.startLoad ) { //WebViewState.finishLoad
         getInjectString().then((str) {
          flutterWebviewPlugin.evalJavascript(str);
          
        });
        //flutterWebviewPlugin.evalJavascript("alert(document.documentElement.innerHTML);");
      }
    });
/*
    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      getInjectString().then((str) {
        flutterWebviewPlugin.evalJavascript(str);
      });
    });
    */

  }

  Widget favoriteButton() {
    return FloatingActionButton(
              onPressed: () async {
//                TO LATE HERE:
                 flutterWebviewPlugin.evalJavascript(injectScript);
              },
              child: const Icon(Icons.refresh),
            );
   
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
      body: new WebviewScaffold(
        url: "https://studio-qa.fusenet.io",
        withJavascript: true,
        hidden: true,
      ),
      floatingActionButton: favoriteButton(),
    );
  }
}
*/