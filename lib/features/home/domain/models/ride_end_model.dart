import 'dart:convert';

import 'package:appzeto_taxi_driver/core/model/user_detail_model.dart';

RideEndModel userDetailResponseModelFromJson(String str) =>
    RideEndModel.fromJson(json.decode(str));

class RideEndModel {
  bool success;
  OnTripData? data;
  RideEndModel({required this.success, required this.data});

  factory RideEndModel.fromJson(Map<String, dynamic> json) {
    return RideEndModel(
      success: json["success"],
      data: OnTripData.fromJson(json["data"]),
    );
  }
}
