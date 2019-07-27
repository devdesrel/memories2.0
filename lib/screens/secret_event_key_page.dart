import 'package:flutter/material.dart';
import 'package:memories/helpers/ui_helpers.dart';

class SecretEventKeyPage extends StatelessWidget {
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
            Positioned(
                top: 5.0,
                left: 5.0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Logo(),
                )),
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
                    "Enter the secret \ncode to access \nthe private \nevent.",
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
                                      hintText: "Secret key",
                                      hintStyle:
                                          TextStyle(color: Colors.black38)),
                                ),
                              ),
                            ),
                            RaisedButton(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 60.0,
                                    right: 60.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: Text(
                                  "Let's go",
                                ),
                              ),
                              onPressed: () {
                                //TODO: Find event and nagivate to addName page
                              },
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
