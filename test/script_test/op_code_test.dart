import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dartcoin/src/script/all.dart';
import 'package:dartcoin/src/utils/all.dart';
import 'package:test/test.dart';

/// Each test is based on https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch06/op.py#L721
void main() {
  test('test_op_hash160', () {
    final executor = ScriptExecutor();

    final message = Uint8List.fromList(
      utf8.encode('hello world'),
    );
    final stack = ListQueue<Uint8List>.from([message]);

    final isValidOp = executor.run(
      opCode: OpCode.OP_HASH160,
      stack: stack,
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
}
