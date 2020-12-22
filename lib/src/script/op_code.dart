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
  OP_1,
  OP_2,
  OP_3,
  OP_4,
  OP_5,
  OP_6,
  OP_7,
  OP_8,
  OP_9,
  OP_10,
  OP_11,
  OP_12,
  OP_13,
  OP_14,
  OP_15,
  OP_16,
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
      case OpCode.OP_1:
        return 81;
      case OpCode.OP_2:
        return 82;
      case OpCode.OP_3:
        return 83;
      case OpCode.OP_4:
        return 84;
      case OpCode.OP_5:
        return 85;
      case OpCode.OP_6:
        return 86;
      case OpCode.OP_7:
        return 87;
      case OpCode.OP_8:
        return 88;
      case OpCode.OP_9:
        return 89;
      case OpCode.OP_10:
        return 90;
      case OpCode.OP_11:
        return 91;
      case OpCode.OP_12:
        return 92;
      case OpCode.OP_13:
        return 93;
      case OpCode.OP_14:
        return 94;
      case OpCode.OP_15:
        return 95;
      case OpCode.OP_16:
        return 96;
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
      case OpCode.OP_1:
        return 'OP_1';
      case OpCode.OP_2:
        return 'OP_2';
      case OpCode.OP_3:
        return 'OP_3';
      case OpCode.OP_4:
        return 'OP_4';
      case OpCode.OP_5:
        return 'OP_5';
      case OpCode.OP_6:
        return 'OP_6';
      case OpCode.OP_7:
        return 'OP_7';
      case OpCode.OP_8:
        return 'OP_8';
      case OpCode.OP_9:
        return 'OP_9';
      case OpCode.OP_10:
        return 'OP_10';
      case OpCode.OP_11:
        return 'OP_11';
      case OpCode.OP_12:
        return 'OP_12';
      case OpCode.OP_13:
        return 'OP_13';
      case OpCode.OP_14:
        return 'OP_14';
      case OpCode.OP_15:
        return 'OP_15';
      case OpCode.OP_16:
        return 'OP_16';
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
      case OpCode.OP_1:
        return _op_1;
      case OpCode.OP_2:
        return _op_2;
      case OpCode.OP_3:
        return _op_3;
      case OpCode.OP_4:
        return _op_4;
      case OpCode.OP_5:
        return _op_5;
      case OpCode.OP_6:
        return _op_6;
      case OpCode.OP_7:
        return _op_7;
      case OpCode.OP_8:
        return _op_8;
      case OpCode.OP_9:
        return _op_9;
      case OpCode.OP_10:
        return _op_10;
      case OpCode.OP_11:
        return _op_11;
      case OpCode.OP_12:
        return _op_12;
      case OpCode.OP_13:
        return _op_13;
      case OpCode.OP_14:
        return _op_14;
      case OpCode.OP_15:
        return _op_15;
      case OpCode.OP_16:
        return _op_16;
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
/// This operation is also called `OP_FALSE`.
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

/// Operation called `OP_1` with code `81` or `0x51`.
/// Push into the [stack] the value `1`.
/// This operation is also called `OP_TRUE`.
bool _op_1(ListQueue<Uint8List> stack) {
  stack.add(
    ScriptUtils.encodeNumber(
      number: BigInt.one,
    ),
  );

  return true;
}

/// Operation called `OP_2` with code `82` or `0x52`.
/// Push into the [stack] the value `2`.
bool _op_2(ListQueue<Uint8List> stack) {
  stack.add(
    ScriptUtils.encodeNumber(
      number: BigInt.two,
    ),
  );

  return true;
}

/// Operation called `OP_3` with code `83` or `0x53`.
/// Push into the [stack] the value `3`.
bool _op_3(ListQueue<Uint8List> stack) {
  stack.add(
    ScriptUtils.encodeNumber(
      number: BigInt.from(3),
    ),
  );

  return true;
}

/// Operation called `OP_4` with code `84` or `0x54`.
/// Push into the [stack] the value `4`.
bool _op_4(ListQueue<Uint8List> stack) {
  stack.add(
    ScriptUtils.encodeNumber(
      number: BigInt.from(4),
    ),
  );

  return true;
}

/// Operation called `OP_5` with code `85` or `0x55`.
/// Push into the [stack] the value `5`.
bool _op_5(ListQueue<Uint8List> stack) {
  stack.add(
    ScriptUtils.encodeNumber(
      number: BigInt.from(5),
    ),
  );

  return true;
}

/// Operation called `OP_6` with code `86` or `0x56`.
/// Push into the [stack] the value `6`.
bool _op_6(ListQueue<Uint8List> stack) {
  stack.add(
    ScriptUtils.encodeNumber(
      number: BigInt.from(6),
    ),
  );

  return true;
}

/// Operation called `OP_7` with code `87` or `0x57`.
/// Push into the [stack] the value `7`.
bool _op_7(ListQueue<Uint8List> stack) {
  stack.add(
    ScriptUtils.encodeNumber(
      number: BigInt.from(7),
    ),
  );

  return true;
}

/// Operation called `OP_8` with code `88` or `0x58`.
/// Push into the [stack] the value `8`.
bool _op_8(ListQueue<Uint8List> stack) {
  stack.add(
    ScriptUtils.encodeNumber(
      number: BigInt.from(8),
    ),
  );

  return true;
}

/// Operation called `OP_9` with code `89` or `0x59`.
/// Push into the [stack] the value `9`.
bool _op_9(ListQueue<Uint8List> stack) {
  stack.add(
    ScriptUtils.encodeNumber(
      number: BigInt.from(9),
    ),
  );

  return true;
}

/// Operation called `OP_10` with code `90` or `0x5a`.
/// Push into the [stack] the value `10`.
bool _op_10(ListQueue<Uint8List> stack) {
  stack.add(
    ScriptUtils.encodeNumber(
      number: BigInt.from(10),
    ),
  );

  return true;
}

/// Operation called `OP_11` with code `91` or `0x5b`.
/// Push into the [stack] the value `11`.
bool _op_11(ListQueue<Uint8List> stack) {
  stack.add(
    ScriptUtils.encodeNumber(
      number: BigInt.from(11),
    ),
  );

  return true;
}

/// Operation called `OP_12` with code `92` or `0x5c`.
/// Push into the [stack] the value `12`.
bool _op_12(ListQueue<Uint8List> stack) {
  stack.add(
    ScriptUtils.encodeNumber(
      number: BigInt.from(12),
    ),
  );

  return true;
}

/// Operation called `OP_13` with code `93` or `0x5d`.
/// Push into the [stack] the value `13`.
bool _op_13(ListQueue<Uint8List> stack) {
  stack.add(
    ScriptUtils.encodeNumber(
      number: BigInt.from(13),
    ),
  );

  return true;
}

/// Operation called `OP_14` with code `94` or `0x5e`.
/// Push into the [stack] the value `14`.
bool _op_14(ListQueue<Uint8List> stack) {
  stack.add(
    ScriptUtils.encodeNumber(
      number: BigInt.from(14),
    ),
  );

  return true;
}

/// Operation called `OP_15` with code `95` or `0x5f`.
/// Push into the [stack] the value `15`.
bool _op_15(ListQueue<Uint8List> stack) {
  stack.add(
    ScriptUtils.encodeNumber(
      number: BigInt.from(15),
    ),
  );

  return true;
}

/// Operation called `OP_16` with code `96` or `0x60`.
/// Push into the [stack] the value `16`.
bool _op_16(ListQueue<Uint8List> stack) {
  stack.add(
    ScriptUtils.encodeNumber(
      number: BigInt.from(16),
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
