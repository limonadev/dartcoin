import 'dart:typed_data';
import 'package:meta/meta.dart';
import 'package:dartcoin/src/utils/all.dart';

// TODO: CHECK THE BASE58 ENCODING, IS IT REALLY NECESSARY TO USE BYTES?
class Base58Utils {
  static const alphabet =
      '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';

  static Uint8List encode({@required Uint8List bytes}) {
    final zerosCount = bytes.takeWhile((value) => value == 0x00).length;
    final prefix = List.filled(zerosCount, '1'.codeUnitAt(0));

    var decoded = ObjectUtils.decodeBigInt(bytes);
    final result = <int>[];

    while (decoded > BigInt.zero) {
      final mod = (decoded % BigInt.from(58)).toInt();
      decoded = decoded ~/ BigInt.from(58);

      result.insert(0, alphabet[mod].codeUnitAt(0));
    }

    return Uint8List.fromList(prefix + result);
  }

  static Uint8List encodeChecksum({@required Uint8List bytes}) {
    return encode(
      bytes: Uint8List.fromList(
        [
          ...bytes,
          ...Secp256Utils.hash256(data: bytes).getRange(0, 4).toList()
        ],
      ),
    );
  }
}
