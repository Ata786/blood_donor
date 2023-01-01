class SnapShot{

  String id;
  String screenShot;
  String location;
  String reason;
  String date;

  SnapShot({required this.id,required this.screenShot,required this.location,required this.reason,required this.date});

  factory SnapShot.fromJson(Map<String,dynamic> map){
    return SnapShot(id: map['id'], screenShot: map['screenShot'],location: map['location'],reason: map['reason'],date: map['date']);
  }

  Map<String,dynamic> toJson(){
    return {
      'id': id,
      'screenShot': screenShot,
      'location': location,
      'reason': reason,
      'date': date
    };
  }

}