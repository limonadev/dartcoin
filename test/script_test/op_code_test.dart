import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dartcoin/src/script/all.dart';
import 'package:dartcoin/src/utils/all.dart';
import 'package:test/test.dart';

/// Each test is based on https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch06/op.py#L721
void main() {
  test('test_op_hash160', () {
    final message = Uint8List.fromList(
      utf8.encode('hello world'),
    );
    final stack = ListQueue<Uint8List>.from([message]);

    final executor = ScriptOperationExecutor(
      stack: stack,
    );

    final isValidOp = executor.run(
      opCode: OpCode.OP_HASH160,
    );

    expect(
      isValidOp,
      equals(true),
    );
    expect(
      ObjectUtils.bytesToHex(
        bytes: stack.first,
      ),
      equals('d7d5ee7824ff93f94c3055af9382c86c68b5ca92'),
    );
  });

  test('test_op_checksig', () {
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

    final stack = ListQueue<Uint8List>.from([der, sec]);
    final executor = ScriptOperationExecutor(
      stack: stack,
    );

    final isValidOp = executor.run(
      message: message,
      opCode: OpCode.OP_CHECKSIG,
    );

    expect(
      isValidOp,
      equals(true),
    );
    expect(
      ScriptUtils.decodeNumber(
        element: stack.last,
      ),
      equals(BigInt.one),
    );
  });
}
