part of 'package:armoyu_services/armoyu_services.dart';

final class _LoggingServices {
  static final _LoggingServices _instance = _LoggingServices._init();
  static _LoggingServices get instance => _instance;

  String? _version;
  String? get version => _version;

  Map<String, dynamic>? _deviceInfo;

  _LoggingServices._init() {
    logConsole(message: "API Initialized");
  }

  Future<bool> setup({required ARMOYUServices service}) async {
    await getAppVersion();
    await getDeviceInfo();

    Map<String, dynamic> result = await service.appServices._apiHelpers.post(
      endpoint: "0/0/0/0/0",
    );

    if (result['durum'] == 0) {
      return false;
    }
    return true;
  }

  Future<void> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    _version = packageInfo.version;
    logConsole(message: "App Version: $_version");
  }

  Future<void> getDeviceInfo() async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;
    _deviceInfo = deviceInfo.data;
    logConsole(message: "Device Info: $_deviceInfo");
  }

  void logConsole({required String message}) {
    log("[ARMOYU]: $message");
  }
}
