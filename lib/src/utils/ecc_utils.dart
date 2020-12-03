import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dartcoin/src/elliptic_curves.dart/s256_point.dart';
import 'package:dartcoin/src/models/operand.dart';
import 'package:meta/meta.dart';
import 'package:pointycastle/src/utils.dart';

class Secp256Utils {
  /// G
  static final generator = S256Point(
    x: Operand(value: gx),
    y: Operand(value: gy),
  );

  static final gx = BigInt.parse(
    '79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798',
    radix: 16,
  );
  static final gy = BigInt.parse(
    '483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8',
    radix: 16,
  );

  /// N
  static final order = BigInt.parse(
    'fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141',
    radix: 16,
  );

  /// P
  static final BigInt prime =
      BigInt.two.pow(256) - BigInt.two.pow(32) - BigInt.from(977);

  static final BigInt valueA = BigInt.zero;
  static final BigInt valueB = BigInt.from(7);

  /// Method to generate a random number below [max], taking at most
  /// `64` hex digits (starting from right) for [max], If [max] is
  /// smaller than that, the remaining space will be filled with zeros.
  /// If the result is called `x`, then `0 <= x < max`.
  static BigInt bigRandom({@required BigInt max, int seed}) {
    var hexResult = '00';

    final random = Random(seed);

    for (var i = 0; i < 32; i++) {
      final suffix = BigInt.from(random.nextInt(256)).toRadixString(16);
      final hexAppend = '$suffix$hexResult';
      final curr = BigInt.parse(hexAppend, radix: 16);

      if (curr < max) {
        hexResult = hexAppend;
      } else {
        break;
      }
    }

    return BigInt.parse(hexResult, radix: 16);
  }

  static Uint8List hash256({@required Uint8List data}) {
    return sha256.convert(sha256.convert(data).bytes).bytes;
  }
}
