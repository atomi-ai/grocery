class Config {
  final String apiUrl;

  Config._(this.apiUrl);

  static late Config _instance;

  static Config get instance => _instance;

  static void loadConfig() {
    String apiUrl = 'http://10.0.2.2:8081/api';
    // FirebaseAuth.instance.useAuthEmulator('10.0.2.2', 9099);

    _instance = Config._(apiUrl);
  }
}
