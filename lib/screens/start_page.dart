import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memories/blocs/start_bloc.dart';
import 'package:memories/helpers/loader_animation.dart';
import 'package:memories/models/model.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:flutter_svg/svg.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

@override
initState() {
  checkForPermissions().then((isOk) {
    if (!isOk) getPermission();
  });
}

Future<bool> checkForPermissions() async {
  bool isAllowed =
      await SimplePermissions.checkPermission(Permission.AccessFineLocation);
  return isAllowed;
}

Future<bool> getPermission() async {
  bool result;
  await SimplePermissions.requestPermission(Permission.AccessFineLocation)
      .then((isOk) {
    if (isOk == PermissionStatus.authorized)
      result = true;
    else
      result = false;
  });
  return result;
}

// initPlatformState() async {
//   String platformVersion;
//   // Platform messages may fail, so we use a try/catch PlatformException.
//   try {
//     platformVersion = await SimplePermissions.platformVersion;
//   } on PlatformException {
//     platformVersion = 'Failed to get platform version.';
//   }

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    var bloc = StartBloc();
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      height: screenHeight,
      width: double.infinity,
      child: StreamBuilder<List<Promotion>>(
          stream: bloc.listOfPromotions,
          builder: (context, snapshot) {
            return StreamBuilder(
                stream: bloc.isGettingEventsFinished,
                builder: (context, shot) => shot.data
                    ? SafeArea(
                        child:
                            // child: Column(
                            //   children: <Widget>[
                            Stack(children: <Widget>[
                          Positioned(
                            top: 5.0,
                            left: 5.0,
                            child: SvgPicture.asset(
                              "assets/logo.svg",
                              width: 120.0,
                              height: 120.0,
                            ),
                          ),
                          Positioned(
                            right: 5.0,
                            top: 5.0,
                            child: Row(children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  CupertinoIcons.padlock,
                                  size: 30.0,
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8.0, right: 8.0),
                                  child: Text(
                                    "Private events",
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ),
                            ]),
                          ),

                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //   children: <Widget>[
                          //     // Text('Memories Brand',
                          //     //     style: TextStyle(
                          //     //         fontSize: 32.0,
                          //     //         color: Theme.of(context).accentColor),
                          //     //     textAlign: TextAlign.center),
                          //     Column(
                          //         mainAxisAlignment:
                          //             MainAxisAlignment.spaceBetween,
                          //         children: <Widget>[
                          //           Text('Are you attending',
                          //               style: TextStyle(fontSize: 16.0),
                          //               textAlign: TextAlign.center),
                          //           Container(
                          //               height: 100.0,
                          //               width: double.infinity,
                          //               child: ListView.builder(
                          //                 scrollDirection: Axis.horizontal,
                          //                 itemCount: snapshot.data.length,
                          //                 itemBuilder: (context, i) => Container(
                          //                       width: MediaQuery.of(context)
                          //                               .size
                          //                               .width -
                          //                           10.0,
                          //                       margin: EdgeInsets.symmetric(
                          //                           vertical: 20.0,
                          //                           horizontal: 25.0),
                          //                       child: Padding(
                          //                         padding:
                          //                             const EdgeInsets.all(10.0),
                          //                         child: Text(
                          //                             "${snapshot.data[i].name}" ??
                          //                                 "No event",
                          //                             style: TextStyle(
                          //                                 fontSize: 25.0,
                          //                                 color: Theme.of(context)
                          //                                     .primaryColor),
                          //                             textAlign:
                          //                                 TextAlign.center),
                          //                       ),
                          //                     ),
                          //               )
                          //               // : Container(
                          //               //     width:
                          //               //         MediaQuery.of(context).size.width - 10.0,
                          //               //     color: Colors.white,
                          //               //     margin: EdgeInsets.symmetric(
                          //               //         vertical: 20.0, horizontal: 25.0),
                          //               //     child: Padding(
                          //               //       padding: const EdgeInsets.all(10.0),
                          //               //       child: Text("No events",
                          //               //           style: TextStyle(fontSize: 25.0),
                          //               //           textAlign: TextAlign.center),
                          //               //     ),
                          //               //   )
                          //               ),
                          //           Padding(
                          //             padding: EdgeInsets.only(top: 10.0),
                          //             child: Text("Swipe for more events",
                          //                 style: TextStyle(fontSize: 16.0),
                          //                 textAlign: TextAlign.center),
                          //           ),
                          //           Column(
                          //             children: <Widget>[],
                          //           ),
                          //         ]),
                          //     StreamBuilder<bool>(
                          //         stream: bloc.retryButton,
                          //         initialData: false,
                          //         builder: (context, snapshot) {
                          //           return Column(
                          //             children: <Widget>[
                          //               IconButton(
                          //                 onPressed: () {
                          //                   bloc.isRetryPressed.add(true);
                          //                 },
                          //                 icon: Icon(
                          //                   Icons.autorenew,
                          //                   size: 48.0,
                          //                 ),
                          //                 color: Theme.of(context).primaryColor,
                          //               ),
                          //               Padding(
                          //                 padding: EdgeInsets.only(top: 10.0),
                          //                 child: Text("Nope, please check again.",
                          //                     style: TextStyle(fontSize: 16.0),
                          //                     textAlign: TextAlign.center),
                          //               ),
                          //             ],
                          //           );
                          //         }),
                          //   ],
                          // ),
                        ]),
                        // RaisedButton(
                        //   child: Padding(
                        //     padding: EdgeInsets.only(
                        //         left: 50.0,
                        //         right: 50.0,
                        //         top: 10.0,
                        //         bottom: 10.0),
                        //     child: Text(
                        //       "Join now",
                        //     ),
                        //   ),
                        //   onPressed: () {
                        //     Navigator.push(
                        //         context,
                        //         SlideTransitionPageRouteBuilder(
                        //             (BuildContext context,
                        //                     Animation<double> animation,
                        //                     Animation<double>
                        //                         secondaryAnimation) =>
                        //                 AddNamePage(
                        //                   event: snapshot.data[0],
                        //                 )));
                        //   },
                        // ),
                        //   ],
                        // ),
                      )
                    : Center(child: Loader()));
          }),
    ));
  }
}
