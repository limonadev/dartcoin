import 'dart:collection';
import 'dart:typed_data';

import 'package:dartcoin/src/utils/all.dart';
import 'package:meta/meta.dart';

abstract class ScriptOperation {
  static String altStackArgName = 'altStack';
  static String itemsArgName = 'items';
  static String stackArgName = 'stack';

  Uint8List copy({@required Uint8List element}) {
    return Uint8List.fromList(element);
  }

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
      ScriptOperation.altStackArgName: ListQueue<Uint8List>(),
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

/// All the supported Bitcoin Script operations.
/// The `OP_MUL` is used here: https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch06/op.py#L476
/// but now that operation is disabled. For that reason, the `OP_MUL`
/// is not supported.
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
  OP_NOTIF,
  OP_VERIFY,
  OP_RETURN,
  OP_TOALTSTACK,
  OP_FROMALTSTACK,
  OP_2DROP,
  OP_2DUP,
  OP_3DUP,
  OP_2OVER,
  OP_2ROT,
  OP_2SWAP,
  OP_IFDUP,
  OP_DEPTH,
  OP_DROP,
  OP_DUP,
  OP_NIP,
  OP_OVER,
  OP_PICK,
  OP_ROLL,
  OP_ROT,
  OP_SWAP,
  OP_TUCK,
  OP_SIZE,
  OP_EQUAL,
  OP_EQUALVERIFY,
  OP_1ADD,
  OP_1SUB,
  OP_NEGATE,
  OP_ABS,
  OP_NOT,
  OP_0NOTEQUAL,
  OP_ADD,
  OP_SUB,
  OP_BOOLAND,
  OP_BOOLOR,
  OP_NUMEQUAL,
  OP_NUMEQUALVERIFY,
  OP_NUMNOTEQUAL,
  OP_LESSTHAN,
  OP_GREATERTHAN,
  OP_LESSTHANOREQUAL,
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
      case OpCode.OP_NOTIF:
        return 100;
      case OpCode.OP_VERIFY:
        return 105;
      case OpCode.OP_RETURN:
        return 106;
      case OpCode.OP_TOALTSTACK:
        return 107;
      case OpCode.OP_FROMALTSTACK:
        return 108;
      case OpCode.OP_2DROP:
        return 109;
      case OpCode.OP_2DUP:
        return 110;
      case OpCode.OP_3DUP:
        return 111;
      case OpCode.OP_2OVER:
        return 112;
      case OpCode.OP_2ROT:
        return 113;
      case OpCode.OP_2SWAP:
        return 114;
      case OpCode.OP_IFDUP:
        return 115;
      case OpCode.OP_DEPTH:
        return 116;
      case OpCode.OP_DROP:
        return 117;
      case OpCode.OP_DUP:
        return 118;
      case OpCode.OP_NIP:
        return 119;
      case OpCode.OP_OVER:
        return 120;
      case OpCode.OP_PICK:
        return 121;
      case OpCode.OP_ROLL:
        return 122;
      case OpCode.OP_ROT:
        return 123;
      case OpCode.OP_SWAP:
        return 124;
      case OpCode.OP_TUCK:
        return 125;
      case OpCode.OP_SIZE:
        return 130;
      case OpCode.OP_EQUAL:
        return 135;
      case OpCode.OP_EQUALVERIFY:
        return 136;
      case OpCode.OP_1ADD:
        return 139;
      case OpCode.OP_1SUB:
        return 140;
      case OpCode.OP_NEGATE:
        return 143;
      case OpCode.OP_ABS:
        return 144;
      case OpCode.OP_NOT:
        return 145;
      case OpCode.OP_0NOTEQUAL:
        return 146;
      case OpCode.OP_ADD:
        return 147;
      case OpCode.OP_SUB:
        return 148;
      case OpCode.OP_BOOLAND:
        return 154;
      case OpCode.OP_BOOLOR:
        return 155;
      case OpCode.OP_NUMEQUAL:
        return 156;
      case OpCode.OP_NUMEQUALVERIFY:
        return 157;
      case OpCode.OP_NUMNOTEQUAL:
        return 158;
      case OpCode.OP_LESSTHAN:
        return 159;
      case OpCode.OP_GREATERTHAN:
        return 160;
      case OpCode.OP_LESSTHANOREQUAL:
        return 161;
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
      case OpCode.OP_NOTIF:
        return 'OP_NOTIF';
      case OpCode.OP_VERIFY:
        return 'OP_VERIFY';
      case OpCode.OP_RETURN:
        return 'OP_RETURN';
      case OpCode.OP_TOALTSTACK:
        return 'OP_TOALTSTACK';
      case OpCode.OP_FROMALTSTACK:
        return 'OP_FROMALTSTACK';
      case OpCode.OP_2DROP:
        return 'OP_2DROP';
      case OpCode.OP_2DUP:
        return 'OP_2DUP';
      case OpCode.OP_3DUP:
        return 'OP_3DUP';
      case OpCode.OP_2OVER:
        return 'OP_2OVER';
      case OpCode.OP_2ROT:
        return 'OP_2ROT';
      case OpCode.OP_2SWAP:
        return 'OP_2SWAP';
      case OpCode.OP_IFDUP:
        return 'OP_IFDUP';
      case OpCode.OP_DEPTH:
        return 'OP_DEPTH';
      case OpCode.OP_DROP:
        return 'OP_DROP';
      case OpCode.OP_DUP:
        return 'OP_DUP';
      case OpCode.OP_NIP:
        return 'OP_NIP';
      case OpCode.OP_OVER:
        return 'OP_OVER';
      case OpCode.OP_PICK:
        return 'OP_PICK';
      case OpCode.OP_ROLL:
        return 'OP_ROLL';
      case OpCode.OP_ROT:
        return 'OP_ROT';
      case OpCode.OP_SWAP:
        return 'OP_SWAP';
      case OpCode.OP_TUCK:
        return 'OP_TUCK';
      case OpCode.OP_SIZE:
        return 'OP_SIZE';
      case OpCode.OP_EQUAL:
        return 'OP_EQUAL';
      case OpCode.OP_EQUALVERIFY:
        return 'OP_EQUALVERIFY';
      case OpCode.OP_1ADD:
        return 'OP_1ADD';
      case OpCode.OP_1SUB:
        return 'OP_1SUB';
      case OpCode.OP_NEGATE:
        return 'OP_NEGATE';
      case OpCode.OP_ABS:
        return 'OP_ABS';
      case OpCode.OP_NOT:
        return 'OP_NOT';
      case OpCode.OP_0NOTEQUAL:
        return 'OP_0NOTEQUAL';
      case OpCode.OP_ADD:
        return 'OP_ADD';
      case OpCode.OP_SUB:
        return 'OP_SUB';
      case OpCode.OP_BOOLAND:
        return 'OP_BOOLAND';
      case OpCode.OP_BOOLOR:
        return 'OP_BOOLOR';
      case OpCode.OP_NUMEQUAL:
        return 'OP_NUMEQUAL';
      case OpCode.OP_NUMEQUALVERIFY:
        return 'OP_NUMEQUALVERIFY';
      case OpCode.OP_NUMNOTEQUAL:
        return 'OP_NUMNOTEQUAL';
      case OpCode.OP_LESSTHAN:
        return 'OP_LESSTHAN';
      case OpCode.OP_GREATERTHAN:
        return 'OP_GREATHERTHAN';
      case OpCode.OP_LESSTHANOREQUAL:
        return 'OP_LESSTHANOREQUAL';
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
      case OpCode.OP_NOTIF:
        return _OpNotIf.builder;
      case OpCode.OP_VERIFY:
        return _OpVerify.builder;
      case OpCode.OP_RETURN:
        return _OpReturn.builder;
      case OpCode.OP_TOALTSTACK:
        return _OpToAltStack.builder;
      case OpCode.OP_FROMALTSTACK:
        return _OpFromAltStack.builder;
      case OpCode.OP_2DROP:
        return _Op2Drop.builder;
      case OpCode.OP_2DUP:
        return _Op2Dup.builder;
      case OpCode.OP_3DUP:
        return _Op3Dup.builder;
      case OpCode.OP_2OVER:
        return _Op2Over.builder;
      case OpCode.OP_2ROT:
        return _Op2Rot.builder;
      case OpCode.OP_2SWAP:
        return _Op2Swap.builder;
      case OpCode.OP_IFDUP:
        return _OpIfDup.builder;
      case OpCode.OP_DEPTH:
        return _OpDepth.builder;
      case OpCode.OP_DROP:
        return _OpDrop.builder;
      case OpCode.OP_DUP:
        return _OpDup.builder;
      case OpCode.OP_NIP:
        return _OpNip.builder;
      case OpCode.OP_OVER:
        return _OpOver.builder;
      case OpCode.OP_PICK:
        return _OpPick.builder;
      case OpCode.OP_ROLL:
        return _OpRoll.builder;
      case OpCode.OP_ROT:
        return _OpRot.builder;
      case OpCode.OP_SWAP:
        return _OpSwap.builder;
      case OpCode.OP_TUCK:
        return _OpTuck.builder;
      case OpCode.OP_SIZE:
        return _OpSize.builder;
      case OpCode.OP_EQUAL:
        return _OpEqual.builder;
      case OpCode.OP_EQUALVERIFY:
        return _OpEqualVerify.builder;
      case OpCode.OP_1ADD:
        return _Op1Add.builder;
      case OpCode.OP_1SUB:
        return _Op1Sub.builder;
      case OpCode.OP_NEGATE:
        return _OpNegate.builder;
      case OpCode.OP_ABS:
        return _OpAbs.builder;
      case OpCode.OP_NOT:
        return _OpNot.builder;
      case OpCode.OP_0NOTEQUAL:
        return _Op0NotEqual.builder;
      case OpCode.OP_ADD:
        return _OpAdd.builder;
      case OpCode.OP_SUB:
        return _OpSub.builder;
      case OpCode.OP_BOOLAND:
        return _OpBoolAnd.builder;
      case OpCode.OP_BOOLOR:
        return _OpBoolOr.builder;
      case OpCode.OP_NUMEQUAL:
        return _OpNumEqual.builder;
      case OpCode.OP_NUMEQUALVERIFY:
        return _OpNumEqualVerify.builder;
      case OpCode.OP_NUMNOTEQUAL:
        return _OpNumNotEqual.builder;
      case OpCode.OP_LESSTHAN:
        return _OpLessThan.builder;
      case OpCode.OP_GREATERTHAN:
        return _OpGreaterThan.builder;
      case OpCode.OP_LESSTHANOREQUAL:
        return _OpLessThanOrEqual.builder;
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

/// Operation called `OP_NOTIF` with code `100` or `0x64`.
/// Gets the statements to be executed depending on the evaluation
/// of the top stack element.
class _OpNotIf extends ScriptOperation {
  _OpNotIf({
    @required this.items,
    @required this.stack,
  });

