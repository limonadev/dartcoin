import 'package:dartcoin/dartcoin.dart';
import 'package:test/test.dart';

void main() {
  test('test_der', () {
    final testCases = [
      [BigInt.one, BigInt.two],
      [
        Secp256Utils.bigRandom(max: BigInt.two.pow(256)),
        Secp256Utils.bigRandom(max: BigInt.two.pow(255))
      ],
      [
        Secp256Utils.bigRandom(max: BigInt.two.pow(256)),
        Secp256Utils.bigRandom(max: BigInt.two.pow(255))
      ],
    ];

    for (final testCase in testCases) {
      final r = testCase[0];
      final s = testCase[1];

      final signature = Signature(r: r, s: s);
      final der = signature.der();
      final deserializedSign = Signature.fromSerialized(der: der);

      expect(deserializedSign.r, equals(r));
      expect(deserializedSign.s, equals(s));
    }
  });
}
