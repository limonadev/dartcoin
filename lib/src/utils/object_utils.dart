import 'dart:typed_data';

class ObjectUtils {
  /// Took from https://github.com/bcgit/pc-dart/blob/master/lib/src/utils.dart
  static final _byteMask = BigInt.from(0xff);

  /// Implementation based on Effective Java Book, Item 11
  static int buildHashCode(List<Object> objects) {
    var result = 17;

    objects.forEach((object) {
      var objectHash = object is int ? object : object.hashCode;
      result = 31 * result + objectHash;
    });

    return result;
  }

  /// Took from https://github.com/bcgit/pc-dart/blob/master/lib/src/utils.dart
  static BigInt decodeBigInt(List<int> bytes) {
    var result = BigInt.from(0);
    for (var i = 0; i < bytes.length; i++) {
      result += BigInt.from(bytes[bytes.length - i - 1]) << (8 * i);
    }
    return result;
  }

  /// Took from https://github.com/bcgit/pc-dart/blob/master/lib/src/utils.dart
  static Uint8List encodeBigInt(BigInt number) {
    // Not handling negative numbers. Decide how you want to do that.
    var size = (number.bitLength + 7) >> 3;
    var result = Uint8List(size);
    for (var i = 0; i < size; i++) {
      result[size - i - 1] = (number & _byteMask).toInt();
      number = number >> 8;
    }
    return result;
  }

  static String toHex(BigInt value) {
    return value.toRadixString(16).padLeft(64, '0');
  }
}
