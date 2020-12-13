import 'package:meta/meta.dart';

class ParsingResult<T> {
  ParsingResult({
    @required this.currentBytePosition,
    @required this.result,
  });

  final int currentBytePosition;
  final T result;
}
