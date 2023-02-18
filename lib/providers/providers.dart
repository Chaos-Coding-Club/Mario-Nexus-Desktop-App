import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mario_nexus/auth/auth_client.dart';
import 'package:mario_nexus/auth/auth_notifier.dart';
import 'package:mario_nexus/auth/auth_state.dart';
import 'package:mario_nexus/utils/secure_jwt_storage.dart';

final flutterSecureStorage = Provider((ref) => const FlutterSecureStorage());
final jwtStorageProvider = Provider(
  (ref) => SecureJwtStorage(ref.watch(flutterSecureStorage)),
);
final authProvider = Provider(
  (ref) => AuthClient(ref.watch(jwtStorageProvider)),
);
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.watch(authProvider)),
);
