import 'dart:typed_data';

import 'package:dartcoin/src/script/script.dart';
import 'package:dartcoin/src/transaction/all.dart';
import 'package:dartcoin/src/utils/all.dart';
import 'package:meta/meta.dart';

/// TODO: UNDERSTAND ON CHAPTER 6 BUILD SCRIPT FROM STREAM

class ScriptFactory {
  static ParsingResult<Script> parseSync({
    @required Uint8List bytes,
    int initialIndex = 0,
  }) {
    final realBytes = bytes.sublist(initialIndex);

    final cmds = <Object>[];

    final lengthVarintByteNumber = Varint.numberOfNecessaryBytes(
      flag: realBytes[0],
    );
    final lengthVarint = Varint.read(bytes: realBytes);
    final lenAsInt = lengthVarint.toInt();

    int necessaryBytes;
    var i = lengthVarintByteNumber + 1;

    for (; i <= lenAsInt && i < realBytes.length; i++) {
      final byte = realBytes[i];

      if (byte >= 1 && byte <= 75) {
        necessaryBytes = byte;

        cmds.add(
          Uint8List.fromList(
            realBytes.sublist(i + 1, i + necessaryBytes + 1),
          ),
        );

        i += necessaryBytes;
      } else if (byte == 76) {
        necessaryBytes = ObjectUtils.bytesToBigInt(
          bytes: Uint8List.fromList([realBytes[i + 1]]),
          endian: Endian.little,
        ).toInt();

        cmds.add(
          Uint8List.fromList(
            realBytes.sublist(i + 2, i + necessaryBytes + 2),
          ),
        );

        i += necessaryBytes + 1;
      } else if (byte == 77) {
        necessaryBytes = ObjectUtils.bytesToBigInt(
          bytes: Uint8List.fromList([realBytes[i + 1], realBytes[i + 2]]),
          endian: Endian.little,
        ).toInt();

        cmds.add(
          Uint8List.fromList(
            realBytes.sublist(i + 3, i + necessaryBytes + 3),
          ),
        );

        i += necessaryBytes + 2;
      } else {
        cmds.add(byte);
      }
    }

    if (BigInt.from(i - lengthVarintByteNumber - 1) != lengthVarint) {
      throw FormatException('ScriptParsing Script failed!');
    }

    return ParsingResult(
      currentBytePosition: initialIndex + i,
      result: Script(cmds: cmds),
    );
  }
}
