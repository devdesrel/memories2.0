import 'package:flutter/widgets.dart';
import 'package:memories/blocs/upload_file_bloc.dart';

class FileUploadProvider extends InheritedWidget {
  final FileUploadBloc fileUploadBloc;

  FileUploadProvider({
    Key key,
    FileUploadBloc fileUploadBloc,
    Widget child,
  })  : fileUploadBloc = fileUploadBloc ?? FileUploadBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static FileUploadBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(FileUploadProvider)
              as FileUploadProvider)
          .fileUploadBloc;
}
