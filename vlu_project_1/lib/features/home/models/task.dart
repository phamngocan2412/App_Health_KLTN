// ignore_for_file: public_member_api_docs, sort_constructors_first

class Task {
  int? id;
  String? title;
  String? note;
  String? date;
  String? startTime;
  int? color;
  String? repeat;

  Task({
    required this.id,
    required this.title,
    required this.note,
    required this.date,
    required this.startTime,
    required this.color,
    required this.repeat,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'note': note,
      'date': date,
      'startTime': startTime,
      'color': color,
      'repeat': repeat,
    };
  }

  Task.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    note = json['note'];
    date = json['date'];
    startTime = json['startTime'];
    color = json['color'];
    repeat = json['repeat'];
  }
}