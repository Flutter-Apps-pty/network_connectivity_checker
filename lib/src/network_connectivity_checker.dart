import 'dart:io';
import 'package:scotch_dev_error/scotch_dev_error.dart';

const _defaultServerPort = 53;

class NetworkConnectivityChecker {
  static final List<ServerOptions> _defaultServerIps = [
    ServerOptions('8.8.8.8'),
    ServerOptions('8.8.4.4'),
    ServerOptions('1.1.1.1'),
  ];

  /// Checks if the device has an internet connection.
  ///
  /// If [serverIp] is provided, the method attempts to connect to the specified server.
  /// If [serverPort] is not provided, it defaults to 53.
  /// If neither [serverIp] nor [serverPort] are provided, it falls back to the list
  /// of predefined servers.
  ///
  /// Returns `true` if a connection can be established, otherwise `false`.
  static Future<ErrorOr<bool>> isConnected(
      {String? userServerIp, int? userServerPort}) async {
    final List<ServerOptions> serversToCheck;
    if (userServerIp != null) {
      serversToCheck = [
        ServerOptions(userServerIp,
            serverPort: userServerPort ?? _defaultServerPort)
      ];
    } else {
      serversToCheck = _defaultServerIps;
    }
    try {
      for (var serverIP in serversToCheck) {
        final socket = await Socket.connect(
            serverIP.serverIp, serverIP.serverPort,
            timeout: Duration(seconds: 5));
        kDebugPrint(
            'Connected to ${socket.remoteAddress}:${socket.remotePort}');
        socket.close();
        return ErrorOr.value(true);
      }
    } catch (e) {
      kDebugPrint('No internet connection: $e');
      return ErrorOr.error(
        code: ScotchErrorCodes.clientConnectionDb_005,
        message: 'Socket-Connection fault.',
        details: 'Could not connect to server. Error: $e',
      );
    }

    return ErrorOr.error(
      code: ScotchErrorCodes.clientConnectionDb_005,
      message: 'No internet connection',
      details: 'Could not connect to any of the configured servers.',
    );
  }
}

class ServerOptions {
  final String serverIp;
  final int serverPort;

  ServerOptions(
    this.serverIp, {
    this.serverPort = _defaultServerPort,
  });
}
