// import 'dart:html';
// import 'dart:io';
import 'dart:typed_data';
import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
// import 'package:googleapis/calendar/v3.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'parser.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';

// final GoogleSignIn _googleSignIn = GoogleSignIn(
//   // Optional clientId
//   scopes: <String>[CalendarApi.calendarEventsScope],
// );
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  // GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    // super.initState();
    // _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
    //   setState(() {
    //     _currentUser = account;
    //   });
    // });

    // _googleSignIn.signInSilently();
  }

  // Future<void> _handleSignIn() async {
  //   try {
  //     // await _googleSignIn.signIn();
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  // Future<void> _handleSignOut() => _googleSignIn.disconnect();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: _buildBody());
  }

  Widget _buildBody() {
    return (ElevatedButton(
        child: const Text('parse'),
        onPressed: () async {
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

            // textLine.forEach((element) {
            //   // if (element.text
            //   //     .contains(RegExp(regExFront + "|" + regExBack)))
            //   //   print(element.text);
            //   print(element.fontName);
            // });
            document.dispose();
          }
          ;
        }));
  }
}
