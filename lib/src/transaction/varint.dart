import 'dart:typed_data';

import 'package:dartcoin/src/utils/all.dart';
import 'package:meta/meta.dart';

class Varint {
  /// Returns the number of necessary bytes to build the
  /// [Varint]. This result doesn't count the flag as part
  /// of the necessary number of bytes.
  static int numberOfNecessaryBytes({@required int flag}) {
    int result;

    switch (flag) {
      case 0xfd:
        result = 2;
        break;
      case 0xfe:
        result = 4;
        break;
      case 0xff:
        result = 8;
        break;
      default:
        result = 0;
    }

    return result;
  }

  static int read({@required Uint8List bytes}) {
    final flag = bytes[0];
    final bytesNumber = numberOfNecessaryBytes(flag: flag);

    return ObjectUtils.bytesToBigInt(
      bytes: Uint8List.fromList(
        bytes.sublist(bytesNumber == 0 ? 0 : 1, 1 + bytesNumber),
      ),
      endian: Endian.little,
    ).toInt();
  }
}
