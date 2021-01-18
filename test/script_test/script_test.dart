import 'dart:typed_data';

import 'package:dartcoin/dartcoin.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

void main() {
  /// Each test is based on https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch05/script.py
  group('script_parsing', () {
    test('test_parse_sync', () {
      final scriptPubKey = ObjectUtils.bigIntToBytes(
        number: BigInt.parse(
          '6a47304402207899531a52d59a6de200179928ca900254a36b8dff8bb75f5f5d71b1cdc26125022008b422690b8461cb52c3cc30330b23d574351872b7c361e9aae3649071c1a7160121035d5c93d9ac96881f19ba1f686f15f009ded7c62efe85a872e6a19b43c15a2937',
          radix: 16,
        ),
      );
      final script = ScriptFactory.parseSync(bytes: scriptPubKey).result;

      var want = ObjectUtils.bigIntToBytes(
        number: BigInt.parse(
          '304402207899531a52d59a6de200179928ca900254a36b8dff8bb75f5f5d71b1cdc26125022008b422690b8461cb52c3cc30330b23d574351872b7c361e9aae3649071c1a71601',
          radix: 16,
        ),
      );

      expect(
        ObjectUtils.toHex(
          value: ObjectUtils.bytesToBigInt(bytes: script.cmds[0]),
        ),
        equals(
          ObjectUtils.toHex(value: ObjectUtils.bytesToBigInt(bytes: want)),
        ),
      );

      want = ObjectUtils.bigIntToBytes(
        number: BigInt.parse(
          '035d5c93d9ac96881f19ba1f686f15f009ded7c62efe85a872e6a19b43c15a2937',
          radix: 16,
        ),
      );

      expect(
        script.cmds[1],
        equals(want),
      );
    });
  });

  group('script_evaluation', () {
    test('p2pkh_test', () {
      final message = BigInt.parse(
        '7c076ff316692a3d7eb3c3bb0f8b1488cf72e1afcd929e29307032997a838a3d',
        radix: 16,
      );

      final sec = ObjectUtils.bytesFromHex(
        hex:
            '04887387e452b8eacc4acfde10d9aaf7f6d9a0f975aabb10d006e4da568744d06c61de6d95231cd89026e286df3b6ae4a894a3378e393e93a0f45b666329a0ae34',
      );
      final der = ObjectUtils.bytesFromHex(
        hex:
            '3045022000eff69ef2b1bd93a66ed5219add4fb51e11a840f404876325a1e8ffe0529a2c022100c7207fee197d27c618aea621406f6bf5ef6fca38681d82b2f06fddbdce6feab601',
      );
      final secHash = Secp256Utils.hash160(data: sec);

      final scriptPubKey = Script(
        cmds: [
          OpCode.OP_DUP.byte,
          OpCode.OP_HASH160.byte,
          secHash,
          OpCode.OP_EQUALVERIFY.byte,
          OpCode.OP_CHECKSIG.byte,
        ],
      );
      final scriptSig = Script(
        cmds: [der, sec],
      );

      final scriptExecutor = ScriptExecutor(
        message: message,
      );

      expect(
        scriptExecutor.runBoth(
          first: scriptSig,
          second: scriptPubKey,
        ),
        equals(true),
      );
    });
  });
}
