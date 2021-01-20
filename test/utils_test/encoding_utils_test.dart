import 'dart:typed_data';

import 'package:dartcoin/src/dartcoin_base.dart';
import 'package:test/test.dart';

void main() {
  test('Encoding with base58', () {
    final hexNumbers = [
      '7c076ff316692a3d7eb3c3bb0f8b1488cf72e1afcd929e29307032997a838a3d',
      'eff69ef2b1bd93a66ed5219add4fb51e11a840f404876325a1e8ffe0529a2c',
      'c7207fee197d27c618aea621406f6bf5ef6fca38681d82b2f06fddbdce6feab6',
    ];
    final expected = [
      '9MA8fRQrT4u8Zj8ZRd6MAiiyaxb2Y1CMpvVkHQu5hVM6',
      '4fE3H2E6XMp4SsxtwinF7w9a34ooUrwWe4WsW1458Pd',
      'EQJsjkd6JaGwxrjEhfeqPenqHwrBmPQZjJGNSCHBkcF7',
    ];

    for (var i = 0; i < hexNumbers.length; i++) {
      final hex = hexNumbers[i];
      final bytes = ObjectUtils.bigIntToBytes(
        number: BigInt.parse(
          hex,
          radix: 16,
        ),
      );
      final encoded = Base58Utils.toHumanReadable(
        encoded: Base58Utils.encode(bytes: bytes),
      );

      expect(
        encoded,
        equals(expected[i]),
      );
    }
  });

  /// Based on https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch07/helper.py
  test('test_base58', () {
    final encoded = [
      'mnrVtF8DWjMu839VW3rBfgYaAfKk8983Xf',
    ];
    final expected = [
      '507b27411ccf7f16f10297de6cef3f291623eddf',
    ];

    for (var i = 0; i < encoded.length; i++) {
      final decoded = Base58Utils.decodeAddress(
        base58Address: Base58Utils.fromHumanReadable(
          humanReadable: encoded[i],
        ),
      );
      final hex = ObjectUtils.bytesToHex(
        bytes: decoded,
      );
      expect(
        hex,
        equals(expected[i]),
      );

      final address = Base58Utils.toHumanReadable(
        encoded: Base58Utils.encodeChecksum(
          bytes: Uint8List.fromList(
            [
              0x6f,
              ...ObjectUtils.bytesFromHex(
                hex: hex,
              )
            ],
          ),
        ),
      );
      expect(
        encoded[i],
        equals(address),
      );
    }
  });
}
