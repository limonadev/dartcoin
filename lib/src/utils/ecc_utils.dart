import 'package:dartcoin/src/elliptic_curves.dart/s256_point.dart';
import 'package:dartcoin/src/finite_field/s256_field_element.dart';

class Secp256Utils {
  static final generator = S256Point(
    x: S256FieldElement(value: gx),
    y: S256FieldElement(value: gy),
  );

  static final gx = BigInt.parse(
    '79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798',
    radix: 16,
  );
  static final gy = BigInt.parse(
    '483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8',
    radix: 16,
  );

  static final order = BigInt.parse(
    'fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141',
    radix: 16,
  );

  static final BigInt prime =
      BigInt.two.pow(256) - BigInt.two.pow(32) - BigInt.from(977);

  static final BigInt valueA = BigInt.zero;
  static final BigInt valueB = BigInt.from(7);
}
