import "package:simple_notes/api/instance.dart";

Future<bool> isHasConnection() async {
  try {
    final response = await dio.get<void>("/all");

    return response.statusCode == 200;
  } catch (_) {
    return false;
  }
}
