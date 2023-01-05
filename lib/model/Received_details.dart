class ReceivedDetail{

  String? receiverId,donorId,name,number,hospitalName,quantity;

  ReceivedDetail({this.receiverId,this.donorId,this.name,this.number,this.hospitalName,this.quantity});

  factory ReceivedDetail.fromJson(Map<String,dynamic> map){
    return ReceivedDetail(
    receiverId: map['receiverId'],
    donorId: map['donorId'],
    name: map['name'],
    number: map['number'],
    hospitalName: map['hospitalName'],
    quantity: map['quantity']
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'receiverId': receiverId,
      'donorId': donorId,
      'name': name,
      'number': number,
      'hospitalName': hospitalName,
      'quantity': quantity
    };
  }

}