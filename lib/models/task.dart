// ignore: empty_constructor_bodies, empty_constructor_bodies
class Task {
  late int? id;
  late String title;
  late String note;
  late int isCompleted;
  late String date;
  late String startTime;
  late String endTime;
  late int color;
  late int remind;
  late String repeat;


Task({
  required this.title,
  required this.date,
  required this.color,
  this.id,
  required this.endTime,
  required this.isCompleted,
  required this.note,
  required this.remind,
  required this.repeat,
  required this.startTime
  });

Task.formJson(Map<String , dynamic> json){
  id =json['id'];
  title = json['title'];
  note =json['note'];
  isCompleted = json['isCompleted'];
  date = json['date'];
  startTime =json['startTime'];
  endTime = json['endTime'];
  color =json['color'];
  remind = json['remind'];
  repeat = json['repeat'];

}

Map<String,dynamic> toJson(){
  final Map<String, dynamic> date = new Map<String,dynamic>();
  date['id'] = this.id;
  date['title'] = this.title;
  date['date'] = this.date;
  date['note'] = this.note;
  date['isCompleted'] = this.isCompleted;
  date['startTime'] = this.startTime;
  date['endTime'] = this.endTime;
  date['color'] = this.color;
  date['remind'] = this.remind;
  date['repeat'] = this.repeat;
  return date;

}

}