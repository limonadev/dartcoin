import 'dart:typed_data';

import 'package:dartcoin/src/utils/all.dart';
import 'package:meta/meta.dart';

//TODO: Migrate to Dart latest SDK for null safety

class Signature {
  Signature({
    @required this.r,
    @required this.s,
  });

  factory Signature.fromSerialized({@required Uint8List der}) {
    final compound = der[0];
    if (compound != 0x30) {
      throw FormatException('Bad Signature');
    }
    final length = der[1];
    if (length + 2 != der.length) {
      throw FormatException('Bad Signature Length');
    }
    var marker = der[2];
    if (marker != 0x02) {
      throw FormatException('Bad Signature');
    }
    final rLength = der[3];
    final r = ObjectUtils.decodeBigInt(
      der.sublist(4, 4 + rLength),
    );
    marker = der[4 + rLength];
    if (marker != 0x02) {
      throw FormatException('Bad Signature');
    }
    final sLength = der[4 + rLength + 1];
    final s = ObjectUtils.decodeBigInt(
      der.sublist(4 + rLength + 2, 4 + rLength + 2 + sLength),
    );
    if (der.length != 6 + rLength + sLength) {
      throw FormatException('Signature too long');
    }

    return Signature(r: r, s: s);
  }

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
