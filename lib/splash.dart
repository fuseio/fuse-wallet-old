import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fusewallet/logic/common.dart';
import 'package:fusewallet/screens/signup/recovery.dart';
import 'package:fusewallet/screens/signup/signin.dart';
import 'package:fusewallet/screens/signup/signup.dart';
import 'package:fusewallet/widgets/widgets.dart';
import 'package:redux/redux.dart';
import 'redux/actions/signin_actions.dart';
import 'redux/state/app_state.dart';
//import 'package:flutter_beacon/flutter_beacon.dart';
//import 'package:beacon_broadcast/beacon_broadcast.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final int splashDuration = 2;
  final _controller = new PageController();
  bool isLoading = true;
  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;
  final _kArrowColor = Colors.black.withOpacity(0.8);
  bool isOpen = false;

  var _pages = <Widget>[
    Image.asset('images/paywise.png', width: 160),
  ];
  logon() async {
    //WalletLogic.init();



/*
    WalletLogic.isLogged().then((isLogged) {
      if (isLogged) {
        openPageReplace(context, WalletPage());
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
*/
/*
    getPublickKey().then((_publicKey) {
      BeaconBroadcast beaconBroadcast = BeaconBroadcast();
      beaconBroadcast
          .setUUID('39ED98FF-2900-441A-802F-9C398FC199D2')
          .setMajorId(1)
          .setMinorId(100)
          .start();
    });
*/
/*
    await flutterBeacon.initializeScanning;
    final regions = <Region>[];

    if (Platform.isIOS) {
      regions.add(Region(
          identifier: 'Apple Airlocate',
          proximityUUID: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0'));
    } else {
      // android platform, it can ranging out of beacon that filter all of Proximity UUID
      regions.add(Region(identifier: 'com.beacon'));
    }
*/
/*
    flutterBeacon.ranging(regions).listen((RangingResult result) {
      if (!isOpen &&
          result.beacons.length > 0 &&
          result.beacons.first.proximityUUID ==
              "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0") {
        isOpen = true;
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Send money to eli?"),
                  content: Column(children: <Widget>[
                    TextField(
                        //controller: assetIdController,
                        ),
                    Row(
                      children: <Widget>[
                        FlatButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          color: Theme.of(context).accentColor,
                          padding: EdgeInsets.all(12),
                          child: Text(
                            "Send",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            //isOpen = false;
                          },
                        )
                      ],
                    )
                  ]),
                ));
      }
      //print(result);
      // result contains a region and list of beacons found
      // list can be empty if no matching beacons were found in range
    });
    */
    
  }

  @override
  void initState() {
    super.initState();
    logon();
    //FocusScope.of(context).requestFocus(new FocusNode());
  }

  void gotoPage(page) {
    _controller.animateToPage(
      page,
      duration: _kDuration,
      curve: _kCurve,
    );
  }

  @override
  Widget build(BuildContext context) {
    var drawer = Drawer();

    return Scaffold(
        drawer: drawer,
        body: new StoreBuilder(onInit: (store) {
          Timer.run(() {
            store.dispatch(loadUserState(context));
          });
          
        }, builder: (BuildContext context, Store<AppState> store) {
          return Container(
              child: Column(
            children: <Widget>[
              Expanded(
                flex: 20,
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white
                      // Box decoration takes a gradient
                      // gradient: LinearGradient(
                      //   // Where the linear gradient begins and ends
                      //   begin: Alignment.topLeft,
                      //   end: Alignment.bottomRight,
                      //   // Add one stop for each color. Stops should increase from 0 to 1
                      //   //stops: [0.1, 0.5, 0.7, 0.9],
                      //   colors: [
                      //     // Colors are easy thanks to Flutter's Colors class.
                      //     Theme.of(context).primaryColorLight,
                      //     Theme.of(context).primaryColorDark,
                      //   ],
                      // ),
                    ),
                    //alignment: FractionalOffset(0.5, 0.5),
                    child: !(store.state.userState.isUserLogged ?? true)
                        ? Column(
                            children: <Widget>[
                              Expanded(
                                child: new Stack(
                                  children: <Widget>[
                                    new PageView.builder(
                                      physics:
                                          new AlwaysScrollableScrollPhysics(),
                                      controller: _controller,
                                      itemCount: _pages.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return _pages[index % _pages.length];
                                      },
                                    ),
                                    new Positioned(
                                      bottom: 0.0,
                                      left: 0.0,
                                      right: 0.0,
                                      child: new Container(
                                        //color: Colors.grey[800].withOpacity(0.5),
                                        padding: const EdgeInsets.all(20.0),
                                        child: new Center(
                                          child: new DotsIndicator(
                                            controller: _controller,
                                            itemCount: _pages.length,
                                            onPageSelected: (int page) {
                                              gotoPage(page);
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 180,
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: 20),
                                      child: FlatButton(
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    30.0)),
                                        color: Theme.of(context).primaryColor,
                                        padding: EdgeInsets.only(
                                            top: 20,
                                            bottom: 20,
                                            left: 70,
                                            right: 70),
                                        child: Text(
                                          "Create a new wallet",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        onPressed: () {
                                          openPage(context, new SignUpPage());
                                        },
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(top: 30),
                                        child: TransparentButton(
                                            label: "Restore existing wallet",
                                            onPressed: () {
                                              openPage(
                                                  context, new RecoveryPage());
                                            }))
                                  ],
                                ),
                              )
                            ],
                          )
                        : Preloader()),
              ),
            ],
          ));
        }));
  }
}

class DotsIndicator extends AnimatedWidget {
  DotsIndicator({
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.color: Colors.white,
  }) : super(listenable: controller);

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  /// The color of the dots.
  ///
  /// Defaults to `Colors.white`.
  final Color color;

  // The base size of the dots
  static const double _kDotSize = 8.0;

  // The increase in the size of the selected dot
  static const double _kMaxZoom = 2.0;

  // The distance between the center of each dot
  static const double _kDotSpacing = 25.0;

  Widget _buildDot(int index) {
    //double selectedness = Curves.easeOut.transform(
    //  max(
    //    0.0,
    //    1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
    //  ),
    //);
    //double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;
    return new Container(
      width: _kDotSpacing,
      child: new Center(
        child: new Container(
          width: 9.0,
          height: 9.0,
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(100.0),
            color: index == controller.page?.round()
                ? const Color(0xFF05283e)
                : new Color.fromRGBO(5, 40, 62, 0.3),
          ),
          child: new InkWell(
            onTap: () => onPageSelected(index),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: new List<Widget>.generate(itemCount, _buildDot),
    );
  }
}
