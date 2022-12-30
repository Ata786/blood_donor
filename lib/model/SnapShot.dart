class SnapShot{

  String id;
  String screenShot;

  SnapShot({required this.id,required this.screenShot});

  factory SnapShot.fromJson(Map<String,dynamic> map){
    return SnapShot(id: map['id'], screenShot: map['screenShot']);
  }

  Map<String,dynamic> toJson(){
    return {
      'id': id,
      'screenShot': screenShot
    };
  }

}