  final ListQueue<Object> items;
  final ListQueue<Uint8List> stack;

  static _OpNotIf builder({@required Map<String, dynamic> args}) {
    return _OpNotIf(
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
          whenEvalTrue.reversed.forEach(
            (item) => items.addFirst(item),
          );
        } else {
          whenEvalFalse.reversed.forEach(
            (item) => items.addFirst(item),
          );
        }

        isValidOp = true;
      }
    }

    return isValidOp;
  }
}

/// Operation called `OP_VERIFY` with code `105` or `0x69`.
/// Checks if the transaction is valid (if the top stack element is true)
/// and returns if is valid or not.
class _OpVerify extends ScriptOperation {
  _OpVerify({@required this.stack});

  static _OpVerify builder({@required Map<String, dynamic> args}) {
    return _OpVerify(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.isNotEmpty) {
      isValidOp = ScriptUtils.decodeNumber(
            element: stack.removeLast(),
          ) !=
          BigInt.zero;
    }

    return isValidOp;
  }
}

/// Operation called `OP_RETURN` with code `106` or `0x6a`.
/// Marks transaction as invalid.
class _OpReturn extends ScriptOperation {
  _OpReturn();

  static _OpReturn builder({@required Map<String, dynamic> args}) {
    assert(args != null);
    return _OpReturn();
  }

