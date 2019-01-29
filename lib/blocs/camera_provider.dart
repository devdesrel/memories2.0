import 'package:flutter/widgets.dart';
import 'package:memories/blocs/camera_bloc.dart';

class CameraProvider extends InheritedWidget {
  final CameraBloc cameraBloc;

  CameraProvider({
    Key key,
    CameraBloc cameraBloc,
    Widget child,
  })  : cameraBloc = cameraBloc ?? CameraBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static CameraBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(CameraProvider) as CameraProvider)
          .cameraBloc;
}
