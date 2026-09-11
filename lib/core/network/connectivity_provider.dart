import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  return Connectivity().onConnectivityChanged;
});

final isOfflineProvider = Provider<bool>((ref) {
  final result = ref.watch(connectivityProvider);
  return result.whenOrNull(
        data: (r) => r.every((e) => e == ConnectivityResult.none),
      ) ??
      false;
});
