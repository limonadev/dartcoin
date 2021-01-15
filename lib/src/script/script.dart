import 'dart:collection';
import 'dart:typed_data';

import 'package:dartcoin/src/script/op_code.dart';
import 'package:dartcoin/src/transaction/all.dart';
import 'package:dartcoin/src/utils/all.dart';
import 'package:meta/meta.dart';

/// This class is intended to improve the issue mentioned in the book
/// at page 117, by maintaining a "state" of the [commonStack] and
/// the [commonAltStack].
class ScriptExecutor {
  ScriptExecutor({
    @required this.message,
  })  : commonAltStack = ListQueue<Uint8List>(),
        commonStack = ListQueue<Uint8List>();

  final ListQueue<Uint8List> commonAltStack;
  final ListQueue<Uint8List> commonStack;
  final BigInt message;

  bool run({@required Script script}) {
    var result = true;

    final commands = ListQueue<Object>.from(script.cmds);

    final executor = ScriptOperationExecutor(
      altStack: commonAltStack,
      stack: commonStack,
    );

    while (commands.isNotEmpty && result == true) {
      final command = commands.removeFirst();

      if (command is int) {
        result = executor.run(
          commands: commands,
          message: message,
          opCodeAsByte: command,
        );
      } else {
        commonStack.add(command);
      }
    }

    result = result && commonStack.isNotEmpty && commonStack.last.isNotEmpty;

    return result;
  }

  bool runBoth({
    @required Script first,
    @required Script second,
  }) {
    var result = false;

    final firstIsValid = run(script: first);
    if (firstIsValid) {
      result = run(script: second);
    }

    return result;
  }
}

/// TODO: MAKE THIS CLASS (CHAPTER 6)
class Script {
  Script({
    @required List<Object> cmds,
  }) : cmds = cmds ?? [];

  final List<Object> cmds;

  Uint8List rawSerialize() {
    final result = <int>[];

    for (final cmd in cmds) {
      if (cmd is int) {
        result.add(cmd);
      } else if (cmd is List<int>) {
        final len = cmd.length;

        if (len < 75) {
          result.add(len);
        } else if (len > 75 && len < 0x100) {
          result.addAll([76, len]);
        } else if (len >= 0x100 && len <= 520) {
          result.addAll(
            [
              77,
              ...ObjectUtils.bigIntToBytes(
                number: BigInt.from(len),
                endian: Endian.little,
                size: 2,
              )
            ],
          );
        } else {
          throw ArgumentError('The cmd is too long!');
        }

        result.addAll(cmd);
      }
    }

    return Uint8List.fromList(result);
  }

  Uint8List serialize() {
    final result = rawSerialize();
    final total = result.length;
    return Uint8List.fromList(
      [
        ...Varint.encode(
          varint: BigInt.from(total),
        ),
        ...result,
      ],
    );
  }

  /// TODO: COMPLETE THE REAL STRING REPRESENTATION
  @override
  String toString() {
    final result = <String>[];

    for (final cmd in cmds) {
      if (cmd is int) {
        /// TODO: TOSTRING WHEN OPCODE
      } else if (cmd is Uint8List) {
        final value = ObjectUtils.bytesToBigInt(bytes: cmd);
        result.add(ObjectUtils.toHex(value: value));
      }
    }
    return result.join(' ');
  }
}
