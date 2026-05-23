import 'package:armoyu_services/core/models/ARMOYU/media.dart';

class APIMediaUpload {
  final int status;
  final int mediaID;
  final String description;
  final String filetype;
  final String filecategory;
  final MediaURL mediaURL;

  APIMediaUpload({
    required this.status,
    required this.mediaID,
    required this.description,
    required this.filetype,
    required this.filecategory,
    required this.mediaURL,
  });
}
