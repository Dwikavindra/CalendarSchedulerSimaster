import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:myapp/sections/parser/parser_section.dart';
import 'utils/parser.dart';
import 'package:flutter/rendering.dart';

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

  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleSignIn() async {
    try {} catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPaintSizeEnabled =
        true; //will be disabled in release only for decoding UI
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: [ParserSection()],
        ));
  }
}
