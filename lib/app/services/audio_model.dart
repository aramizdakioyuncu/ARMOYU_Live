import 'dart:convert';
import 'dart:typed_data';

class AudioModel {
  final int userID;
  final Uint8List base64Audio;

  AudioModel({required this.userID, required this.base64Audio});

  // JSON'dan nesne oluşturma
  factory AudioModel.fromJson(Map<String, dynamic> json) {
    return AudioModel(
      userID: json['userID'] as int,
      base64Audio: base64Decode(
          json['base64Audio'] as String), // Base64'ü Uint8List'e çevir
    );
  }

  // Nesneyi JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'base64Audio':
          base64Encode(base64Audio), // Uint8List'i Base64 string'e çevir
    };
  }
}
