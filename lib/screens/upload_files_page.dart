import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memories/blocs/upload_file_bloc.dart';
import 'package:memories/blocs/upload_file_provider.dart';
import 'package:memories/constants.dart';
import 'package:memories/models/model.dart';
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class UploadFilesPage extends StatelessWidget {
  final Promotion event;

  UploadFilesPage({this.event});
//   @override
//   Widget build(BuildContext context) {
//     return Container(

//     );
//   }
// }

// class UploadFilesPage extends StatefulWidget {
//   final CameraBloc bloc;
//   final Event event;

//   UploadFilesPage({@required this.event, this.bloc});

//   @override
//   UploadFilesPageState createState() {
//     return new UploadFilesPageState();
//   }
// }

// class UploadFilesPageState extends State<UploadFilesPage>
//     with AutomaticKeepAliveClientMixin {
//   @override
//   bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    var bloc = FileUploadBloc();
    var pages = [
      HomePage(
        bloc: bloc,
        accessType: UploadPageNavigation.All,
      ),
      UploadPage(bloc: bloc),
      HomePage(
        bloc: bloc,
        accessType: UploadPageNavigation.Photos,
      ),
      HomePage(
        bloc: bloc,
        accessType: UploadPageNavigation.Videos,
      ),
    ];
    return FileUploadProvider(
      fileUploadBloc: bloc,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey[300],
            title: Text(
              // widget.event.name,
              event.name ?? "No event",
              style: TextStyle(color: Colors.black),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.chevron_left,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: <Widget>[
              StreamBuilder(
                initialData: true,
                // stream: widget.bloc.isGridView,
                stream: bloc.isGridView,
                builder: (context, snapshot) => snapshot.hasData
                    ? snapshot.data
                        ? IconButton(
                            icon: Icon(
                              Icons.border_horizontal,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              // widget.bloc.setGridView.add(false);
                              bloc.setGridView.add(false);
                            },
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.grid_on,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              // widget.bloc.setGridView.add(true);
                              bloc.setGridView.add(true);
                            },
                          )
                    : IconButton(
                        icon: Icon(
                          Icons.grid_on,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          // widget.bloc.setGridView.add(true);
                          bloc.setGridView.add(true);
                        },
                      ),
              ),
              IconButton(
                icon: Icon(
                  Icons.check,
                  color: Colors.black,
                ),
                onPressed: () {
                  bloc.mainUploadFunction();
                  // showDialog(
                  //     context: context,
                  //     builder: (context) => SimpleDialog(
                  //           title: Text("Success"),
                  //           children: <Widget>[
                  //             Center(
                  //                 child: Padding(
                  //               padding: const EdgeInsets.all(8.0),
                  //               child: Text(
                  //                   "Selected files are successfully uploaded"),
                  //             ))
                  //           ],
                  //         ));
                },
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: (int index) {
              bloc.getBottomVanigationValue.add(index);
            },
            items: [
              BottomNavigationBarItem(
                  title: Container(
                    height: 0.0,
                  ),
                  // Text(
                  //   // "Home".toUpperCase(),
                  //   "",
                  //   style: TextStyle(color: Colors.black),
                  // ),
                  icon: Icon(Icons.home, color: Colors.black, size: 35.0)),
              BottomNavigationBarItem(
                  title: Text(
                      // "Upload".toUpperCase(),
                      "",
                      style: TextStyle(color: Colors.black)),
                  icon: Icon(Icons.cloud_upload,
                      color: Colors.black, size: 35.0)),
              BottomNavigationBarItem(
                  title: Text(
                      // "Photos".toUpperCase(),
                      "",
                      style: TextStyle(color: Colors.black)),
                  icon:
                      Icon(Icons.camera_alt, color: Colors.black, size: 35.0)),
              BottomNavigationBarItem(
                  title: Text(
                      // "Videos".toUpperCase(),
                      "",
                      style: TextStyle(color: Colors.black)),
                  icon: Icon(Icons.videocam, color: Colors.black, size: 35.0)),
              BottomNavigationBarItem(
                  title: Text(
                      // "Settings".toUpperCase(),
                      "",
                      style: TextStyle(color: Colors.black)),
                  icon: Icon(Icons.settings, color: Colors.black, size: 35.0)),
            ],
          ),
          // body: HomePage(bloc: bloc)),
          body: StreamBuilder<int>(
              stream: bloc.bottomNavigationSelectedValue,
              initialData: 0,
              builder: (context, snapshot) {
                return pages[snapshot.data];
              })),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key key, @required this.bloc, @required this.accessType})
      : super(key: key);

  final FileUploadBloc bloc;
  final UploadPageNavigation accessType;

  Stream<List<String>> getType() {
    var type;
    switch (accessType) {
      case UploadPageNavigation.All:
        type = bloc.allFilesList;
        break;
      case UploadPageNavigation.Photos:
        type = bloc.photosList;
        break;
      case UploadPageNavigation.Videos:
        type = bloc.videosList;
        break;
      default:
    }
    return type;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      // future: getPhotosList("/Pictures/flutter_test"),
      // stream: widget.bloc.photosList,
      stream: getType(),
      // initialData: [],
      builder: (context, snapshot) => snapshot.hasData
          ? snapshot.data.length > 0
              ? StreamBuilder(
                  // stream: widget.bloc.isGridView,
                  stream: bloc.isGridView,
                  builder: (context, shot) => shot.hasData
                      ? shot.data
                          ? GridView.builder(
                              // reverse: true,
                              addAutomaticKeepAlives: true,
                              itemCount: snapshot.data.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 1,
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 3.0,
                                      mainAxisSpacing: 3.0),
                              itemBuilder: (context, i) => InkWell(
                                    onTap: () {
                                      bloc.removePhotoIndexFromSelected.add(i);
                                      // bloc.addPhotoIndexToSelected.add(i);
                                    },
                                    onLongPress: () {
                                      bloc.addPhotoIndexToSelected.add(i);
                                    },
                                    child: StreamBuilder(
                                      stream: bloc.selectedPhotosList,
                                      initialData: [],
                                      builder: (context, data) => Opacity(
                                            opacity: data.hasData
                                                ? data.data.contains(i)
                                                    ? 0.4
                                                    : 1.0
                                                : 1.0,
                                            child: Stack(
                                              //TODO: play icon for video
                                              fit: StackFit.expand,
                                              alignment: Alignment.topLeft,
                                              children: <Widget>[
                                                CustomListItem(
                                                  data: snapshot.data[i],
                                                ),
                                                data.data.contains(i)
                                                    ? Container()
                                                    : Positioned(
                                                        bottom: 3.0,
                                                        left: 3.0,
                                                        child: IconButton(
                                                          icon: Icon(
                                                              Icons.delete),
                                                          iconSize: 28.0,
                                                          color: Colors.white,
                                                          onPressed: () {
                                                            bloc.removePhotoFromList
                                                                .add(snapshot
                                                                    .data[i]);
                                                            deleteFile(snapshot
                                                                .data[i]);
                                                          },
                                                        )),
                                                Positioned(
                                                    bottom: 3.0,
                                                    right: 3.0,
                                                    child: data.data.contains(i)
                                                        ?
                                                        // Icon(
                                                        // color: Colors.white,
                                                        // size: 28.0,
                                                        IconButton(
                                                            onPressed: () {
                                                              bloc.removePhotoIndexFromSelected
                                                                  .add(i);
                                                            },
                                                            icon: Icon(
                                                              Icons
                                                                  .check_circle,
                                                              color:
                                                                  Colors.white,
                                                              size: 28.0,
                                                            ))
                                                        : IconButton(
                                                            onPressed: () {
                                                              bloc.addPhotoIndexToSelected
                                                                  .add(i);
                                                            },
                                                            icon: Icon(
                                                              Icons
                                                                  .radio_button_unchecked,
                                                              color:
                                                                  Colors.white,
                                                              size: 28.0,
                                                            ))

                                                    // onPressed: () {
                                                    //   bloc.addPhotoIndexToSelected
                                                    //       .add(i);
                                                    // },

                                                    ),
                                                getFileType(snapshot.data[i])
                                                    ? Positioned(
                                                        child: Icon(
                                                          Icons.play_arrow,
                                                          size: 35.0,
                                                          color: Colors.white,
                                                        ),
                                                        top: 3.0,
                                                        left: 3.0,
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                          ),
                                    ),
                                  ))
                          : ListView.builder(
                              // reverse: true,
                              addAutomaticKeepAlives: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) => Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          bloc.removePhotoIndexFromSelected
                                              .add(index);
                                        },
                                        child: Container(
                                          color: Colors.grey[200],
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              1.3,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: CustomListItem(
                                              data: snapshot.data[index]),
                                          // Image.file(
                                          //     File(snapshot.data[index])),
                                        ),
                                      ),
                                      Positioned(
                                          bottom: 25.0,
                                          left: 25.0,
                                          child: IconButton(
                                            icon: Icon(Icons.delete),
                                            iconSize: 30.0,
                                            color: Colors.white,
                                            onPressed: () {
                                              bloc.removePhotoFromList
                                                  .add(snapshot.data[index]);
                                              deleteFile(snapshot.data[index]);
                                            },
                                          )),
                                      StreamBuilder(
                                        stream: bloc.selectedPhotosList,
                                        initialData: [],
                                        builder: (context, snapData) =>
                                            Positioned(
                                                bottom: 25.0,
                                                right: 25.0,
                                                child: IconButton(
                                                  color: Colors.white,
                                                  iconSize: 30.0,
                                                  icon: Icon(
                                                    snapData.hasData
                                                        ? snapData.data
                                                                .contains(index)
                                                            ? Icons.check_circle
                                                            : Icons
                                                                .radio_button_unchecked
                                                        : Icons
                                                            .radio_button_unchecked,
                                                  ),
                                                  // Icon(
                                                  //     Icons.check_circle_outline),
                                                  onPressed: () {
                                                    bloc.addPhotoIndexToSelected
                                                        .add(index);
                                                  },
                                                )),
                                      ),
                                      getFileType(snapshot.data[index])
                                          ? Positioned(
                                              child: Icon(
                                                Icons.play_arrow,
                                                size: 80.0,
                                                color: Colors.white,
                                              ),
                                              // top: 50.0,
                                              // left: 20.0,
                                            )
                                          : Container(),
                                    ],
                                  ))
                      : NoPictureWidget(),
                )
              : NoPictureWidget()
          : NoPictureWidget(),
    );
  }
}

