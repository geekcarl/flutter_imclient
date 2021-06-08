import 'package:date_format/date_format.dart';

class Utilities {
  static String formatTime(int timestamp) {
    var now = new DateTime.now();
    var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = formatDate(date, [HH, ':', mm]);
    } else {
      if (diff.inDays == 1) {
        time = '昨天';
      } else {
        time = formatDate(date, [MM, '-', dd]);
      }
    }

    return time;
  }
}
