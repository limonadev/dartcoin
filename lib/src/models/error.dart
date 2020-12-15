import 'package:meta/meta.dart';

class NetworkError extends Error {
  NetworkError({
    @required this.reasonPhrase,
    @required this.statusCode,
  });

  final String reasonPhrase;
  final int statusCode;
}
