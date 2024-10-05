import 'dart:math';
import 'dart:ui';

extension StringContext on String {
  Color get color {
    String colorStr = trim();
    if (colorStr.length == 7) colorStr = "FF$colorStr";
    colorStr = colorStr.replaceAll("#", "");
    int val = 0;
    int len = colorStr.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = colorStr.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw const FormatException("An error occurred when converting a color");
      }
    }
    return Color(val);
  }

  Color get getUniqueColorFromId {
    // Simple hash function
    int hash = hashCode;

    // Map the hash value to RGB values
    Random random = Random(hash);
    int r = random.nextInt(256); // Red value
    int g = random.nextInt(256); // Green value
    int b = random.nextInt(256); // Blue value

    return Color.fromARGB(255, r, g, b);
  }
}
