import 'dart:collection';
import 'dart:typed_data';

import 'package:dartcoin/src/utils/all.dart';
import 'package:meta/meta.dart';

abstract class ScriptOperation {
  static String itemsArgName = 'items';
  static String stackArgName = 'stack';

  bool execute();
}

typedef ScriptOperationBuilder = ScriptOperation Function({
  @required Map<String, dynamic> args,
});

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

    final args = <String, dynamic>{
      ScriptOperation.itemsArgName: <Object>[],
      ScriptOperation.stackArgName: stack,
    };

    final operation = opCode != null
        ? opCode.builder(args: args)
        : codeToOperation[opCode].builder(args: args);
    final isValidOp = operation.execute();

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
  OP_NOP,
  OP_IF,
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
      case OpCode.OP_NOP:
        return 97;
      case OpCode.OP_IF:
        return 99;
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
      case OpCode.OP_NOP:
        return 'OP_NOP';
      case OpCode.OP_IF:
        return 'OP_IF';
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

  ScriptOperationBuilder get builder {
    switch (this) {
      case OpCode.OP_0:
        return _Op0.builder;
      case OpCode.OP_1NEGATE:
        return _Op1Negate.builder;
      case OpCode.OP_1:
        return _Op1.builder;
      case OpCode.OP_2:
        return _Op2.builder;
      case OpCode.OP_3:
        return _Op3.builder;
      case OpCode.OP_4:
        return _Op4.builder;
      case OpCode.OP_5:
        return _Op5.builder;
      case OpCode.OP_6:
        return _Op6.builder;
      case OpCode.OP_7:
        return _Op7.builder;
      case OpCode.OP_8:
        return _Op8.builder;
      case OpCode.OP_9:
        return _Op9.builder;
      case OpCode.OP_10:
        return _Op10.builder;
      case OpCode.OP_11:
        return _Op11.builder;
      case OpCode.OP_12:
        return _Op12.builder;
      case OpCode.OP_13:
        return _Op13.builder;
      case OpCode.OP_14:
        return _Op14.builder;
      case OpCode.OP_15:
        return _Op15.builder;
      case OpCode.OP_16:
        return _Op16.builder;
      case OpCode.OP_NOP:
        return _OpNop.builder;
      case OpCode.OP_IF:
        return _OpIf.builder;
      case OpCode.OP_DUP:
        return _OpDup.builder;
      case OpCode.OP_HASH160:
        return _OpHash160.builder;
      case OpCode.OP_HASH256:
        return _OpHash256.builder;
      default:
        throw ArgumentError('[OpCode] has no valid builder!');
    }
  }
}

/// Operation called `OP_0` with code `0` or `0x00`.
/// Push into the [stack] the value `0`.
/// This operation is also called `OP_FALSE`.
class _Op0 extends ScriptOperation {
  _Op0({@required this.stack});

  final ListQueue<Uint8List> stack;

