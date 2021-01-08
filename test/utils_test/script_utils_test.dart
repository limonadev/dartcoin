import 'dart:typed_data';

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

  test('test_encode_zero_number', () {
    expect(
      ScriptUtils.encodeNumber(number: BigInt.zero).isEmpty,
      equals(true),
    );
  });

  test('test_decode_non_zero_number', () {
    final encoded = [
      Uint8List.fromList(<int>[1]),
      Uint8List.fromList(<int>[128, 0]),
      Uint8List.fromList(<int>[128, 64]),
      Uint8List.fromList(<int>[128, 129, 0]),
      Uint8List.fromList(<int>[129]),
      Uint8List.fromList(<int>[128, 128]),
      Uint8List.fromList(<int>[128, 192]),
      Uint8List.fromList(<int>[128, 129, 128]),
    ];

    final expectedNumbers = [
      BigInt.parse('00000001', radix: 2),
      BigInt.parse('10000000', radix: 2),
      BigInt.parse('0100000010000000', radix: 2),
      BigInt.parse('1000000110000000', radix: 2),
      BigInt.from(-1),
      BigInt.from(-128),
      BigInt.from(-16512),
      BigInt.from(-33152),
    ];

    for (var i = 0; i < encoded.length; i++) {
      expect(
        ScriptUtils.decodeNumber(element: encoded[i]),
        equals(expectedNumbers[i]),
      );
    }
  });

  test('test_decode_zero_number', () {
    expect(
      ScriptUtils.decodeNumber(element: Uint8List.fromList(<int>[])),
      equals(BigInt.zero),
    );
  });

  test('test_complete_conversion', () {
    final range = 1000;

    for (final i in List.generate(range, (index) => index + 1)) {
      final number = BigInt.from(i);

      var encoded = ScriptUtils.encodeNumber(number: number);
      var decoded = ScriptUtils.decodeNumber(element: encoded);

      expect(
        decoded,
        equals(number),
      );

      encoded = ScriptUtils.encodeNumber(number: -number);
      decoded = ScriptUtils.decodeNumber(element: encoded);

      expect(
        decoded,
        equals(-number),
      );
    }

    final encoded = ScriptUtils.encodeNumber(number: BigInt.zero);
    final decoded = ScriptUtils.decodeNumber(element: encoded);

    expect(
      decoded,
      equals(BigInt.zero),
    );
  });
}
