import 'package:flutter/cupertino.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100.0,
          child: Center(
            child: CupertinoActivityIndicator(),
            // child: CircularProgressIndicator(),
          ),
        ),
    );
  }
}