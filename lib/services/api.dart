import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mario_nexus/auth/auth_failure.dart';
import 'package:mario_nexus/providers/providers.dart';
import 'package:path_provider/path_provider.dart';

class Api {
  Dio dio = Dio();

  Future<Either<AuthFailure, String>> getPythonScript(WidgetRef ref) async {
    final endpoint = dotenv.env['API_KEY'];
    final jwt = await ref.watch(jwtStorageProvider).getJwt();
    final dir = await getApplicationDocumentsDirectory();
    Response response = await dio.download(
      "$endpoint/download/getModelScript",
      "${dir.path}/script.py",
      options: Options(method: "GET", headers: {
        "Authorization": "Bearer $jwt",
      }),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      if (response.statusCode == 429) {
        return left(AuthFailure.server(
            "You are being rate limited. Try again after ${response.headers['Retry-After']} seconds."));
      } else {
        return left(const AuthFailure.server("Unable to process request"));
      }
    }
    return right("${dir.path}/script.py");
  }
}
