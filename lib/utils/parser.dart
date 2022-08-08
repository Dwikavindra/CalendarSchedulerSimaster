import 'dart:core';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_pdf/pdf.dart';

//TODO:
//Agregate Mata Kuliah with limiter being if gelar is recognized then stop and agregate
//use the same method as to agregate teachers
// After which remove kode matkul
//Done

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
  static const regeExBack = "(S\\.Kom" // Untuk S.Kom
      +
      "|S\\.Pd" +
      "|S\\.Sos" // HM Husni Maderi S.Sos
      +
      "|M\\." +
      "|B\\." +
      "|PhD" +
      "|Ph.\\D" +
      "| \\.\\.\\.)";

  List<String> parseConstantPDFComponents(String text) {
    //for parsing constant PDF components i.e UGM Logo, SKS, Pengajar
    //Words guaranteed to be in the PDF
    LineSplitter splitter = const LineSplitter();
    List<String> splittedWords =
        splitter.convert(text); //split into a new index every new line
    splittedWords.removeWhere(((element) =>
        double.tryParse(element) !=
        null)); // remove all numbers// idk why it doesnt work before aggregation
    splittedWords.removeRange(0, 18); //remove unimportant text at start
    splittedWords.removeLast(); //remove FO.JADWAL KULIAh
    splittedWords.removeWhere(((element) => element == "")); //remove blanks
    splittedWords
        .removeWhere(((element) => element.contains("Kelas:"))); //remove blanks
    splittedWords.removeWhere((element) => element == "No");
    splittedWords.removeWhere((element) => element == "Paket");
    splittedWords.removeWhere((element) => element == "SkS");
    splittedWords.removeWhere((element) => element == "Sem");
    splittedWords.removeWhere((element) => element == "SKS");

    print("Splitted Words after unnecessary removed ");
    splittedWords.forEachIndexed((index, element) {
      print('index: $index, element: $element');
    });
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
    }
  }

  void recursiveFindTeacher(
      int firstHitIndex, List<String> parsedConstantComponents, int n_index) {
    print("this is parsed n_index " + parsedConstantComponents[n_index]);
    // firsthitindex ga mungkin 0 soalnya ketemu di if statement di atas pas for loop;
    if (parsedConstantComponents[n_index]
            .contains(RegExp(regExFront + "|" + regeExBack)) ==
        false) {
      return;
    } else {
      parsedConstantComponents[firstHitIndex] =
          parsedConstantComponents[firstHitIndex] +
              "!" +
              parsedConstantComponents[n_index];
      parsedConstantComponents.removeAt(n_index);
      recursiveFindTeacher(firstHitIndex, parsedConstantComponents, n_index);
    }
  }

  Future<void> process() async {
    FilePickerResult? pdf = await FilePicker.platform.pickFiles();
    if (pdf != null) {
      PlatformFile file = pdf.files.first;
      final PdfDocument document = PdfDocument(inputBytes: file.bytes);
      String text = PdfTextExtractor(document).extractText();
      List<String> parsedConstantComponents = parseConstantPDFComponents(text);
      joinTeacherintoOneIndex(parsedConstantComponents);
      parsedConstantComponents.removeWhere(((element) =>
          double.tryParse(element) !=
          null)); // remove all numbers// idk why it doesnt work before aggregation

      //parsed without sks removed
      parsedConstantComponents.forEachIndexed((index, element) {
        print('index: $index, element: $element');
      });
      print("\n");
      print("With Kode Matkul joined \n ");
      print("\n");
      parsedConstantComponents.forEachIndexed((index, element) {
        print('index: $index, element: $element');
      });
      String gelar = "M.Sc., M.Cs.";
      print(gelar.contains(RegExp(regExFront + "|" + regeExBack)));

      //Map each components to a model
    }
  }
}
// we cant do this locally to many edge cases

/// 1,2,3,4  6,7,8,9  11,12,13,14
///
/// skip at 0
