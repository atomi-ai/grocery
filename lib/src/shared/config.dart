class Config {
  final String apiUrl;

  Config._(this.apiUrl);

  static Config _instance;

  static Config get instance {
    if (_instance == null) {
      throw Exception("Configuration not loaded yet");
    }
    return _instance;
  }

  static Future<void> loadConfig() async {
    String apiUrl = 'http://10.0.2.2:8081/api/v1';

    _instance = Config._(apiUrl);
  }
}
