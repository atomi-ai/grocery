class Config {
  final String apiUrl;
  final String host;
  final int serverPort;
  final int authPort;

  Config._(this.apiUrl, this.host, this.serverPort, this.authPort);

  static late Config _instance;

  static Config get instance => _instance;

  static void _loadConfig({host, serverPort = 8081, authPort = 9099}) {
    String apiUrl = 'http://$host:$serverPort/api';
    _instance = Config._(apiUrl, host, serverPort, authPort);
  }

  static void loadConfig() {
    _loadConfig(host: '10.0.2.2');
  }

  static void loadIntegrationTestingConfig() {
    _loadConfig(host: '10.0.2.2');
  }

  static void loadTestingConfig() {
    _loadConfig(host: '127.0.0.1');
  }
}
