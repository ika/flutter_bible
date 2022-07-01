import 'package:digitalbibleapp/globals.dart';
import 'package:digitalbibleapp/vers/versionsPage.dart';

class Utilities {
// Color hexToColor(String code) {
//   return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
// }

  String reduceLength(int l, String t) {
    // length and text
    String text = (t.length > l) ? t.substring(0, l) : t;
    return text;
  }

  int getTime() {
    int time = DateTime.now().microsecondsSinceEpoch;
    return time;
  }

  void setDialogeHeight() {
    double dialogHeight;
    vkQueries.getActiveVerCount().then(
          (value) => {
            dialogHeight = (value.toDouble() * 35.00),
            //if (dialogHeight > 340.00) {dialogHeight = 340.00}
            Globals.dialogHeight = dialogHeight,
          },
        );
  }
}
