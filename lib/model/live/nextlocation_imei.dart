// To parse this JSON data, do
//
//     final nextLocationImei = nextLocationImeiFromJson(jsonString);

import 'dart:convert';

List<NextLocationImei> nextLocationImeiFromJson(String str) => List<NextLocationImei>.from(json.decode(str).map((x) => NextLocationImei.fromJson(x)));

String nextLocationImeiToJson(List<NextLocationImei> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NextLocationImei {
    int transactionId;
    String vehicleRegNo;
    String speed;
    String latitude;
    String longitude;
    String driverName;
    int speedLimit;
    String ignition;
    String distancetravel;
    String noOfSatelite;
    String address;
    String alertIndication;
    String vehicleType;
    String date;
    String time;
    String previousTime;
    String vehicleStatus;
    String heading;
    String imei;
    String gpsFix;
    dynamic transIdImei;

    NextLocationImei({
        required this.transactionId,
        required this.vehicleRegNo,
        required this.speed,
        required this.latitude,
        required this.longitude,
        required this.driverName,
        required this.speedLimit,
        required this.ignition,
        required this.distancetravel,
        required this.noOfSatelite,
        required this.address,
        required this.alertIndication,
        required this.vehicleType,
        required this.date,
        required this.time,
        required this.previousTime,
        required this.vehicleStatus,
        required this.heading,
        required this.imei,
        required this.gpsFix,
        this.transIdImei,
    });

    factory NextLocationImei.fromJson(Map<String, dynamic> json) => NextLocationImei(
        transactionId: json["transactionId"],
        vehicleRegNo: json["vehicleRegNo"],
        speed: json["speed"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        driverName: json["driverName"],
        speedLimit: json["speedLimit"],
        ignition: json["ignition"],
        distancetravel: json["distancetravel"],
        noOfSatelite: json["noOfSatelite"],
        address: json["address"],
        alertIndication: json["alertIndication"],
        vehicleType: json["vehicleType"],
        date: json["date"],
        time: json["time"],
        previousTime: json["previousTime"],
        vehicleStatus: json["vehicleStatus"],
        heading: json["heading"],
        imei: json["imei"],
        gpsFix: json["gpsFix"],
        transIdImei: json["transID_IMEI"],
    );

    Map<String, dynamic> toJson() => {
        "transactionId": transactionId,
        "vehicleRegNo": vehicleRegNo,
        "speed": speed,
        "latitude": latitude,
        "longitude": longitude,
        "driverName": driverName,
        "speedLimit": speedLimit,
        "ignition": ignition,
        "distancetravel": distancetravel,
        "noOfSatelite": noOfSatelite,
        "address": address,
        "alertIndication": alertIndication,
        "vehicleType": vehicleType,
        "date": date,
        "time": time,
        "previousTime": previousTime,
        "vehicleStatus": vehicleStatus,
        "heading": heading,
        "imei": imei,
        "gpsFix": gpsFix,
        "transID_IMEI": transIdImei,
    };
}
