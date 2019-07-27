import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memories/blocs/start_bloc.dart';
import 'package:memories/helpers/loader_animation.dart';
import 'package:memories/helpers/ui_helpers.dart';
import 'package:memories/models/model.dart';
import 'package:memories/routes.dart';
import 'package:memories/screens/secret_event_key_page.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'add_name.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

@override
initState() {
  //TODO: check if location deactivated, geolocator plugin
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

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    var bloc = StartBloc();
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var appBarHeigh = 100.0;

    var joinNowText = RichText(
        text: TextSpan(
      style: TextStyle(
        fontSize: 36.0,
        color: Colors.black38,
      ),
      children: <TextSpan>[
        TextSpan(
            text: 'events you \ncan '.toUpperCase(),
            style: Theme.of(context).textTheme.headline),
        TextSpan(
            text: 'join now'.toUpperCase(),
            style: TextStyle(
                // color: Colors.purple[600],  //for pink back
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ],
    ));

    return Scaffold(
        body: Container(
      height: screenHeight,
      width: double.infinity,
      child: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.topStart,
          fit: StackFit.loose,
          children: <Widget>[
            Positioned(
              top: 5.0,
              left: 5.0,
              child: Logo(),
            ),
            Positioned(
              top: 5.0,
              right: 5.0,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 16.0, top: 20.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        SlideTransitionPageRouteBuilder((BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation) =>
                            SecretEventKeyPage()));
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        CupertinoIcons.padlock,
                        size: 30.0,
                        color: Colors.white70,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        "Private events",
                        style: TextStyle(fontSize: 14.0, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: appBarHeigh,
              left: 0.0,
              child: Container(
                height: 120.0,
                // color: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: joinNowText,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  height: screenHeight -
                      (2 * appBarHeigh +
                          15.0), //extra 10.0 to make sure it will fit in
                  width: double.infinity,
                  color: Colors.transparent,
                  child: StreamBuilder<List<Promotion>>(
                      stream: bloc.listOfPromotions,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data.length > 0) {
                            List<Widget> slides = [];
                            var eventList = snapshot.data.toList();

                            for (var n in eventList) {
                              var eventCard = CustomEventCard(data: n);
                              slides.add(eventCard);
                            }
                            return CarouselSlider(
                              height: screenHeight - (2 * appBarHeigh + 10.0),
                              autoPlay: false,
                              enlargeCenterPage: true,
                              items: slides,
                            );
                          } else {
                            return Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                NoEventWidget(),
                                SizedBox(
                                  height: 20.0,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    bloc.isRetryPressed.add(true);
                                  },
                                  child: Icon(
                                    Icons.autorenew,
                                    size: 50.0,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ));
                          }
                        } else {
                          return StreamBuilder(
                              stream: bloc.progressIndicatorStatus,
                              initialData: false,
                              builder: (context, shot) => shot.data
                                  ? Center(child: Loader())
                                  : Center(child: NoEventWidget()));
                        }
                      })),
            ),
          ],
        ),
      ),
    ));
  }
}

class NoEventWidget extends StatelessWidget {
  const NoEventWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle = TextStyle(fontSize: 20.0, color: Colors.white);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          ": (",
          style: _textStyle,
        ),
        Text(
          "No events were found",
          style: _textStyle,
        )
      ],
    );
  }
}

class CustomEventCard extends StatelessWidget {
  CustomEventCard({@required this.data});
  final Promotion data;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var containerHeight = screenHeight -
        (250.0 +
            20.0); //hardcoded value, checkappBarHeigh and joinNowText height
    var containerWidth = screenWidth - 40.0;
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        height: containerHeight,
        width: containerWidth,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Text(
                  data.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Align(
              //TODO: add map_view for an event
              alignment: Alignment.center,
              child: Container(
                height: containerHeight -
                    2 * 75, //hardcoded value, refer to Join now button size
                width: containerWidth - 100.0,
                color: Colors.yellow,
                child: Center(
                  child: Text("There will be map view"),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: RaisedButton(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 60.0, right: 60.0, top: 10.0, bottom: 10.0),
                    child: Text(
                      "Join now",
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        SlideTransitionPageRouteBuilder((BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation) =>
                            AddNamePage(
                              event: data,
                            )));
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
