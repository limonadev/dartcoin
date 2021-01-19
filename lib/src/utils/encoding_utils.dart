import 'dart:typed_data';
import 'package:meta/meta.dart';
import 'package:dartcoin/src/utils/all.dart';

/// According to https://tools.ietf.org/id/draft-msporny-base58-01.html , the byte encoding
/// is based on the position in the [alphabet]. For example, the Human Readable Base58 value:
/// `1F1` is encoded as the list of bytes `[0,14,0]`.
class Base58Utils {
  static const alphabet =
      '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';

  static final bytesFromChars = alphabet.codeUnits.asMap().map(
        (key, value) => MapEntry(
          String.fromCharCode(value),
          key,
        ),
      );
  static Uint8List encode({@required Uint8List bytes}) {
    final zerosCount = bytes.takeWhile((value) => value == 0x00).length;
    final prefix = List.filled(zerosCount, 0x00);

    var decoded = ObjectUtils.decodeBigInt(bytes);
    final result = <int>[];

    while (decoded > BigInt.zero) {
      final mod = (decoded % BigInt.from(58)).toInt();
      decoded = decoded ~/ BigInt.from(58);

      result.insert(0, mod);
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

  /// Convenience method to show a readable String from a Base58
  /// list called [encoded].
  static String humanReadable({@required Uint8List encoded}) {
    return encoded.map((e) => alphabet[e]).join();
  }
}
