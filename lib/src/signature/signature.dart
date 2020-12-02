import 'package:meta/meta.dart';

//TODO: Migrate to Dart latest SDK for null safety

class Signature {
  Signature({
    @required this.r,
    @required this.s,
  });

  final BigInt r;
  final BigInt s;

  @override
  String toString() {
    return 'Signature($r, $s)';
  }
}
