import 'dart:typed_data';

import 'package:dartcoin/dartcoin.dart';
import 'package:test/test.dart';

void main() {
  group('Varint', () {
    test('encode', () {
      final toEncode = ['1', 'ab12', 'ab12cd34', 'ab12cd34ab12cd34'];
      final prefixes = [null, 0xfd, 0xfe, 0xff];

      for (var i = 0; i < toEncode.length; i++) {
        final val = BigInt.parse(
          toEncode[i],
          radix: 16,
        );
        final result = Varint.encode(
          varint: val,
        );
        final expected = Uint8List.fromList(
          [
            if (prefixes[i] != null) prefixes[i],
            ...ObjectUtils.bigIntToBytes(
              number: val,
              endian: Endian.little,
            ),
          ],
        );

        expect(
          result,
          equals(expected),
        );
      }
    });

    test('Necessary Bytes', () {
      final flags = [1, 0xfd, 0xfe, 0xff];
      final expectedVals = [0, 2, 4, 8];

      for (var i = 0; i < flags.length; i++) {
        final flag = flags[i];

        expect(
          Varint.numberOfNecessaryBytes(flag: flag),
          equals(expectedVals[i]),
        );
      }
    });

    test('Read', () async {
      var raw = ObjectUtils.bigIntToBytes(
        number: BigInt.parse(
          '01',
          radix: 16,
        ),
      );
      var expected = ObjectUtils.bytesToBigInt(
        bytes: ObjectUtils.bigIntToBytes(
          number: BigInt.parse(
            '01',
            radix: 16,
          ),
        ),
        endian: Endian.little,
      ).toInt();
      var varint = Varint.read(bytes: raw);
      expect(
        varint,
        equals(expected),
      );

      raw = ObjectUtils.bigIntToBytes(
        number: BigInt.parse(
          'fdab12',
          radix: 16,
        ),
      );
      expected = ObjectUtils.bytesToBigInt(
        bytes: ObjectUtils.bigIntToBytes(
          number: BigInt.parse(
            'ab12',
            radix: 16,
          ),
        ),
        endian: Endian.little,
      ).toInt();
      varint = Varint.read(bytes: raw);
      expect(
        varint,
        equals(expected),
      );

      raw = ObjectUtils.bigIntToBytes(
        number: BigInt.parse(
          'feab12cd34',
          radix: 16,
        ),
      );
      expected = ObjectUtils.bytesToBigInt(
        bytes: ObjectUtils.bigIntToBytes(
          number: BigInt.parse(
            'ab12cd34',
            radix: 16,
          ),
        ),
        endian: Endian.little,
      ).toInt();
      varint = Varint.read(bytes: raw);
      expect(
        varint,
        equals(expected),
      );

      raw = ObjectUtils.bigIntToBytes(
        number: BigInt.parse(
          'ffab12cd34ab12cd34',
          radix: 16,
        ),
      );
      expected = ObjectUtils.bytesToBigInt(
        bytes: ObjectUtils.bigIntToBytes(
          number: BigInt.parse(
            'ab12cd34ab12cd34',
            radix: 16,
          ),
        ),
        endian: Endian.little,
      ).toInt();
      varint = Varint.read(bytes: raw);
      expect(
        varint,
        equals(expected),
      );
    });
  });
}
