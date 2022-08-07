import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../utils/parser.dart';

class ParserSection extends StatefulWidget {
  const ParserSection({Key? key}) : super(key: key);

  @override
  State<ParserSection> createState() => _ParserSectionState();
}

class _ParserSectionState extends State<ParserSection> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ElevatedButton(
            child: const Text('parse'),
            onPressed: () async {
              Parser().process();
            },
          ),
        ],
      ),
    );
  }
}