class UploadPage extends StatelessWidget {
  final FileUploadBloc bloc;
  UploadPage({this.bloc});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream: bloc.selectedFilesAsString,
      builder: (context, snapshot) => snapshot.hasData && snapshot.data != []
          ? GridView.builder(
              // reverse: true,
              addAutomaticKeepAlives: true,
              itemCount: snapshot.data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1,
                  crossAxisCount: 3,
                  crossAxisSpacing: 3.0,
                  mainAxisSpacing: 3.0),
              itemBuilder: (context, i) =>
                  // Column(
                  //   children: <Widget>[
                  Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.topLeft,
                    children: <Widget>[
                      CustomListItem(
                        data: snapshot.data[i],
                      ),
                      getFileType(snapshot.data[i])
                          ? Positioned(
                              child: Icon(
                                Icons.play_arrow,
                                size: 35.0,
                                color: Colors.white,
                              ),
                              top: 3.0,
                              left: 3.0,
                            )
                          : Container(),
                    ],
                  ),
              // LinearProgressIndicator(
              //     value: 4,
              //     valueColor: AlwaysStoppedAnimation<Color>(
              //         Colors.greenAccent))
              //   ],
              // ),
            )
          : Center(
              child: Container(
                color: Colors.white,
                child: Text("No file selected to upload"),
              ),
            ),
    );
  }
}

