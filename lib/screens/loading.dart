import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mario_nexus/auth/auth_failure.dart';
import 'package:mario_nexus/providers/providers.dart';
import "package:flutter/cupertino.dart";
import 'package:mario_nexus/screens/auth.dart';
import 'package:mario_nexus/screens/home.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

final initializationProvider = FutureProvider(
  (ref) async {
    final authNotifier = ref.read(authNotifierProvider.notifier);
    await authNotifier.checkAndUpdateStatus();
  },
);

class Loading extends ConsumerStatefulWidget {
  const Loading({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoadingState();
}

class _LoadingState extends ConsumerState<Loading> {
  @override
  Widget build(BuildContext context) {
    ref.listen(
      initializationProvider,
      (previous, next) {},
    );
    final authNotifier = ref.watch(authNotifierProvider);
    return authNotifier.when(
      initial: () {
        return const SpinKitRing(
          color: CupertinoColors.white,
        );
      },
      unauthenticated: () => const Auth(),
      authenticated: () => const Home(),
      failure: (AuthFailure failure) {
        return const Auth(
          failed: true,
        );
      },
    );
  }
}
