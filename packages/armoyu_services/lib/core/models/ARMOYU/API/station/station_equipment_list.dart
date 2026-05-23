import 'package:armoyu_services/core/models/ARMOYU/media.dart';

class APIStationEquipmentList {
  int equipmentId;
  String equipmentName;
  String equipmentType;
  MediaURL equipmentImage;
  String equipmentPrice;

  APIStationEquipmentList({
    required this.equipmentId,
    required this.equipmentName,
    required this.equipmentType,
    required this.equipmentImage,
    required this.equipmentPrice,
  });

  // JSON'dan nesne oluşturma
  factory APIStationEquipmentList.fromJson(Map<String, dynamic> json) {
    return APIStationEquipmentList(
      equipmentId: json['equipment_ID'],
      equipmentName: json['equipment_name'],
      equipmentType: json['equipment_type'],
      equipmentImage: MediaURL.fromJson(json['equipment_image']),
      equipmentPrice: json['equipment_price'],
    );
  }

  // Nesneyi JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'equipment_ID': equipmentId,
      'equipment_name': equipmentName,
      'equipment_type': equipmentType,
      'equipment_image': equipmentImage.toJson(),
      'equipment_price': equipmentPrice,
    };
  }
}