  static _Op0 builder({@required Map<String, dynamic> args}) {
    return _Op0(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  @override
  bool execute() {
    stack.add(
      ScriptUtils.encodeNumber(
        number: BigInt.zero,
      ),
    );

    return true;
  }
}

/// Operation called `OP_1NEGATE` with code `79` or `0x4f`.
/// Push into the [stack] the value `-1`.
class _Op1Negate extends ScriptOperation {
  _Op1Negate({@required this.stack});

  final ListQueue<Uint8List> stack;

  static _Op1Negate builder({@required Map<String, dynamic> args}) {
    return _Op1Negate(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  @override
  bool execute() {
    stack.add(
      ScriptUtils.encodeNumber(
        number: BigInt.from(-1),
      ),
    );

    return true;
  }
}

/// Operation called `OP_1` with code `81` or `0x51`.
/// Push into the [stack] the value `1`.
/// This operation is also called `OP_TRUE`.
class _Op1 extends ScriptOperation {
  _Op1({@required this.stack});

  final ListQueue<Uint8List> stack;

  static _Op1 builder({@required Map<String, dynamic> args}) {
    return _Op1(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  @override
  bool execute() {
    stack.add(
      ScriptUtils.encodeNumber(
        number: BigInt.one,
      ),
    );

    return true;
  }
}

/// Operation called `OP_2` with code `82` or `0x52`.
/// Push into the [stack] the value `2`.
class _Op2 extends ScriptOperation {
  _Op2({@required this.stack});

  final ListQueue<Uint8List> stack;

  static _Op2 builder({@required Map<String, dynamic> args}) {
    return _Op2(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  @override
  bool execute() {
    stack.add(
      ScriptUtils.encodeNumber(
        number: BigInt.two,
      ),
    );

    return true;
  }
}

/// Operation called `OP_3` with code `83` or `0x53`.
/// Push into the [stack] the value `3`.
class _Op3 extends ScriptOperation {
  _Op3({@required this.stack});

  final ListQueue<Uint8List> stack;

  static _Op3 builder({@required Map<String, dynamic> args}) {
    return _Op3(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  @override
  bool execute() {
    stack.add(
      ScriptUtils.encodeNumber(
        number: BigInt.from(3),
      ),
    );

    return true;
  }
}

/// Operation called `OP_4` with code `84` or `0x54`.
/// Push into the [stack] the value `4`.
class _Op4 extends ScriptOperation {
  _Op4({@required this.stack});

  final ListQueue<Uint8List> stack;

  static _Op4 builder({@required Map<String, dynamic> args}) {
    return _Op4(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  @override
  bool execute() {
    stack.add(
      ScriptUtils.encodeNumber(
        number: BigInt.from(4),
      ),
    );

    return true;
  }
}

/// Operation called `OP_5` with code `85` or `0x55`.
/// Push into the [stack] the value `5`.
class _Op5 extends ScriptOperation {
  _Op5({@required this.stack});

  final ListQueue<Uint8List> stack;

  static _Op5 builder({@required Map<String, dynamic> args}) {
    return _Op5(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  @override
  bool execute() {
    stack.add(
      ScriptUtils.encodeNumber(
        number: BigInt.from(5),
      ),
    );

    return true;
  }
}

/// Operation called `OP_6` with code `86` or `0x56`.
/// Push into the [stack] the value `6`.
class _Op6 extends ScriptOperation {
  _Op6({@required this.stack});

  final ListQueue<Uint8List> stack;

  static _Op6 builder({@required Map<String, dynamic> args}) {
    return _Op6(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  @override
  bool execute() {
    stack.add(
      ScriptUtils.encodeNumber(
        number: BigInt.from(6),
      ),
    );

    return true;
  }
}

/// Operation called `OP_7` with code `87` or `0x57`.
/// Push into the [stack] the value `7`.
class _Op7 extends ScriptOperation {
  _Op7({@required this.stack});

  final ListQueue<Uint8List> stack;

  static _Op7 builder({@required Map<String, dynamic> args}) {
    return _Op7(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  @override
  bool execute() {
    stack.add(
      ScriptUtils.encodeNumber(
        number: BigInt.from(7),
      ),
    );

    return true;
  }
}

/// Operation called `OP_8` with code `88` or `0x58`.
/// Push into the [stack] the value `8`.
class _Op8 extends ScriptOperation {
  _Op8({@required this.stack});

  final ListQueue<Uint8List> stack;

  static _Op8 builder({@required Map<String, dynamic> args}) {
    return _Op8(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  @override
  bool execute() {
    stack.add(
      ScriptUtils.encodeNumber(
        number: BigInt.from(8),
      ),
    );

    return true;
  }
}

/// Operation called `OP_9` with code `89` or `0x59`.
/// Push into the [stack] the value `9`.
class _Op9 extends ScriptOperation {
  _Op9({@required this.stack});

  final ListQueue<Uint8List> stack;

  static _Op9 builder({@required Map<String, dynamic> args}) {
    return _Op9(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  @override
  bool execute() {
    stack.add(
      ScriptUtils.encodeNumber(
        number: BigInt.from(9),
      ),
    );

    return true;
  }
}

/// Operation called `OP_10` with code `90` or `0x5a`.
/// Push into the [stack] the value `10`.
class _Op10 extends ScriptOperation {
  _Op10({@required this.stack});

  final ListQueue<Uint8List> stack;

  static _Op10 builder({@required Map<String, dynamic> args}) {
    return _Op10(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  @override
  bool execute() {
    stack.add(
      ScriptUtils.encodeNumber(
        number: BigInt.from(10),
      ),
    );

    return true;
  }
}

/// Operation called `OP_11` with code `91` or `0x5b`.
/// Push into the [stack] the value `11`.
class _Op11 extends ScriptOperation {
  _Op11({@required this.stack});

  final ListQueue<Uint8List> stack;

  static _Op11 builder({@required Map<String, dynamic> args}) {
    return _Op11(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  @override
  bool execute() {
    stack.add(
      ScriptUtils.encodeNumber(
        number: BigInt.from(11),
      ),
    );

    return true;
  }
}

/// Operation called `OP_12` with code `92` or `0x5c`.
/// Push into the [stack] the value `12`.
class _Op12 extends ScriptOperation {
  _Op12({@required this.stack});

  final ListQueue<Uint8List> stack;

  static _Op12 builder({@required Map<String, dynamic> args}) {
    return _Op12(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  @override
  bool execute() {
    stack.add(
      ScriptUtils.encodeNumber(
        number: BigInt.from(12),
      ),
    );

    return true;
  }
}

/// Operation called `OP_13` with code `93` or `0x5d`.
/// Push into the [stack] the value `13`.
class _Op13 extends ScriptOperation {
  _Op13({@required this.stack});

  final ListQueue<Uint8List> stack;

  static _Op13 builder({@required Map<String, dynamic> args}) {
    return _Op13(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  @override
  bool execute() {
    stack.add(
      ScriptUtils.encodeNumber(
        number: BigInt.from(13),
      ),
    );

    return true;
  }
}

/// Operation called `OP_14` with code `94` or `0x5e`.
/// Push into the [stack] the value `14`.
class _Op14 extends ScriptOperation {
  _Op14({@required this.stack});

  final ListQueue<Uint8List> stack;

  static _Op14 builder({@required Map<String, dynamic> args}) {
    return _Op14(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  @override
  bool execute() {
    stack.add(
      ScriptUtils.encodeNumber(
        number: BigInt.from(14),
      ),
    );

    return true;
  }
}

/// Operation called `OP_15` with code `95` or `0x5f`.
/// Push into the [stack] the value `15`.
class _Op15 extends ScriptOperation {
  _Op15({@required this.stack});

  final ListQueue<Uint8List> stack;

  static _Op15 builder({@required Map<String, dynamic> args}) {
    return _Op15(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  @override
  bool execute() {
    stack.add(
      ScriptUtils.encodeNumber(
        number: BigInt.from(15),
      ),
    );

    return true;
  }
}

/// Operation called `OP_16` with code `96` or `0x60`.
/// Push into the [stack] the value `16`.
class _Op16 extends ScriptOperation {
  _Op16({@required this.stack});

  final ListQueue<Uint8List> stack;

  static _Op16 builder({@required Map<String, dynamic> args}) {
    return _Op16(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  @override
  bool execute() {
    stack.add(
      ScriptUtils.encodeNumber(
        number: BigInt.from(16),
      ),
    );

    return true;
  }
}

/// Operation called `OP_NOP` with code `97` or `0x61`.
/// Does nothing.
class _OpNop extends ScriptOperation {
  _OpNop();

  static _OpNop builder({@required Map<String, dynamic> args}) {
    assert(args != null);
    return _OpNop();
  }

  @override
  bool execute() {
    return true;
  }
}

/// Operation called `OP_IF` with code `99` or `0x63`.
/// Gets the statements to be executed depending on the evaluation
/// of the top stack element.
class _OpIf extends ScriptOperation {
  _OpIf({
    @required this.items,
    @required this.stack,
  });

  final ListQueue<Object> items;
  final ListQueue<Uint8List> stack;

  static _OpIf builder({@required Map<String, dynamic> args}) {
    return _OpIf(
      items: args[ScriptOperation.itemsArgName],
      stack: args[ScriptOperation.stackArgName],
    );
  }

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.isNotEmpty) {
      final whenEvalTrue = <Object>[];
      final whenEvalFalse = <Object>[];

      var currentPath = whenEvalTrue;

      var isValidOnParse = false;
      var endifsNeeded = 1;

      while (items.isNotEmpty) {
        final item = items.removeLast();

        if (item == 99 || item == 100) {
          currentPath.add(item);
          endifsNeeded++;
        } else if (endifsNeeded == 1 && item == 103) {
          currentPath = whenEvalFalse;
        } else if (item == 104) {
          if (endifsNeeded == 1) {
            isValidOnParse = true;
            break;
          }
          currentPath.add(item);
          endifsNeeded--;
        } else {
          currentPath.add(item);
        }
      }

      if (isValidOnParse) {
        final element = stack.removeLast();
        if (ScriptUtils.decodeNumber(element: element) == BigInt.zero) {
          whenEvalFalse.reversed.forEach(
            (item) => items.addFirst(item),
          );
        } else {
          whenEvalTrue.reversed.forEach(
            (item) => items.addFirst(item),
          );
        }

        isValidOp = true;
      }
    }

    return isValidOp;
  }
}

/// Operation called `OP_DUP` with code `118` or `0x76`.
/// Get the top element in the [stack] (without removing it),
/// duplicate it and pushes the result into the [stack].
class _OpDup extends ScriptOperation {
  _OpDup({@required this.stack});

  static _OpDup builder({@required Map<String, dynamic> args}) {
    return _OpDup(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.isNotEmpty) {
      stack.add(stack.last);

      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_HASH160` with code `169` or `0xa9`.
/// Remove the top element of the [stack], perform a [Secp256Utils.hash160]
/// to it and push back the result into the [stack].
class _OpHash160 extends ScriptOperation {
  _OpHash160({@required this.stack});

  static _OpHash160 builder({@required Map<String, dynamic> args}) {
    return _OpHash160(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.isNotEmpty) {
      final element = stack.removeLast();
      stack.add(Secp256Utils.hash160(data: element));

      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_HASH256` with code `170` or `0xaa`.
/// Remove the top element of the [stack], perform a [Secp256Utils.hash256]
/// to it and push back the result into the [stack].
class _OpHash256 extends ScriptOperation {
  _OpHash256({@required this.stack});

  static _OpHash256 builder({@required Map<String, dynamic> args}) {
    return _OpHash256(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.isNotEmpty) {
      final element = stack.removeLast();
      stack.add(Secp256Utils.hash256(data: element));

      isValidOp = true;
    }

    return isValidOp;
  }
}
