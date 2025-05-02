import 'package:armoyu_desktop/app/constants/api_constants.dart';
import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_widgets/armoyuwidgets.dart';

class ARMOYU {
  static ARMOYUServices service = ARMOYUServices(
    apiKey: APIConstants.apiKEY,
  );

  static ARMOYUWidgets widget = ARMOYUWidgets(service: service);
}
