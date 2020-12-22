import 'dart:collection';
import 'dart:typed_data';

import 'package:dartcoin/src/utils/all.dart';
import 'package:meta/meta.dart';

typedef ScriptOperation = bool Function(ListQueue<Uint8List> stack);

class ScriptExecutor {
  ScriptExecutor()
      : codeToOperation = Map.fromEntries(
          OpCode.values.map(
            (op) => MapEntry(op.byte, op),
          ),
        );

  final Map<int, OpCode> codeToOperation;

  bool run({
    int opCodeAsByte,
    OpCode opCode,
    @required ListQueue<Uint8List> stack,
  }) {
    if (opCodeAsByte == null && opCode == null) {
      throw ArgumentError(
        'It is necessary to pass as argument at least one of this options: [opCodeAsByte] or [opCode]',
      );
    }

    final operation =
        opCode != null ? opCode.function : codeToOperation[opCode].function;
    final isValidOp = operation(stack);

    return isValidOp;
  }
}

enum OpCode {
  OP_0,
  OP_1NEGATE,
  OP_DUP,
  OP_HASH160,
  OP_HASH256,
}

extension Info on OpCode {
  int get byte {
    switch (this) {
      case OpCode.OP_0:
        return 0;
      case OpCode.OP_1NEGATE:
        return 79;
      case OpCode.OP_DUP:
        return 118;
      case OpCode.OP_HASH160:
        return 169;
      case OpCode.OP_HASH256:
        return 170;
      default:
        throw ArgumentError('[OpCode] has no valid code!');
    }
  }

  String get name {
    switch (this) {
      case OpCode.OP_0:
        return 'OP_0';
      case OpCode.OP_1NEGATE:
        return 'OP_1NEGATE';
      case OpCode.OP_DUP:
        return 'OP_DUP';
      case OpCode.OP_HASH160:
        return 'OP_HASH160';
      case OpCode.OP_HASH256:
        return 'OP_HASH256';
      default:
        throw ArgumentError('[OpCode] has no valid name!');
    }
  }

  ScriptOperation get function {
    switch (this) {
      case OpCode.OP_0:
        return _op_0;
      case OpCode.OP_1NEGATE:
        return _op_1Negate;
      case OpCode.OP_DUP:
        return _op_dup;
      case OpCode.OP_HASH160:
        return _op_hash160;
      case OpCode.OP_HASH256:
        return _op_hash256;
      default:
        throw ArgumentError('[OpCode] has no valid name!');
    }
  }
}

/// Operation called `OP_0` with code `0` or `0x00`.
/// Push into the [stack] the value `0`.
bool _op_0(ListQueue<Uint8List> stack) {
  stack.add(
    ScriptUtils.encodeNumber(
      number: BigInt.zero,
    ),
  );

  return true;
}

/// Operation called `OP_1NEGATE` with code `79` or `0x4f`.
/// Push into the [stack] the value `-1`.
bool _op_1Negate(ListQueue<Uint8List> stack) {
  stack.add(
    ScriptUtils.encodeNumber(
      number: BigInt.from(-1),
    ),
  );

  return true;
}

/// Operation called `OP_DUP` with code `118` or `0x76`.
/// Get the top element in the [stack] (without removing it),
/// duplicate it and pushes the result into the [stack].
bool _op_dup(ListQueue<Uint8List> stack) {
  var isValidOp = false;

  if (stack.isNotEmpty) {
    stack.add(stack.last);

    isValidOp = true;
  }

  return isValidOp;
}

/// Operation called `OP_HASH160` with code `169` or `0xa9`.
/// Remove the top element of the [stack], perform a [Secp256Utils.hash160]
/// to it and push back the result into the [stack].
bool _op_hash160(ListQueue<Uint8List> stack) {
  var isValidOp = false;

  if (stack.isNotEmpty) {
    final element = stack.removeLast();
    stack.add(Secp256Utils.hash160(data: element));

    isValidOp = true;
  }

  return isValidOp;
}

/// Operation called `OP_HASH256` with code `170` or `0xaa`.
/// Remove the top element of the [stack], perform a [Secp256Utils.hash256]
/// to it and push back the result into the [stack].
bool _op_hash256(ListQueue<Uint8List> stack) {
  var isValidOp = false;

  if (stack.isNotEmpty) {
    final element = stack.removeLast();
    stack.add(Secp256Utils.hash256(data: element));

    isValidOp = true;
  }

  return isValidOp;
}
