import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memories/helpers/ui_helpers.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:memories/models/model.dart';
import 'package:memories/routes.dart';
import 'package:memories/screens/tips_page.dart';

class AddNamePage extends StatelessWidget {
  final Promotion event;
  AddNamePage({this.event});
  @override
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var appBarHeight = 100.0;

    return Scaffold(
        body: Container(
      height: screenHeight,
      width: double.infinity,
      child: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.topStart,
          fit: StackFit.loose,
          children: <Widget>[
            Positioned(top: 5.0, left: 5.0, child: Logo()),
            Positioned(
              top: 5.0,
              right: 5.0,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0),
                child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      size: 35.0,
                      color: Theme.of(context).textTheme.display1.color,
                    )),
              ),
            ),
            Positioned(
              top: appBarHeight,
              left: 0.0,
              child: Container(
                height: 150.0,
                width: screenWidth,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                  ),
                  child: Text(
                    event.name + " Longer event name example",
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.display1.color,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: screenHeight - (appBarHeight + 160),
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Positioned(
                      top: (screenHeight - (appBarHeight + 160)) / 12,
                      right: 10.0,
                      child: Container(
                        height: 60.0,
                        width: 90.0,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: new AssetImage('assets/wedding.png'),
                              fit: BoxFit.cover,
                            )),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: ((screenHeight - (appBarHeight + 160)) / 8)),
                        child: Container(
                          height: 80.0,
                          width: 100.0,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: new AssetImage('assets/moment.png'),
                                fit: BoxFit.cover,
                              )),
                        ),
                      ),
                    ),
                    Positioned(
                      top: (screenHeight - (appBarHeight + 160)) / 4,
                      left: 10.0,
                      child: Container(
                        height: 60.0,
                        width: 90.0,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: new AssetImage('assets/birthday.png'),
                              fit: BoxFit.cover,
                            )),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: (screenHeight - (appBarHeight + 160)) / 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(right: 80.0, left: 80.0),
                              child: Theme(
                                data: ThemeData(
                                    primaryColor: Colors.white,
                                    primaryColorDark: Colors.white),
                                child: TextFormField(
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 15.0, horizontal: 20.0),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      hintText: "Name",
                                      hintStyle:
                                          TextStyle(color: Colors.black38)),
                                ),
                              ),
                            ),
                            RaisedButton(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 55.0,
                                    right: 55.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: Text(
                                  "That's me",
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    SlideTransitionPageRouteBuilder(
                                        (BuildContext context,
                                                Animation<double> animation,
                                                Animation<double>
                                                    secondaryAnimation) =>
                                            TipsPage(
                                              event: event,
                                            )));
                              },
                            ),
                            Text(
                              "This will let them know which pics are yours",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 11.0),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}

class AvatarContainer extends StatelessWidget {
  final String path;
  final size;
  const AvatarContainer({
    @required this.path,
    @required this.size,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: Colors.white),
      height: size,
      width: size,
      child: Image.asset(path),
    );
  }
}

//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding:
//               EdgeInsets.only(top: 50.0, bottom: 20.0, left: 20.0, right: 20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   SvgPicture.asset(
//                     'assets/friendship.svg',
//                     width: 120.0,
//                     height: 120.0,
//                   ),
//                   Text('Memories Brand',
//                       style: TextStyle(
//                           fontSize: 32.0, color: Theme.of(context).accentColor),
//                       textAlign: TextAlign.center),
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 15.0),
//                 child: Column(
//                   children: <Widget>[
//                     Text("What\'s Your Name?"),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: TextFormField(
//                         decoration: InputDecoration(
//                             hintText: 'name', border: OutlineInputBorder()),
//                       ),
//                     ),
//                     Text("(This will let them know which pics are yours)"),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 12.0),
//                 child: Column(
//                   children: <Widget>[
//                     RaisedButton(
//                         shape: StadiumBorder(),
//                         color: Theme.of(context).accentColor,
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               SlideTransitionPageRouteBuilder((BuildContext
//                                           context,
//                                       Animation<double> animation,
//                                       Animation<double> secondaryAnimation) =>
//                                   TipsPage(
//                                     event: event,
//                                   )));
//                           // Navigator.of(context).pushNamed(booksPage);
//                         },
//                         child: Padding(
//                           padding: EdgeInsets.only(
//                               left: 50.0, right: 50.0, top: 10.0, bottom: 10.0),
//                           child: Text("That\'s me!".toUpperCase(),
//                               style: TextStyle(
//                                   fontSize: 28.0,
//                                   color: Theme.of(context).textSelectionColor),
//                               textAlign: TextAlign.center),
//                         )),
//                     // Padding(
//                     //   padding: EdgeInsets.only(top: 10.0),
//                     //   child: Text("(Swipe for more events)".toUpperCase(),
//                     //       style: TextStyle(fontSize: 16.0),
//                     //       textAlign: TextAlign.center),
//                     // ),
//                   ],
//                 ),
//               ),
//               // Column(
//               //   children: <Widget>[
//               //     IconButton(
//               //       onPressed: () => {},
//               //       icon: Icon(
//               //         Icons.autorenew,
//               //         size: 48.0,
//               //       ),
//               //       color: Colors.black,
//               //     ),
//               //     Padding(
//               //       padding: EdgeInsets.only(top: 10.0),
//               //       child: Text("Nope, please check again.",
//               //           style: TextStyle(fontSize: 16.0),
//               //           textAlign: TextAlign.center),
//               //     ),
//               //   ],
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
