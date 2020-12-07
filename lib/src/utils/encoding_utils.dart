import 'dart:typed_data';

import 'package:dartcoin/src/utils/all.dart';

class EncodingUtils {
  static const base58Alphabet =
      '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';

  static String toBase58(Uint8List bytes) {
    final zerosCount = bytes.takeWhile((value) => value == 0x00).length;
    final prefix = List.filled(zerosCount, 1).join();

    var decoded = ObjectUtils.decodeBigInt(bytes);
    var result = '';

    while (decoded > BigInt.zero) {
      final mod = (decoded % BigInt.from(58)).toInt();
      decoded = decoded ~/ BigInt.from(58);

      result = base58Alphabet[mod] + result;
    }

    return prefix + result;
  }
}
