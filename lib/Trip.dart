import 'dart:ffi';

class Trip{
  String? from;
  String? to;
  int? price;
  String? time;
  String? status;
  double? from_lat;
  double? from_lng;
  double? to_lat;
  double? to_lng;



  Trip({this.from,this.to,this.time,this.price,this.status,this.from_lat,this.from_lng,this.to_lat,this.to_lng});

}