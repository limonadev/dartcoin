import 'dart:typed_data';

import 'package:dartcoin/src/transaction/script.dart';
import 'package:dartcoin/src/transaction/varint.dart';
import 'package:dartcoin/src/utils/all.dart';

/// TODO: UNDERSTAND ON CHAPTER 6 BUILD SCRIPT FROM STREAM
enum ScriptParsing {
  Length,
  Until75,
  Equal76,
  Equal77,
  OpCode,
}

class ScriptFactory {
  static Script parseSync(Uint8List bytes) {
    final cmds = <Object>[];

    final lengthVarintByteNumber = Varint.numberOfNecessaryBytes(
      flag: bytes[0],
    );
    final lengthVarint = Varint.read(bytes: bytes);

    if (BigInt.from(bytes.length - lengthVarintByteNumber - 1) !=
        lengthVarint) {
      throw FormatException('ScriptParsing Script failed!');
    }

    int necessaryBytes;

    for (var i = lengthVarintByteNumber + 1; i < bytes.length; i++) {
      final byte = bytes[i];

      if (byte >= 1 && byte <= 75) {
        necessaryBytes = byte;

        cmds.add(
          Uint8List.fromList(
            bytes.sublist(i + 1, i + necessaryBytes + 1),
          ),
        );

        i += necessaryBytes;
      } else if (byte == 76) {
        necessaryBytes = ObjectUtils.bytesToBigInt(
          bytes: Uint8List.fromList([bytes[i + 1]]),
          endian: Endian.little,
        ).toInt();

        cmds.add(
          Uint8List.fromList(
            bytes.sublist(i + 2, i + necessaryBytes + 2),
          ),
        );

        i += necessaryBytes + 1;
      } else if (byte == 77) {
        necessaryBytes = ObjectUtils.bytesToBigInt(
          bytes: Uint8List.fromList([bytes[i + 1], bytes[i + 2]]),
          endian: Endian.little,
        ).toInt();

        cmds.add(
          Uint8List.fromList(
            bytes.sublist(i + 3, i + necessaryBytes + 3),
          ),
        );

        i += necessaryBytes + 2;
      } else {
        cmds.add(byte);
      }
    }

    return Script(cmds: cmds);
  }

  static Future<Script> parse(Stream<int> stream) async {
    final cmds = <Object>[];
    var currentStep = ScriptParsing.Length;

    final acc = <int>[];
    int lengthVarintByteNumber;
    BigInt lengthVarint;

    var count = BigInt.zero;
    int necessaryBytes;

    await for (var byte in stream) {
      if (currentStep == ScriptParsing.Length) {
        acc.add(byte);

        lengthVarintByteNumber ??= Varint.numberOfNecessaryBytes(flag: byte);

        if (lengthVarintByteNumber == 0 ||
            acc.length == lengthVarintByteNumber + 1) {
          lengthVarint = Varint.read(bytes: Uint8List.fromList(acc));
          currentStep = null;

          acc.clear();
        }
      } else {
        if (count >= lengthVarint) break;
        count += BigInt.one;

        if (currentStep == null) {
          if (byte >= 1 && byte <= 75) {
            currentStep = ScriptParsing.Until75;
          } else if (byte == 76) {
            currentStep = ScriptParsing.Equal76;
          } else if (byte == 77) {
            currentStep = ScriptParsing.Equal77;
          } else {
            currentStep = ScriptParsing.OpCode;
          }
        }
      }

      if (currentStep == ScriptParsing.Until75) {
        if (necessaryBytes == null) {
          necessaryBytes = byte;
        } else {
          acc.add(byte);
          if (acc.length == necessaryBytes) {
            cmds.add(Uint8List.fromList(acc));
            currentStep = null;

            necessaryBytes = null;
            acc.clear();
          }
        }
      } else if (currentStep == ScriptParsing.Equal76) {
        acc.add(byte);
        if (necessaryBytes == null) {
          if (acc.length == 2) {
            necessaryBytes = ObjectUtils.bytesToBigInt(
              bytes: Uint8List.fromList(acc.sublist(1)),
              endian: Endian.little,
            ).toInt();

            acc.clear();
          }
        } else {
          if (acc.length == necessaryBytes) {
            cmds.add(Uint8List.fromList(acc));
            currentStep = null;

            necessaryBytes = null;
            acc.clear();
          }
        }
      } else if (currentStep == ScriptParsing.Equal77) {
        acc.add(byte);
        if (necessaryBytes == null) {
          if (acc.length == 3) {
            necessaryBytes = ObjectUtils.bytesToBigInt(
              bytes: Uint8List.fromList(acc.sublist(2)),
              endian: Endian.little,
            ).toInt();

            acc.clear();
          }
        } else {
          if (acc.length == necessaryBytes) {
            cmds.add(Uint8List.fromList(acc));
            currentStep = null;

            necessaryBytes = null;
            acc.clear();
          }
        }
      } else if (currentStep == ScriptParsing.OpCode) {
        cmds.add(byte);
        currentStep = null;
      }
    }

    if (count != lengthVarint) {
      throw FormatException('ScriptParsing Script failed!');
    }

    return Script(cmds: cmds);
  }
}
