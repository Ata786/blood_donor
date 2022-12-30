class User{

  String? sId,image,name,email,password,bloodGroup,address,type;
  bool? isLogin;
  double? latitude,longitude;

  User({this.sId,this.image,this.name,this.email,this.password,this.bloodGroup,this.latitude,this.longitude,this.address,this.type,this.isLogin});

  factory User.fromJson(Map<String,dynamic> map){
    return User(
        sId: map['_id'],
        image: map['image'],
        name: map['name'],
        email: map['email'],
        password: map['password'],
        bloodGroup: map['bloodGroup'],
        latitude: map['latitude'],
        longitude: map['longitude'],
        address: map['address'],
        type: map['type'],
        isLogin: map['isLogin']
    );
  }

  Map<String,dynamic> toJson(){
    return {
      '_id': this.sId,
      'image': this.image,
      'name': this.name,
      'email': this.email,
      'password': this.password,
      'bloodGroup': this.bloodGroup,
      'latitude': this.latitude,
      'longitude': this.longitude,
      'address': this.address,
      'type': this.type,
      'isLogin': this.isLogin
    };
  }


}