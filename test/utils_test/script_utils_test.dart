import 'package:dartcoin/dartcoin.dart';
import 'package:test/test.dart';

void main() {
  test('test_encode_non_zero_number', () {
    final numbers = [
      BigInt.parse('00000001', radix: 2),
      BigInt.parse('10000000', radix: 2),
      BigInt.parse('0100000010000000', radix: 2),
      BigInt.parse('1000000110000000', radix: 2),
      BigInt.from(-1),
      BigInt.from(-128),
      BigInt.from(-16512),
      BigInt.from(-33152),
    ];

    final expectedLastByte = [
      1,
      0,
      64,
      0,
      int.parse('10000001', radix: 2),
      128,
      int.parse('11000000', radix: 2),
      128,
    ];

    for (var i = 0; i < numbers.length; i++) {
      expect(
        ScriptUtils.encodeNumber(number: numbers[i]).last,
        equals(expectedLastByte[i]),
      );
    }
  });
}
