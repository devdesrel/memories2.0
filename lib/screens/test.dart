import 'package:flutter/material.dart';
import 'package:memories/blocs/start_bloc.dart';
import 'package:memories/models/model.dart';
import 'package:memories/routes.dart';
import 'package:memories/screens/add_name.dart';
import 'package:simple_permissions/simple_permissions.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
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

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    var bloc = StartBloc();
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: StreamBuilder<List<Promotion>>(
            stream: bloc.listOfPromotions,
            builder: (context, snapshot) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text('Memories Brand',
                      style: TextStyle(fontSize: 32.0),
                      textAlign: TextAlign.center),
                  Column(
                    children: <Widget>[
                      Text('Are you attending',
                          style: TextStyle(fontSize: 16.0),
                          textAlign: TextAlign.center),
                      Container(
                          height: 100.0,
                          width: double.infinity,
                          child: (snapshot.data != null && snapshot.hasData)
                              ? ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, i) => Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                10.0,
                                        color: Colors.white,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 20.0, horizontal: 25.0),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                              "${snapshot.data[i].name}" ??
                                                  "No event",
                                              style: TextStyle(fontSize: 25.0),
                                              textAlign: TextAlign.center),
                                        ),
                                      ),
                                )
                              : Container(
                                  width:
                                      MediaQuery.of(context).size.width - 10.0,
                                  color: Colors.white,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 25.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("No events",
                                        style: TextStyle(fontSize: 25.0),
                                        textAlign: TextAlign.center),
                                  ),
                                )),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text("Swipe for more events",
                            style: TextStyle(fontSize: 16.0),
                            textAlign: TextAlign.center),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      RaisedButton(
                          shape: StadiumBorder(),
                          // onPressed: () => CameraScreen.startForEvent(context, events[0]),

                          onPressed: () {
                            Navigator.push(
                                context,
                                SlideTransitionPageRouteBuilder((BuildContext
                                            context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation) =>
                                    AddNamePage(
                                      event: snapshot.data[0],
                                    )));
                            // Navigator.of(context).pushNamed(booksPage);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 50.0,
                                right: 50.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: Text("Yep!",
                                style: TextStyle(fontSize: 28.0),
                                textAlign: TextAlign.center),
                          )),
                    ],
                  ),
                  StreamBuilder<bool>(
                      stream: bloc.retryButton,
                      initialData: false,
                      builder: (context, snapshot) {
                        return Column(
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                bloc.isRetryPressed.add(true);
                              },
                              icon: Icon(
                                Icons.autorenew,
                                size: 48.0,
                              ),
                              color: Colors.black,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text("Nope, please check again.",
                                  style: TextStyle(fontSize: 16.0),
                                  textAlign: TextAlign.center),
                            ),
                          ],
                        );
                      }),
                ],
              );
            }));
  }
}
