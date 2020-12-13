import 'dart:typed_data';

import 'package:dartcoin/dartcoin.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

/// Each test is based on https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch05/script.py
void main() {
  Stream<int> fakeSyncRead({@required Uint8List scriptPubKey}) async* {
    for (var byte in scriptPubKey) {
      yield byte;
    }
  }

  test('test_parse', () async {
    final scriptPubKey = ObjectUtils.bigIntToBytes(
      number: BigInt.parse(
        '6a47304402207899531a52d59a6de200179928ca900254a36b8dff8bb75f5f5d71b1cdc26125022008b422690b8461cb52c3cc30330b23d574351872b7c361e9aae3649071c1a7160121035d5c93d9ac96881f19ba1f686f15f009ded7c62efe85a872e6a19b43c15a2937',
        radix: 16,
      ),
    );
    final stream = fakeSyncRead(scriptPubKey: scriptPubKey);
    final script = await ScriptFactory.parse(stream);

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

  test('test_parse_sync', () {
    final scriptPubKey = ObjectUtils.bigIntToBytes(
      number: BigInt.parse(
        '6a47304402207899531a52d59a6de200179928ca900254a36b8dff8bb75f5f5d71b1cdc26125022008b422690b8461cb52c3cc30330b23d574351872b7c361e9aae3649071c1a7160121035d5c93d9ac96881f19ba1f686f15f009ded7c62efe85a872e6a19b43c15a2937',
        radix: 16,
      ),
    );
    final script = ScriptFactory.parseSync(scriptPubKey);

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
}
