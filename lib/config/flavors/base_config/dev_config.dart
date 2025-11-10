import 'base_config.dart';

class DevConfig implements BaseConfig {
  @override
  String get baseUrl =>
      "http://lgeswebtest.cyberasol.com/api/api/TeacherMobileApp";
  // String get baseUrl => "https://lgesapi.cyberasol.com/api/TeacherMobileApp";

  @override
  bool get reportErrors => false;

  @override
  bool get trackEvents => false;

  @override
  bool get useHttps => false;
}
