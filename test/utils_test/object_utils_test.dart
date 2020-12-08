import 'package:dartcoin/dartcoin.dart';
import 'package:test/test.dart';

void main() {
  group('HashCode', () {
    test('Single Value', () {
      expect(
        ObjectUtils.buildHashCode([1]),
        equals(
          ObjectUtils.buildHashCode([1]),
        ),
      );

      expect(
        ObjectUtils.buildHashCode([1]),
        isNot(
          equals(
            ObjectUtils.buildHashCode([2]),
          ),
        ),
      );
    });
  });
  test('Multiple Values', () {
    expect(
      ObjectUtils.buildHashCode([1, 2, 3]),
      equals(
        ObjectUtils.buildHashCode([1, 2, 3]),
      ),
    );

    expect(
      ObjectUtils.buildHashCode([1, 'hi', 3]),
      equals(
        ObjectUtils.buildHashCode([1, 'hi', 3]),
      ),
    );

    expect(
      ObjectUtils.buildHashCode([1, 'hi', 3]),
      isNot(
        equals(
          ObjectUtils.buildHashCode([1, 2, 'hi']),
        ),
      ),
    );

    expect(
      ObjectUtils.buildHashCode([1, 2, 3]),
      isNot(
        equals(
          ObjectUtils.buildHashCode([1]),
        ),
      ),
    );
  });

  test('Null Values', () {
    expect(
      ObjectUtils.buildHashCode([null]),
      equals(
        ObjectUtils.buildHashCode([null]),
      ),
    );

    expect(
      ObjectUtils.buildHashCode([null]),
      isNot(
        equals(
          ObjectUtils.buildHashCode([1]),
        ),
      ),
    );

    expect(
      ObjectUtils.buildHashCode([1, null, 3]),
      isNot(
        equals(
          ObjectUtils.buildHashCode([1, 2, null]),
        ),
      ),
    );

    expect(
      ObjectUtils.buildHashCode([1, null, 3]),
      equals(
        ObjectUtils.buildHashCode([1, null, 3]),
      ),
    );
  });

  group('BigInt to bytes', () {
    test('Value lower than 32 bytes', () {
      final value = BigInt.one;
      expect(
        ObjectUtils.encodeBigInt(value).length < 32,
        equals(true),
      );

      var size = 10;
      var encoded = ObjectUtils.bigIntToBytes(
        number: value,
        size: size,
      );
      expect(
        encoded,
        equals([...List.filled(size - 1, 0), 1]),
      );

      size = 32;
      encoded = ObjectUtils.bigIntToBytes(
        number: value,
        size: size,
      );
      expect(
        encoded,
        equals([...List.filled(size - 1, 0), 1]),
      );
    });

    test('Value equal to 32 bytes', () {
      var value = BigInt.parse(
        '8995fa52fa91ee28d116a75756397692488901dcce7352b347fa859ee35d15d9',
        radix: 16,
      );
      expect(
        ObjectUtils.encodeBigInt(value).length,
        equals(32),
      );

      var size = 32;
      var encoded = ObjectUtils.bigIntToBytes(
        number: value,
        size: size,
      );
      expect(
        encoded,
        equals([
          ...[137, 149, 250, 82, 250, 145, 238, 40],
          ...[209, 22, 167, 87, 86, 57, 118, 146],
          ...[72, 137, 1, 220, 206, 115, 82, 179],
          ...[71, 250, 133, 158, 227, 93, 21, 217]
        ]),
      );

      size = 10;
      expect(
        () => ObjectUtils.bigIntToBytes(
          number: value,
          size: size,
        ),
        throwsRangeError,
      );
    });

    test('Value greater than 32 bytes', () {
      var value = BigInt.parse(
        '8995fa52fa91ee28d116a75756397692488901dcce7352b347fa859ee35d15d9ffffffff',
        radix: 16,
      );
      expect(
        ObjectUtils.encodeBigInt(value).length,
        equals(36),
      );

      var size = 36;
      var encoded = ObjectUtils.bigIntToBytes(
        number: value,
        size: size,
      );
      expect(
        encoded,
        equals([
          ...[137, 149, 250, 82, 250, 145, 238, 40, 209],
          ...[22, 167, 87, 86, 57, 118, 146, 72, 137],
          ...[1, 220, 206, 115, 82, 179, 71, 250, 133],
          ...[158, 227, 93, 21, 217, 255, 255, 255, 255],
        ]),
      );

      size = 32;
      expect(
        () => ObjectUtils.bigIntToBytes(
          number: value,
          size: size,
        ),
        throwsRangeError,
      );
    });
  });

  group('Bytes to BigInt', () {
    test('test_little_endian_to_int', () {
      var h = ObjectUtils.encodeBigInt(
        BigInt.parse(
          '99c3980000000000',
          radix: 16,
        ),
      );
      expect(
        ObjectUtils.bytesToBigInt(
          bytes: h,
          endian: Endian.little,
        ),
        equals(BigInt.from(10011545)),
      );

      h = ObjectUtils.encodeBigInt(
        BigInt.parse(
          'a135ef0100000000',
          radix: 16,
        ),
      );
      expect(
        ObjectUtils.bytesToBigInt(
          bytes: h,
          endian: Endian.little,
        ),
        equals(BigInt.from(32454049)),
      );
    });
  });
}
