import 'event_model.dart';

class DataMapping {
  List<String> data;

  DataMapping(this.data);

  List<String> getSchedule() {
    List<String> newdata = [];
    for (int i = 2; i < data.length; i += 3) {
      print("schedule data being added ${data[i]}");
      newdata.add(data[i]); //adding the data to the new list
    }
    return newdata;
  }

  List<String> getSubject() {
    List<String> newdata = [];
    for (int i = 1; i < data.length; i += 3) {
      print("data subject being added ${data[i]}");
      newdata.add(data[i]); //adding the data to the new list
    }
    return newdata;
  }

  List<Event_Model> mapData() {
    List<String> subject = DataMapping(data).getSubject();
    List<String> schedule = DataMapping(data).getSchedule();
    print("Nama Matkul: $subject");

    print("Schedules: $schedule");
    List<Event_Model> mappedData = [];
    String eventName;
    String startDay;
    String startTime;
    String endTime;
    for (int i = 0; i < subject.length; i++) {
      eventName = subject[i];
      startDay = getStartDay(schedule[i]).toString();
      startTime = getStartTime(schedule[i]);
      endTime = getEndTIme(schedule[i]);
      Event_Model event = new Event_Model(
          event_name: eventName,
          start_day: startDay,
          start_time: startTime,
          end_time: endTime);
      mappedData.add(event);
    }
    return mappedData;
  }

  static int getStartDay(String data) {
    List<String> splitData = data.split(" ");
    String dayWithComma = splitData[0];
    List<String> resultSplit = dayWithComma.split("");
    resultSplit.removeLast();
    String result = resultSplit.join(); // without comma
    switch (result) {
      case "Senin":
        return 1;
      case "Selasa":
        return 2;
      case "Rabu":
        return 3;
      case "Kamis":
        return 4;
      case "Jumat":
        return 5;
      case "Sabtu":
        return 6;
      case "Minggu":
        return 7;
      default:
        return 0;
    }
  }

  String getStartTime(data) {
    List<String> splitData = data.split(" ");
    List<String> unprocessedTime = splitData[1].split("-");
    String startTime = unprocessedTime[0];
    return startTime;
  }

  String getEndTIme(data) {
    List<String> splitData = data.split(" ");
    List<String> unprocessedTime = splitData[1].split("-");
    String endTime = unprocessedTime[1];
    return endTime;
  }
}
