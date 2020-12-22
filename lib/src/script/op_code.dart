import 'dart:collection';
import 'dart:typed_data';

import 'package:dartcoin/src/utils/all.dart';

typedef ScriptOperation = bool Function(ListQueue<Uint8List> stack);

class OpCode {
  static Map<int, ScriptOperation> functions = {
    118: _op_dup,
    170: _op_hash256,
  };

  /// Operation called `OP_DUP` with code `118` or `0x76`.
  /// Get the top element in the [stack] (without removing it),
  /// duplicate it and pushes the result into the [stack].
  static bool _op_dup(ListQueue<Uint8List> stack) {
    var isValidOp = false;

    if (stack.isNotEmpty) {
      stack.add(stack.last);

      isValidOp = true;
    }

    return isValidOp;
  }

  /// Operation called `OP_HASH256` with code `170` or `0xAA`.
  /// Remove the top element of the [stack], perform a [Secp256Utils.hash256]
  /// to it and push back the result into the [stack].
  static bool _op_hash256(ListQueue<Uint8List> stack) {
    var isValidOp = false;

    if (stack.isNotEmpty) {
      final element = stack.removeLast();
      stack.add(Secp256Utils.hash256(data: element));

      isValidOp = true;
    }

    return isValidOp;
  }
}
