import 'dart:typed_data';

import 'package:dartcoin/src/utils/all.dart';
import 'package:meta/meta.dart';

class Varint {
  static Uint8List encode({@required BigInt varint}) {
    Uint8List result;

    int prefix;
    int numberOfBytes;

    if (varint < BigInt.from(0xfd)) {
      numberOfBytes = null;
    } else if (varint < BigInt.from(0x10000)) {
      prefix = 0xfd;
      numberOfBytes = 2;
    } else if (varint < BigInt.from(0x100000000)) {
      prefix = 0xfe;
      numberOfBytes = 4;
    } else if (varint <
        BigInt.parse(
          '10000000000000000',
          radix: 16,
        )) {
      prefix = 0xff;
      numberOfBytes = 8;
    } else {
      throw ArgumentError(
        'The provided argument is too large to be encoded as Varint',
      );
    }

    result = ObjectUtils.bigIntToBytes(
      endian: Endian.little,
      number: varint,
      size: numberOfBytes,
    );

    return Uint8List.fromList(
      [
        if (prefix != null) prefix,
        ...result,
      ],
    );
  }

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
