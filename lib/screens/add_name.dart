import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memories/models/model.dart';
import 'package:memories/routes.dart';
import 'package:memories/screens/tips_page.dart';

class AddNamePage extends StatelessWidget {
  final Promotion event;
  AddNamePage({this.event});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(top: 50.0, bottom: 20.0, left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(
                    'assets/friendship.svg',
                    width: 120.0,
                    height: 120.0,
                  ),
                  Text('Memories Brand',
                      style: TextStyle(fontSize: 32.0),
                      textAlign: TextAlign.center),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Column(
                  children: <Widget>[
                    Text("What\'s Your Name?"),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: 'name', border: OutlineInputBorder()),
                      ),
                    ),
                    Text("(This will let them know which pics are yours)"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  children: <Widget>[
                    RaisedButton(
                        shape: StadiumBorder(),
                        onPressed: () {
                          Navigator.push(
                              context,
                              SlideTransitionPageRouteBuilder((BuildContext
                                          context,
                                      Animation<double> animation,
                                      Animation<double> secondaryAnimation) =>
                                  TipsPage(
                                    event: event,
                                  )));
                          // Navigator.of(context).pushNamed(booksPage);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 50.0, right: 50.0, top: 10.0, bottom: 10.0),
                          child: Text("That\'s me!".toUpperCase(),
                              style: TextStyle(fontSize: 28.0),
                              textAlign: TextAlign.center),
                        )),
                    // Padding(
                    //   padding: EdgeInsets.only(top: 10.0),
                    //   child: Text("(Swipe for more events)".toUpperCase(),
                    //       style: TextStyle(fontSize: 16.0),
                    //       textAlign: TextAlign.center),
                    // ),
                  ],
                ),
              ),
              // Column(
              //   children: <Widget>[
              //     IconButton(
              //       onPressed: () => {},
              //       icon: Icon(
              //         Icons.autorenew,
              //         size: 48.0,
              //       ),
              //       color: Colors.black,
              //     ),
              //     Padding(
              //       padding: EdgeInsets.only(top: 10.0),
              //       child: Text("Nope, please check again.",
              //           style: TextStyle(fontSize: 16.0),
              //           textAlign: TextAlign.center),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
