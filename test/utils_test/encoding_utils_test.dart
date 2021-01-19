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
      final encoded = Base58Utils.humanReadable(
        encoded: Base58Utils.encode(bytes: bytes),
      );

      expect(
        encoded,
        equals(expected[i]),
      );
    }
  });
}
