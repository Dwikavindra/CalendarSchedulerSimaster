import 'dart:ffi';
import 'event_model.dart';
import 'package:html/parser.dart';
import 'dart:async';
import 'dart:io';
import 'dart:core';
import 'package:myapp/clean_data.dart';
import 'data_mapping.dart';

class Parser {
  Future<void> process() async {
    List<String> data = [];
    final html = await File('assets/Coba.html').readAsString();
    final processed = html.toString();
    final processing = """$processed""";
    final document = parse(processing);
    var rows =
        document.getElementsByTagName("table")[0].getElementsByTagName("td");
    rows.map((e) {
      // print(e);//this is only the tag for some reason
      // print(e.innerHtml);//this the inside
      return e.innerHtml;
      /*langsung map sini*/
    }).forEach((element) {
      List<String> gelar = [
        "Dr.",
        "Prof.",
        "Profs.",
        "M.",
        "Drs.",
        "S.",
        "Ph.",
        "A.Md.",
        "A.Ma.",
        "A.P"
      ];
      var isgelar = CleanData.containsTitle(element, gelar);
      bool isInt = CleanData.isInteger(element);

      var pushed = element
          .replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ')
          .replaceAll(RegExp('[\\s+]{2,}'), " ")
          .trim(); //remove html tags and whitesapce more than 2
      if (pushed != "-" && !isgelar && !isInt) {
        data.add(pushed); //sini langsung add ke list beuh mantap
      }
    });
    print(data);
    DataMapping mappedData = DataMapping(data);

    List<Event_Model> events = mappedData.mapData();
    print(events.length);
  }
}
