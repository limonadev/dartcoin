import 'dart:typed_data';

import 'package:meta/meta.dart';

class ScriptUtils {
  /// Based on https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch06/op.py#L17
  static Uint8List encodeNumber({@required BigInt number}) {
    final result = <int>[];

    if (number != BigInt.zero) {
      var abs = number.abs();
      final isNegative = number < BigInt.zero;

      while (abs != BigInt.zero) {
        result.add(
          (abs & BigInt.from(0xff)).toInt(),
        );
        abs >>= 8;
      }

      if (result.last & 0x80 != 0) {
        result.add(isNegative ? 0x80 : 0);
      } else if (isNegative) {
        result[result.length - 1] |= 0x80;
      }
    }

    return Uint8List.fromList(result);
  }

  /// Based on https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch06/op.py#L36
  static BigInt decodeNumber({@required Uint8List element}) {
    var result = BigInt.zero;

    bool isNegative;
    if (element.isNotEmpty) {
      final bigEndian = element.reversed.toList();

      if (bigEndian.first & 0x80 != 0) {
        result = BigInt.from(bigEndian.first & 0x7f);
        isNegative = true;
      } else {
        result = BigInt.from(bigEndian.first);
        isNegative = false;
      }

      for (var byte in element.skip(1)) {
        result <<= 8;
        result += BigInt.from(byte);
      }

      if (isNegative) result = -result;
    }

    return result;
  }
}
