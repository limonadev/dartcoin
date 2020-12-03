import 'dart:math';

import 'package:dartcoin/dartcoin.dart';
import 'package:pointycastle/src/utils.dart';
import 'package:test/test.dart';

void main() {
  test('test_sign', () {
    final random = Random();
    final n = Secp256Utils.order.toRadixString(16);

    // This is a possible way to generate a random number below a BigInt
    final secret = List.generate(
      32,
      (index) {
        final max = int.parse('${n[2 * index]}${n[2 * index + 1]}', radix: 16);
        return random.nextInt(max);
      },
    );

    final privateKey = PrivateKey(secret: decodeBigInt(secret));
    final z = BigInt.from(random.nextInt(100));

    final sig = privateKey.sign(z: z);

    expect(
      privateKey.point.verify(sig: sig, z: z),
      equals(true),
    );
  });
}