  @override
  bool execute() {
    return false;
  }
}

/// Operation called `OP_TOALTSTACK` with code `107` or `0x6b`.
/// Removes the top [stack] element and puts it in the [altStack].
class _OpToAltStack extends ScriptOperation {
  _OpToAltStack({
    @required this.altStack,
    @required this.stack,
  });

  static _OpToAltStack builder({@required Map<String, dynamic> args}) {
    return _OpToAltStack(
      altStack: args[ScriptOperation.altStackArgName],
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> altStack;
  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.isNotEmpty) {
      altStack.add(stack.removeLast());
      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_FROMALTSTACK` with code `108` or `0x6c`.
/// Removes the top [altStack] element and puts it in the [stack].
class _OpFromAltStack extends ScriptOperation {
  _OpFromAltStack({
    @required this.altStack,
    @required this.stack,
  });

  static _OpFromAltStack builder({@required Map<String, dynamic> args}) {
    return _OpFromAltStack(
      altStack: args[ScriptOperation.altStackArgName],
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> altStack;
  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.isNotEmpty) {
      stack.add(altStack.removeLast());
      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_2DROP` with code `109` or `0x6d`.
/// Removes the two top [stack] elements.
class _Op2Drop extends ScriptOperation {
  _Op2Drop({@required this.stack});

  static _Op2Drop builder({@required Map<String, dynamic> args}) {
    return _Op2Drop(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.length >= 2) {
      stack.removeLast();
      stack.removeLast();
      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_2DUP` with code `110` or `0x6e`.
/// Duplicates the two top [stack] elements (without removing them) and
/// puts the duplicates into the [stack].
class _Op2Dup extends ScriptOperation {
  _Op2Dup({@required this.stack});

  static _Op2Dup builder({@required Map<String, dynamic> args}) {
    return _Op2Dup(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.length >= 2) {
      final last = stack.last;
      final secondLast = stack.elementAt(stack.length - 2);

      stack.add(
        copy(element: secondLast),
      );
      stack.add(
        copy(element: last),
      );

      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_3DUP` with code `111` or `0x6f`.
/// Duplicates the three top [stack] elements (without removing them) and
/// puts the duplicates into the [stack].
class _Op3Dup extends ScriptOperation {
  _Op3Dup({@required this.stack});

  static _Op3Dup builder({@required Map<String, dynamic> args}) {
    return _Op3Dup(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.length >= 3) {
      final temp = <Uint8List>[];
      final duplicates = <Uint8List>[];
      for (var i = 0; i < 3; i++) {
        temp.insert(
          0,
          stack.removeLast(),
        );
        duplicates.insert(
          0,
          copy(element: temp.first),
        );
      }

      stack.addAll(temp);
      stack.addAll(duplicates);

      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_2OVER` with code `112` or `0x70`.
/// Duplicates the third last and fourth last [stack] elements to the top
/// of the [stack].
class _Op2Over extends ScriptOperation {
  _Op2Over({@required this.stack});

  static _Op2Over builder({@required Map<String, dynamic> args}) {
    return _Op2Over(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.length >= 4) {
      var temp = <Uint8List>[];
      for (var _ = 0; _ < 4; _++) {
        temp.insert(
          0,
          stack.removeLast(),
        );
      }

      final duplicates = temp
          .sublist(0, 2)
          .map(
            (d) => copy(
              element: d,
            ),
          )
          .toList();

      stack.addAll(temp);
      stack.addAll(duplicates);

      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_2ROT` with code `113` or `0x71`.
/// Moves the fifth last and sixth last [stack] elements to the top
/// of the [stack].
class _Op2Rot extends ScriptOperation {
  _Op2Rot({@required this.stack});

  static _Op2Rot builder({@required Map<String, dynamic> args}) {
    return _Op2Rot(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.length >= 6) {
      var temp = <Uint8List>[];
      for (var _ = 0; _ < 6; _++) {
        temp.insert(
          0,
          stack.removeLast(),
        );
      }
      temp.add(temp.removeAt(0));
      temp.add(temp.removeAt(0));

      stack.addAll(temp);

      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_2SWAP` with code `114` or `0x72`.
/// Swaps the top [stack] two pairs of elements.
class _Op2Swap extends ScriptOperation {
  _Op2Swap({@required this.stack});

  static _Op2Swap builder({@required Map<String, dynamic> args}) {
    return _Op2Swap(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.length >= 4) {
      var temp = <Uint8List>[];
      for (var _ = 0; _ < 4; _++) {
        temp.insert(
          0,
          stack.removeLast(),
        );
      }
      stack.addAll(temp.sublist(2, 4));
      stack.addAll(temp.sublist(0, 2));

      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_IFDUP` with code `115` or `0x73`.
/// If the top [stack] element is not `0`, adds a duplicate of it
/// to the [stack].
class _OpIfDup extends ScriptOperation {
  _OpIfDup({@required this.stack});

  static _OpIfDup builder({@required Map<String, dynamic> args}) {
    return _OpIfDup(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.isNotEmpty) {
      if (ScriptUtils.decodeNumber(element: stack.last) != BigInt.zero) {
        stack.add(
          copy(element: stack.last),
        );
      }

      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_DEPTH` with code `116` or `0x74`.
/// Adds the length of the [stack] as a new element.
class _OpDepth extends ScriptOperation {
  _OpDepth({@required this.stack});

  static _OpDepth builder({@required Map<String, dynamic> args}) {
    return _OpDepth(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    stack.add(
      ScriptUtils.encodeNumber(
        number: BigInt.from(
          stack.length,
        ),
      ),
    );

    return true;
  }
}

/// Operation called `OP_DROP` with code `117` or `0x75`.
/// Removes the top [stack] item.
class _OpDrop extends ScriptOperation {
  _OpDrop({@required this.stack});

  static _OpDrop builder({@required Map<String, dynamic> args}) {
    return _OpDrop(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.isNotEmpty) {
      stack.removeLast();

      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_DUP` with code `118` or `0x76`.
/// Gets the top element in the [stack] (without removing it),
/// duplicates it and pushes the result into the [stack].
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
      stack.add(
        copy(element: stack.last),
      );

      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_NIP` with code `119` or `0x77`.
/// Removes the second last [stack] element.
class _OpNip extends ScriptOperation {
  _OpNip({@required this.stack});

  static _OpNip builder({@required Map<String, dynamic> args}) {
    return _OpNip(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.length >= 2) {
      final temp = stack.removeLast();
      stack.removeLast();
      stack.add(temp);

      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_OVER` with code `120` or `0x78`.
/// Duplicates the second last [stack] element to the top
/// of the [stack].
class _OpOver extends ScriptOperation {
  _OpOver({@required this.stack});

  static _OpOver builder({@required Map<String, dynamic> args}) {
    return _OpOver(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.length >= 2) {
      final temp = stack.removeLast();
      final copied = copy(element: stack.last);
      stack.add(temp);
      stack.add(copied);

      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_PICK` with code `121` or `0x79`.
/// Duplicates the `n`-last [stack] element to the top of the [stack].
/// The `n` value is drawn from the top of the [stack], removing it.
class _OpPick extends ScriptOperation {
  _OpPick({@required this.stack});

  static _OpPick builder({@required Map<String, dynamic> args}) {
    return _OpPick(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    final n = stack.isNotEmpty
        ? ScriptUtils.decodeNumber(
            element: stack.removeLast(),
          ).toInt()
        : null;

    if (n != null && stack.length > n) {
      final temp = <Uint8List>[];
      for (var _ = 0; _ < n; _++) {
        temp.insert(
          0,
          stack.removeLast(),
        );
      }
      final copied = copy(element: stack.last);
      stack.addAll(temp);
      stack.add(copied);

      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_ROLL` with code `122` or `0x7a`.
/// Moves the `n`-last [stack] element to the top of the [stack].
/// The `n` value is drawn from the top of the [stack], removing it.
class _OpRoll extends ScriptOperation {
  _OpRoll({@required this.stack});

  static _OpRoll builder({@required Map<String, dynamic> args}) {
    return _OpRoll(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    final n = stack.isNotEmpty
        ? ScriptUtils.decodeNumber(
            element: stack.removeLast(),
          ).toInt()
        : null;

    if (n != null && stack.length > n) {
      final temp = <Uint8List>[];
      for (var _ = 0; _ < n; _++) {
        temp.insert(
          0,
          stack.removeLast(),
        );
      }
      final nLast = stack.removeLast();
      stack.addAll(temp);
      stack.add(nLast);

      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_ROT` with code `123` or `0x7b`.
/// Moves the third last [stack] element to the top of the [stack].
class _OpRot extends ScriptOperation {
  _OpRot({@required this.stack});

  static _OpRot builder({@required Map<String, dynamic> args}) {
    return _OpRot(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.length >= 3) {
      final temp = <Uint8List>[];
      for (var _ = 0; _ < 3; _++) {
        temp.insert(
          0,
          stack.removeLast(),
        );
      }
      stack.addAll(temp.sublist(1));
      stack.add(temp.first);

      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_SWAP` with code `124` or `0x7c`.
/// Swaps the two last [stack] elements.
class _OpSwap extends ScriptOperation {
  _OpSwap({@required this.stack});

  static _OpSwap builder({@required Map<String, dynamic> args}) {
    return _OpSwap(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.length >= 2) {
      final temp = <Uint8List>[];
      for (var _ = 0; _ < 2; _++) {
        temp.add(stack.removeLast());
      }
      stack.addAll(temp);

      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_TUCK` with code `125` or `0x7d`.
/// Copies the last [stack] element before the second last [stack]
/// element.
class _OpTuck extends ScriptOperation {
  _OpTuck({@required this.stack});

  static _OpTuck builder({@required Map<String, dynamic> args}) {
    return _OpTuck(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.length >= 2) {
      final temp = <Uint8List>[];
      for (var _ = 0; _ < 2; _++) {
        temp.insert(
          0,
          stack.removeLast(),
        );
      }
      temp.insert(
        0,
        copy(element: temp.last),
      );
      stack.addAll(temp);

      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_SIZE` with code `130` or `0x82`.
/// Adds the size of the last [stack] element to the [stack] without
/// removing it.
class _OpSize extends ScriptOperation {
  _OpSize({@required this.stack});

  static _OpSize builder({@required Map<String, dynamic> args}) {
    return _OpSize(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.isNotEmpty) {
      stack.add(
        ScriptUtils.encodeNumber(
          number: BigInt.from(stack.last.length),
        ),
      );

      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_EQUAL` with code `135` or `0x87`.
/// Adds `1` to the [stack] if the two last [stack] elements are equal,
/// `0` otherwise.
class _OpEqual extends ScriptOperation {
  _OpEqual({@required this.stack});

  static _OpEqual builder({@required Map<String, dynamic> args}) {
    return _OpEqual(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.length >= 2) {
      final first = stack.removeLast();
      final second = stack.removeLast();

      final areEqual = ScriptUtils.areStackElementsEqual(
        first: first,
        second: second,
      );
      final result = areEqual ? BigInt.one : BigInt.zero;
      stack.add(
        ScriptUtils.encodeNumber(
          number: result,
        ),
      );

      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_EQUALVERIFY` with code `136` or `0x88`.
/// Same as [_OpEqual], but runs [_OpVerify] afterward.
class _OpEqualVerify extends ScriptOperation {
  _OpEqualVerify({@required this.stack});

  static _OpEqualVerify builder({@required Map<String, dynamic> args}) {
    return _OpEqualVerify(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    final executor = ScriptExecutor();

    return executor.run(
          opCode: OpCode.OP_EQUAL,
          stack: stack,
        ) &&
        executor.run(
          opCode: OpCode.OP_VERIFY,
          stack: stack,
        );
  }
}

/// Operation called `OP_1ADD` with code `139` or `0x8b`.
/// Adds `1` to the last [stack] element.
class _Op1Add extends ScriptOperation {
  _Op1Add({@required this.stack});

  static _Op1Add builder({@required Map<String, dynamic> args}) {
    return _Op1Add(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.isNotEmpty) {
      var element = ScriptUtils.decodeNumber(
        element: stack.removeLast(),
      );
      element += BigInt.one;

      stack.add(
        ScriptUtils.encodeNumber(
          number: element,
        ),
      );

      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_1SUB` with code `140` or `0x8c`.
/// Subtracts `1` to the last [stack] element.
class _Op1Sub extends ScriptOperation {
  _Op1Sub({@required this.stack});

  static _Op1Sub builder({@required Map<String, dynamic> args}) {
    return _Op1Sub(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.isNotEmpty) {
      var element = ScriptUtils.decodeNumber(
        element: stack.removeLast(),
      );
      element -= BigInt.one;

      stack.add(
        ScriptUtils.encodeNumber(
          number: element,
        ),
      );

      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_NEGATE` with code `143` or `0x8f`.
/// The sign of the last [stack] element is flipped.
class _OpNegate extends ScriptOperation {
  _OpNegate({@required this.stack});

  static _OpNegate builder({@required Map<String, dynamic> args}) {
    return _OpNegate(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.isNotEmpty) {
      final element = -ScriptUtils.decodeNumber(
        element: stack.removeLast(),
      );

      stack.add(
        ScriptUtils.encodeNumber(
          number: element,
        ),
      );

      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_ABS` with code `144` or `0x90`.
/// The last [stack] element is made positive.
class _OpAbs extends ScriptOperation {
  _OpAbs({@required this.stack});

  static _OpAbs builder({@required Map<String, dynamic> args}) {
    return _OpAbs(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.isNotEmpty) {
      final element = ScriptUtils.decodeNumber(
        element: stack.removeLast(),
      ).abs();

      stack.add(
        ScriptUtils.encodeNumber(
          number: element,
        ),
      );

      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_NOT` with code `145` or `0x91`.
/// If the last [stack] element is `0` or `1`, it is flipped. If not,
/// a `0` is added to the [stack].
class _OpNot extends ScriptOperation {
  _OpNot({@required this.stack});

  static _OpNot builder({@required Map<String, dynamic> args}) {
    return _OpNot(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.isNotEmpty) {
      final element = ScriptUtils.decodeNumber(
        element: stack.removeLast(),
      );

      BigInt toAdd;
      if (element == BigInt.zero) {
        toAdd = BigInt.one;
      } else {
        toAdd = BigInt.zero;
      }

      stack.add(
        ScriptUtils.encodeNumber(
          number: toAdd,
        ),
      );

      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_0NOTEQUAL` with code `146` or `0x92`.
/// If the last [stack] element is `0` adds a `0` to the [stack]. Adds
/// a `1` otherwise.
class _Op0NotEqual extends ScriptOperation {
  _Op0NotEqual({@required this.stack});

  static _Op0NotEqual builder({@required Map<String, dynamic> args}) {
    return _Op0NotEqual(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.isNotEmpty) {
      final element = ScriptUtils.decodeNumber(
        element: stack.removeLast(),
      );

      BigInt toAdd;
      if (element == BigInt.zero) {
        toAdd = BigInt.zero;
      } else {
        toAdd = BigInt.one;
      }

      stack.add(
        ScriptUtils.encodeNumber(
          number: toAdd,
        ),
      );

      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_ADD` with code `147` or `0x93`.
/// Adds the two last [stack] elements.
class _OpAdd extends ScriptOperation {
  _OpAdd({@required this.stack});

  static _OpAdd builder({@required Map<String, dynamic> args}) {
    return _OpAdd(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.length >= 2) {
      final first = ScriptUtils.decodeNumber(
        element: stack.removeLast(),
      );
      final second = ScriptUtils.decodeNumber(
        element: stack.removeLast(),
      );

      stack.add(
        ScriptUtils.encodeNumber(
          number: first + second,
        ),
      );

      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_SUB` with code `148` or `0x94`.
/// Subtracts the last [stack] element from the second last [stack] element.
class _OpSub extends ScriptOperation {
  _OpSub({@required this.stack});

  static _OpSub builder({@required Map<String, dynamic> args}) {
    return _OpSub(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.length >= 2) {
      final last = ScriptUtils.decodeNumber(
        element: stack.removeLast(),
      );
      final secondLast = ScriptUtils.decodeNumber(
        element: stack.removeLast(),
      );

      stack.add(
        ScriptUtils.encodeNumber(
          number: secondLast - last,
        ),
      );

      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_BOOLAND` with code `154` or `0x9a`.
/// If the two last [stack] elements are not `0`, a `1` is added to the
/// [stack]. Otherwise, a `0` is added.
class _OpBoolAnd extends ScriptOperation {
  _OpBoolAnd({@required this.stack});

  static _OpBoolAnd builder({@required Map<String, dynamic> args}) {
    return _OpBoolAnd(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.isNotEmpty) {
      final first = ScriptUtils.decodeNumber(
        element: stack.removeLast(),
      );
      final second = ScriptUtils.decodeNumber(
        element: stack.removeLast(),
      );

      BigInt toAdd;
      if (first != BigInt.zero && second != BigInt.zero) {
        toAdd = BigInt.one;
      } else {
        toAdd = BigInt.zero;
      }

      stack.add(
        ScriptUtils.encodeNumber(
          number: toAdd,
        ),
      );

      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_BOOLOR` with code `155` or `0x9b`.
/// If at least one of the two last [stack] elements is not `0`, a `1` is
/// added to the [stack]. Otherwise, a `0` is added.
class _OpBoolOr extends ScriptOperation {
  _OpBoolOr({@required this.stack});

  static _OpBoolOr builder({@required Map<String, dynamic> args}) {
    return _OpBoolOr(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.isNotEmpty) {
      final first = ScriptUtils.decodeNumber(
        element: stack.removeLast(),
      );
      final second = ScriptUtils.decodeNumber(
        element: stack.removeLast(),
      );

      BigInt toAdd;
      if (first != BigInt.zero || second != BigInt.zero) {
        toAdd = BigInt.one;
      } else {
        toAdd = BigInt.zero;
      }

      stack.add(
        ScriptUtils.encodeNumber(
          number: toAdd,
        ),
      );

      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_NUMEQUAL` with code `156` or `0x9c`.
/// If the two last [stack] elements are equal, a `1` is
/// added to the [stack]. Otherwise, a `0` is added.
class _OpNumEqual extends ScriptOperation {
  _OpNumEqual({@required this.stack});

  static _OpNumEqual builder({@required Map<String, dynamic> args}) {
    return _OpNumEqual(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.isNotEmpty) {
      final first = ScriptUtils.decodeNumber(
        element: stack.removeLast(),
      );
      final second = ScriptUtils.decodeNumber(
        element: stack.removeLast(),
      );

      BigInt toAdd;
      if (first == second) {
        toAdd = BigInt.one;
      } else {
        toAdd = BigInt.zero;
      }

      stack.add(
        ScriptUtils.encodeNumber(
          number: toAdd,
        ),
      );

      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_NUMEQUALVERIFY` with code `157` or `0x9d`.
/// Same as [_OpNumEqual], but runs [_OpVerify] afterward.
class _OpNumEqualVerify extends ScriptOperation {
  _OpNumEqualVerify({@required this.stack});

  static _OpNumEqualVerify builder({@required Map<String, dynamic> args}) {
    return _OpNumEqualVerify(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    final executor = ScriptExecutor();

    return executor.run(
          opCode: OpCode.OP_NUMEQUAL,
          stack: stack,
        ) &&
        executor.run(
          opCode: OpCode.OP_VERIFY,
          stack: stack,
        );
  }
}

/// Operation called `OP_NUMNOTEQUAL` with code `158` or `0x9e`.
/// If the two last [stack] elements are not equal, a `1` is
/// added to the [stack]. Otherwise, a `0` is added.
class _OpNumNotEqual extends ScriptOperation {
  _OpNumNotEqual({@required this.stack});

  static _OpNumNotEqual builder({@required Map<String, dynamic> args}) {
    return _OpNumNotEqual(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.isNotEmpty) {
      final first = ScriptUtils.decodeNumber(
        element: stack.removeLast(),
      );
      final second = ScriptUtils.decodeNumber(
        element: stack.removeLast(),
      );

      BigInt toAdd;
      if (first != second) {
        toAdd = BigInt.one;
      } else {
        toAdd = BigInt.zero;
      }

      stack.add(
        ScriptUtils.encodeNumber(
          number: toAdd,
        ),
      );

      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_LESSTHAN` with code `159` or `0x9f`.
/// If the second last [stack] element is less than the last [stack]
/// element, a `1` is added to the [stack]. Otherwise, a `0` is added.
class _OpLessThan extends ScriptOperation {
  _OpLessThan({@required this.stack});

  static _OpLessThan builder({@required Map<String, dynamic> args}) {
    return _OpLessThan(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.isNotEmpty) {
      final last = ScriptUtils.decodeNumber(
        element: stack.removeLast(),
      );
      final secondLast = ScriptUtils.decodeNumber(
        element: stack.removeLast(),
      );

      BigInt toAdd;
      if (secondLast < last) {
        toAdd = BigInt.one;
      } else {
        toAdd = BigInt.zero;
      }

      stack.add(
        ScriptUtils.encodeNumber(
          number: toAdd,
        ),
      );

      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_GREATERTHAN` with code `160` or `0xa0`.
/// If the second last [stack] element is greater than the last [stack]
/// element, a `1` is added to the [stack]. Otherwise, a `0` is added.
class _OpGreaterThan extends ScriptOperation {
  _OpGreaterThan({@required this.stack});

  static _OpGreaterThan builder({@required Map<String, dynamic> args}) {
    return _OpGreaterThan(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.isNotEmpty) {
      final last = ScriptUtils.decodeNumber(
        element: stack.removeLast(),
      );
      final secondLast = ScriptUtils.decodeNumber(
        element: stack.removeLast(),
      );

      BigInt toAdd;
      if (secondLast > last) {
        toAdd = BigInt.one;
      } else {
        toAdd = BigInt.zero;
      }

      stack.add(
        ScriptUtils.encodeNumber(
          number: toAdd,
        ),
      );

      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_LESSTHANOREQUAL` with code `161` or `0xa1`.
/// If the second last [stack] element is less than or equal to the last
/// [stack] element, a `1` is added to the [stack]. Otherwise, a `0` is added.
class _OpLessThanOrEqual extends ScriptOperation {
  _OpLessThanOrEqual({@required this.stack});

  static _OpLessThanOrEqual builder({@required Map<String, dynamic> args}) {
    return _OpLessThanOrEqual(
      stack: args[ScriptOperation.stackArgName],
    );
  }

  final ListQueue<Uint8List> stack;

  @override
  bool execute() {
    var isValidOp = false;

    if (stack.isNotEmpty) {
      final last = ScriptUtils.decodeNumber(
        element: stack.removeLast(),
      );
      final secondLast = ScriptUtils.decodeNumber(
        element: stack.removeLast(),
      );

      BigInt toAdd;
      if (secondLast <= last) {
        toAdd = BigInt.one;
      } else {
        toAdd = BigInt.zero;
      }

      stack.add(
        ScriptUtils.encodeNumber(
          number: toAdd,
        ),
      );

      isValidOp = true;
    }

    return isValidOp;
  }
}

/// Operation called `OP_HASH160` with code `169` or `0xa9`.
/// Removes the top element of the [stack], performs a [Secp256Utils.hash160]
/// to it and pushes back the result into the [stack].
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
/// Removes the top element of the [stack], performs a [Secp256Utils.hash256]
/// to it and pushes back the result into the [stack].
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
