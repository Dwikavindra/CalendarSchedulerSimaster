import 'dart:core';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class Parser {
  Future<void> process() async {
    String regexReplacer = "(\\b((\\d|\\w)[^\\s]*[.]\\w+)\\b)";
    String regExFront = "(Dr\\." // Dr. Wahidin
        +
        "|DR\\." +
        "|Drs\\." +
        "|Ir\\." // Ir. Soekarno
        +
        "|Mr\\." // Mr. Yusuf
        +
        "|Mrs\\." +
        "|Ms\\." +
        "|Jr\\." +
        "|Sr\\." +
        "|Prof\\." +
        "|H\\." // H. Lulung
        +
        "|Hj\\." +
        "|W\\." // Maksum W. Kusumah
        +
        "|Tn\\." +
        "|Ny\\." +
        "|M\\." // M. Najib
        +
        "|H\\.M\\." // H.M. Prasetyo
        +
        ")\\s+" // Semua karakter whitespace \r \n \t \f
        +
        "(\\w+)";

    String regExBack = "(S\\.Kom" // Untuk S.Kom
        +
        "|S\\.Pd" +
        "|S\\.Sos" // HM Husni Maderi S.Sos
        +
        "|ßM\\." +
        "| \\.\\.\\.)";

    FilePickerResult? pdf = await FilePicker.platform.pickFiles();
    if (pdf != null) {
      PlatformFile file = pdf.files.first;
      final PdfDocument document = PdfDocument(inputBytes: file.bytes);
      String text = PdfTextExtractor(document).extractText();
      final List<TextLine> textLine =
          PdfTextExtractor(document).extractTextLines();
      print(text);
      LineSplitter splitter = const LineSplitter();
      List<String> splittedWords = splitter.convert(text);
      splittedWords.removeRange(0, 18);
      splittedWords.removeWhere(((element) => element == ""));
      splittedWords[3] = splittedWords[3] + " " + splittedWords[4];
      splittedWords.forEachIndexed((index, element) {
        if (element.contains(RegExp(regExFront + "|" + regExBack)) &&
            splittedWords[index + 1]
                .contains(RegExp(regExFront + "|" + regExBack))) {
          splittedWords[index] =
              splittedWords[index] + " " + splittedWords[index + 1];
          splittedWords.removeAt(index + 1);
        }
      });
      splittedWords.forEachIndexed((index, element) {
        if (element.contains(RegExp(regExFront + "|" + regExBack)) &&
            splittedWords[index + 1]
                .contains(RegExp(regExFront + "|" + regExBack))) {
          splittedWords[index] =
              splittedWords[index] + " " + splittedWords[index + 1];
          splittedWords.removeAt(index + 1);
        }
      });
      splittedWords.forEachIndexed((index, element) {
        print('index: $index, element: $element');
      });
      print(splittedWords);
      var dr = "Drs.";
      print(dr.contains(RegExp('Mr\\.|Drs\\.')));
    }
  }
}
