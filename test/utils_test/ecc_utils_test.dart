import 'package:dartcoin/dartcoin.dart';
import 'package:test/test.dart';

void main() {
  group('BigRandom', () {
    test('Big Value', () {
      final value = Secp256Utils.order;
      final r = Secp256Utils.bigRandom(max: value);

      expect(
        r < value,
        equals(true),
      );
      expect(
        r >= BigInt.zero,
        equals(true),
      );
    });

    test('Limit Values', () {
      var value = BigInt.from(255);
      var r = Secp256Utils.bigRandom(max: value);

      expect(
        r < value,
        equals(true),
      );
      expect(
        r >= BigInt.zero,
        equals(true),
      );

      value = BigInt.from(256);
      r = Secp256Utils.bigRandom(max: value);

      expect(
        r < value,
        equals(true),
      );
      expect(
        r >= BigInt.zero,
        equals(true),
      );

      value = BigInt.zero;

      expect(
        () => r = Secp256Utils.bigRandom(max: value),
        throwsArgumentError,
      );

      value = BigInt.from(-1);

      expect(
        () => r = Secp256Utils.bigRandom(max: value),
        throwsArgumentError,
      );
    });

    test('Small Value', () {
      final value = BigInt.two;
      final r = Secp256Utils.bigRandom(max: value);

      expect(
        r < value,
        equals(true),
      );
      expect(
        r >= BigInt.zero,
        equals(true),
      );
    });
  });
}
