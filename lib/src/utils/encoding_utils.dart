import 'dart:typed_data';
import 'package:meta/meta.dart';
import 'package:dartcoin/src/utils/all.dart';

class Base58Utils {
  static const alphabet =
      '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';

  static String encode({@required Uint8List bytes}) {
    final zerosCount = bytes.takeWhile((value) => value == 0x00).length;
    final prefix = List.filled(zerosCount, 1).join();

    var decoded = ObjectUtils.decodeBigInt(bytes);
    var result = '';

    while (decoded > BigInt.zero) {
      final mod = (decoded % BigInt.from(58)).toInt();
      decoded = decoded ~/ BigInt.from(58);

      result = alphabet[mod] + result;
    }

    return prefix + result;
  }
}
