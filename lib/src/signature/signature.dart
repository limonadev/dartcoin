import 'dart:typed_data';

import 'package:dartcoin/src/utils/all.dart';
import 'package:meta/meta.dart';

//TODO: Migrate to Dart latest SDK for null safety

class Signature {
  Signature({
    @required this.r,
    @required this.s,
  });

  final BigInt r;
  final BigInt s;

  Uint8List der() {
    var encoded = <int>[];

    List<int> rEncoded = ObjectUtils.bigIntToBytes(number: r);
    if (rEncoded[0] & 128 == 128) {
      rEncoded = [0x00, ...rEncoded];
    }
    encoded += [0x02, rEncoded.length] + rEncoded;

    List<int> sEncoded = ObjectUtils.bigIntToBytes(number: s);
    if (sEncoded[0] & 128 == 128) {
      sEncoded = [0x00, ...sEncoded];
    }
    encoded += [0x02, sEncoded.length] + sEncoded;

    encoded = [0x30, encoded.length, ...encoded];
    return Uint8List.fromList(encoded);
  }

  @override
  String toString() {
    return 'Signature($r, $s)';
  }
}
