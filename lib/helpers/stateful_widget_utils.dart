import 'package:flutter/material.dart';
import 'package:weather_app/style/style.dart';
import 'package:weather_app/utils/utils.dart';

mixin StatefulWidgetUtilsMixin<T extends StatefulWidget> on State<T> {

  @protected
  Color get primaryColor => AppStyle.primaryColor(context);

  @protected
  NavigatorState get navigator => Navigator.of(context);

  @protected
  showSnackbar(BuildContext context, String text) {
    final SnackBar snackBar = SnackBar(
      content: Text(text),
      duration: Duration(seconds: 2),
      );

    Scaffold.of(context).showSnackBar(snackBar);
  }

  /// Determines if internet connection is active and do your 'online', or do your 'offline'
  @protected
  doOnlineOr(BuildContext context, {Function online, Function offline}) async {
    bool isOnline = await NetworkUtils.isOnline;
    if (isOnline) {
      // Connection is active
      online();
    } else {
      // No connection
      if (offline == null) {
        showSnackbar(context, "Check your internet connection and try again.");
      } else {
        offline();
      }
    }
  }
}
