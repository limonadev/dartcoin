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

  static Uint8List decodeAddress({@required Uint8List base58Address}) {
    var number = BigInt.zero;
    for (final val in base58Address) {
      number *= BigInt.from(58);
      number += BigInt.from(val);
    }

    final combined = ObjectUtils.bigIntToBytes(
      number: number,
      size: 25,
    );
    final checksum = combined.sublist(combined.length - 4);
    final hashed = Secp256Utils.hash256(
      data: combined.sublist(0, combined.length - 4),
    );
    final areEqual = ScriptUtils.areStackElementsEqual(
      first: hashed.sublist(0, 4),
      second: checksum,
    );
    if (!areEqual) {
      throw FormatException(
        'The argument base58Address: $base58Address has not the right format',
      );
    }

    final result = combined.sublist(1, combined.length - 4);
    return Uint8List.fromList(result);
  }

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

  /// Convenience method to get a base58 encoded list of bytes from
  /// a readable String called [humanReadable].
  static Uint8List fromHumanReadable({@required String humanReadable}) {
    final result = <int>[];
    for (var i = 0; i < humanReadable.length; i++) {
      final char = humanReadable[i];
      result.add(bytesFromChars[char]);
    }

    return Uint8List.fromList(result);
  }

  /// Convenience method to show a readable String from a Base58
  /// list called [encoded].
  static String humanReadable({@required Uint8List encoded}) {
    return encoded.map((e) => alphabet[e]).join();
  }
}
