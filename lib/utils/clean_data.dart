class CleanData {
  static bool containsTitle(String element, List<String> gelar) {
    bool condition = false;
    for (int i = 0; i < gelar.length; i++) {
      if (element.contains(gelar[i])) {
        condition = true;
        break;
      }
    }
    return condition;
  }

  static void cleanKodeMatkul(List<String> data, int startIndex) {
    for (int i = startIndex; i < data.length; i += 2) {
      data.removeAt(i);
    }
  }

  static bool isInteger(String input) {
    try {
      int.parse(input);
      return true;
    } catch (e) {
      return false;
    }
  }
}
