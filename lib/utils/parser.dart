import 'dart:core';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class Parser {
  static const regExFront = "(Dr\\." // Dr. Wahidin
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
  static const regExReplacer = "(\\b((\\d|\\w)[^\\s]*[.]\\w+)\\b)";
  static const regeExBack = "(S\\.Kom" // Untuk S.Kom
      +
      "|S\\.Pd" +
      "|S\\.Sos" // HM Husni Maderi S.Sos
      +
      "|M\\." +
      "| \\.\\.\\.)";

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  List<String> parseConstantPDFComponents(String text) {
    //for parsing constant PDF components i.e UGM Logo, SKS, Pengajar
    //Words guaranteed to be in the PDF
    LineSplitter splitter = const LineSplitter();
    List<String> splittedWords =
        splitter.convert(text); //split into a new index every new line
    splittedWords.removeRange(0, 18); //remove unimportant text at start
    splittedWords.removeWhere(((element) => element == "")); //remove blanks
    splittedWords[3] = splittedWords[3] + " " + splittedWords[4]; //paket Semx
    splittedWords.removeAt(4);
    return splittedWords;
  }

  void joinTeacherintoOneIndex(List<String> parsedConstantComponents) {
    //to join two different index into one index inside the string
    // example :
    // index 1. Agus Sihabuddin
    // index 2. Azhari
    // becomes:
    // index 1 : Agus Sihabuddin ; Azhari , etc

    for (int i = 0; i < parsedConstantComponents.length; i++) {
      if (parsedConstantComponents[i]
          .contains(RegExp(regExFront + "|" + regeExBack))) {
        recursiveFindTeacher(i, parsedConstantComponents,
            i + 1); //check full with name and title
      }
      //check if the title in the back of the name  is somehow not aggregated
      if (parsedConstantComponents[i].contains(RegExp(regeExBack)) &&
          double.tryParse(parsedConstantComponents[i - 1]) == null) {
        parsedConstantComponents[i - 1] += parsedConstantComponents[i];
        parsedConstantComponents.removeAt(i);
      }
    }
  }

  void recursiveFindTeacher(
      int firstHitIndex, List<String> parsedConstantComponents, int n_index) {
    // firsthitindex ga mungkin 0 soalnya ketemu di if statement di atas pas for loop;
    if (parsedConstantComponents[n_index]
        .contains(RegExp(regExFront + "|" + regeExBack))) {
      parsedConstantComponents[firstHitIndex] =
          parsedConstantComponents[firstHitIndex] +
              "! " +
              parsedConstantComponents[n_index];
      parsedConstantComponents.removeAt(n_index);
      recursiveFindTeacher(
          firstHitIndex, parsedConstantComponents, n_index + 1);
    }

    return;
  }

  Future<void> process() async {
    FilePickerResult? pdf = await FilePicker.platform.pickFiles();
    if (pdf != null) {
      PlatformFile file = pdf.files.first;
      final PdfDocument document = PdfDocument(inputBytes: file.bytes);
      String text = PdfTextExtractor(document).extractText();
      List<String> parsedConstantComponents = parseConstantPDFComponents(text);
      parsedConstantComponents.forEachIndexed((index, element) {
        print('index: $index, element: $element');
      });
      joinTeacherintoOneIndex(parsedConstantComponents);
      // parsedConstantComponents.forEachIndexed((index, element) {
      //   if (element.contains(RegExp(regExFront + "|" + regeExBack)) &&
      //       splittedWords[index + 1]
      //           .contains(RegExp(regExFront + "|" + regeExBack))) {
      //     splittedWords[index] =
      //         splittedWords[index] + " " + splittedWords[index + 1];
      //     splittedWords.removeAt(index + 1);
      //   }
      // });
      // parsedConstantComponents.forEachIndexed((index, element) {
      //   if (element.contains(RegExp(regExFront + "|" + regeExBack)) &&
      //       splittedWords[index + 1]
      //           .contains(RegExp(regExFront + "|" + regeExBack))) {
      //     splittedWords[index] =
      //         splittedWords[index] + " " + splittedWords[index + 1];
      //     splittedWords.removeAt(index + 1);
      //   }
      // });
      parsedConstantComponents.forEachIndexed((index, element) {
        print('index: $index, element: $element');
      });
      var dr = "Drs.";
      print(dr.contains(RegExp('Mr\\.|Drs\\.')));
    }
  }
}
