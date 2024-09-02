import 'package:network_connectivity_checker/network_connectivity_checker.dart';

Future<void> main(List<String> arguments) async {
  final result =
      await NetworkConnectivityChecker.isConnected(); // default server and port
  if (result.hasError) {
    print(
        'Network: ${result.error!.code}: ${result.error!.message}: ${result.error!.details}');
  } else {
    print('Network: ${result.value}');
  }
}
