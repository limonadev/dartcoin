import 'dart:typed_data';

import 'package:dartcoin/src/transaction/all.dart';
import 'package:dartcoin/src/utils/all.dart';
import 'package:meta/meta.dart';

/// TODO: MAKE THIS CLASS (CHAPTER 6)
class Script {
  Script({
    @required List<Object> cmds,
  }) : cmds = cmds ?? [];

  final List<Object> cmds;

  static Script combine({
    @required Script first,
    @required Script second,
  }) {
    return Script(
      cmds: first.cmds + second.cmds,
    );
  }

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
