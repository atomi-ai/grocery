class Config {
  final String apiUrl;
  final String host;
  final int serverPort;
  final int authPort;

  Config._(this.apiUrl, this.host, this.serverPort, this.authPort);

  static late Config _instance;

  static Config get instance => _instance;

  static void loadConfig() {
    String host = '10.0.2.2';
    int serverPort = 8081;
    String apiUrl = 'http://$host:$serverPort/api';
    int authPort = 9099;
    // FirebaseAuth.instance.useAuthEmulator('10.0.2.2', 9099);
    _instance = Config._(apiUrl, host, serverPort, authPort);
  }

  static void loadTestingConfig() {
    String host = '10.0.2.2';
    int serverPort = 8081;
    String apiUrl = 'http://$host:$serverPort/api';
    int authPort = 9099;
    _instance = Config._(apiUrl, host, serverPort, authPort);
  }
}
