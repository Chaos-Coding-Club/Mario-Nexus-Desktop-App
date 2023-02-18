import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mario_nexus/auth/auth_client.dart';
import "package:mario_nexus/auth/auth_state.dart";

typedef AuthUriCallback = Future<Uri> Function(Uri authorizationUrl);

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthClient _authClient;

  AuthNotifier(this._authClient) : super(const AuthState.initial());

  Future<void> checkAndUpdateStatus() async {
    state = (await _authClient.isSignedIn())
        ? const AuthState.authenticated()
        : const AuthState.unauthenticated();
  }

  Future<void> signIn({required String email, required String password}) async {
    final failureOrSuccess = await _authClient.signIn(email, password);
    state = failureOrSuccess.fold(
      (l) => AuthState.failure(l),
      (r) => const AuthState.authenticated(),
    );
  }

  Future<void> register(
      {required String email, required String password}) async {
    final failureOrSuccess = await _authClient.regiser(email, password);
    state = failureOrSuccess.fold(
      (l) => AuthState.failure(l),
      (r) => const AuthState.authenticated(),
    );
  }

  Future<void> signOut() async {
    final failureOrSuccess = await _authClient.signOut();
    state = failureOrSuccess.fold(
      (l) => AuthState.failure(l),
      (r) => const AuthState.unauthenticated(),
    );
  }
}
