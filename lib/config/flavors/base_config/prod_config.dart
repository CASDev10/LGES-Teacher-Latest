import 'base_config.dart';

class ProdConfig implements BaseConfig {
  @override
  String get baseUrl => "https://phptest.cyberasol.com";

  @override
  bool get reportErrors => false;

  @override
  bool get trackEvents => false;

  @override
  bool get useHttps => false;
}