class CustomListItem extends StatelessWidget {
  final String data;
  const CustomListItem({Key key, @required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return getFileType(data)
        ? Chewie(
            VideoPlayerController.file(File(data)),
            autoPlay: false,
            looping: false,
            showControls: false,
            aspectRatio: 1.0,
            placeholder: Container(
              color: Colors.grey[400],
              child: RaisedButton(
                child: Icon(
                  Icons.play_arrow,
                ),
                onPressed: () {},
              ),
            ),
            autoInitialize: true,
          )
        : Image.file(
            File(data),
            fit: BoxFit.fitWidth,
          );
  }
}

class NoPictureWidget extends StatelessWidget {
  const NoPictureWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(15.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              "No picture or video to display\nPlease take a picture or record a video first"),
        ),
      ),
    );
  }
}

// class CustomPhotosList extends StatelessWidget {
//   final String snapshotData;
//   final bool isGrid;
//   const CustomPhotosList(
//       {Key key, @required this.isGrid, @required this.snapshotData})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: isGrid ? 10.0 : 15.0),
//           height: isGrid ? 50.0 : MediaQuery.of(context).size.height / 1.3,
//           width: isGrid ? 25.0 : MediaQuery.of(context).size.width,
//           child: Image.file(File(snapshotData)),
//         ),
//         Positioned(
//             bottom: 25.0,
//             left: 25.0,
//             child: IconButton(
//               icon: Icon(Icons.delete),
//               iconSize: 30.0,
//               // color: Colors.white,
//               onPressed: () {
//                 //TOCHECK
//                 File("$snapshotData").delete();
//               },
//             )),
//         Positioned(
//             bottom: 25.0,
//             right: 25.0,
//             child: IconButton(
//               // color: Colors.white,
//               iconSize: 30.0,
//               icon: Icon(Icons.check_circle_outline),
//               onPressed: () {},
//             )),
//       ],
//     );
//   }
// }

// class ImageDetailPage extends StatelessWidget {
//   final tag;
//   final widget;

//   ImageDetailPage({this.tag, this.widget});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: GestureDetector(
//         child: Center(
//           child: Hero(tag: tag, child: widget),
//         ),
//         onTap: () {
//           Navigator.pop(context);
//         },
//       ),
//     );
//   }
// }

getFileType(file) {
  bool isVideo;
  String fileType = lookupMimeType(basename(file));
  fileType == 'video/mp4' ? isVideo = true : isVideo = false;
  return isVideo;
}

deleteFile(String filePath) {
  File(filePath).delete();
}
