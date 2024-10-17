import 'package:flutter/material.dart';

enum InternetType { weak, normal, good }

// InternetType enum'a name ve color özelliklerini ekleyen extension
extension InternetStatus on InternetType {
  String get name {
    switch (this) {
      case InternetType.weak:
        return 'Zayıf Bağlantı';
      case InternetType.normal:
        return 'Normal Bağlantı';
      case InternetType.good:
        return 'Güçlü Bağlantı';
    }
  }

  Color get color {
    switch (this) {
      case InternetType.weak:
        return Colors.red;
      case InternetType.normal:
        return Colors.orange;
      case InternetType.good:
        return Colors.green;
    }
  }

  Icon get icon {
    switch (this) {
      case InternetType.weak:
        return Icon(
          Icons.signal_cellular_alt_1_bar_rounded,
          color: color,
        );
      case InternetType.normal:
        return Icon(
          Icons.signal_cellular_alt_2_bar_rounded,
          color: color,
        );
      case InternetType.good:
        return Icon(
          Icons.signal_cellular_alt,
          color: color,
        );
    }
  }
}
