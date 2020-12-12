import 'dart:typed_data';

import 'package:dartcoin/src/utils/all.dart';
import 'package:meta/meta.dart';

/// TODO: MAKE THIS CLASS (CHAPTER 6)
class Script {
  Script({
    @required List<Object> cmds,
  }) : cmds = cmds ?? [];

  final List<Object> cmds;

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
