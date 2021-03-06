import 'dart:typed_data';
import 'package:meta/meta.dart';

enum Endian { big, little }

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
  /// This function will return an [Uint8List] with the minimun size necessary
  /// to represent the [number].
  static Uint8List encodeBigInt(BigInt number) {
    // Not handling negative numbers. Decide how you want to do that.
    if (number == BigInt.zero) {
      return Uint8List.fromList([0]);
    }
    var size = (number.bitLength + 7) >> 3;
    var result = Uint8List(size);
    for (var i = 0; i < size; i++) {
      result[size - i - 1] = (number & _byteMask).toInt();
      number = number >> 8;
    }
    return result;
  }

  /// This function will return an [Uint8List] with length [size]. If the [number]
  /// representation needs few bytes, the remaining space will be filled with zeros.
  /// If the [size] is null, its value will be the encoded number lenght.
  static Uint8List bigIntToBytes({
    @required BigInt number,
    Endian endian = Endian.big,
    int size,
  }) {
    var encoded = encodeBigInt(number);
    size ??= encoded.length;

    if (encoded.length > size) {
      throw RangeError(
        'The [size] should be greater or equal than the length in bytes of the [number]',
      );
    } else {
      encoded = Uint8List.fromList(
        [
          ...List.filled(size - encoded.length, 0),
          ...encoded,
        ],
      );
    }

    return endian == Endian.big
        ? encoded
        : Uint8List.fromList(encoded.reversed.toList());
  }

  /// This function will return a [BigInt]. It has the same functionality
  /// as the [decodeBigInt] method, but with the added [endian] parameter.
  static BigInt bytesToBigInt({
    @required Uint8List bytes,
    Endian endian = Endian.big,
  }) {
    /// The line
    /// `BigInt.from(bytes[bytes.length - i - 1]) << (8 * i);`
    /// from [decodeBigInt] is the same as
    /// `BigInt.from(bytes[bytes.length - i - 1]) * BigInt.from(256).pow(i);`
    return decodeBigInt(
      endian == Endian.big
          ? bytes
          : Uint8List.fromList(bytes.reversed.toList()),
    );
  }

  /// Convenience method to return the byte representation of the [String]
  /// hex value.
  static Uint8List bytesFromHex({
    @required String hex,
    Endian endian = Endian.big,
  }) {
    return bigIntToBytes(
      number: BigInt.parse(
        hex,
        radix: 16,
      ),
      endian: endian,
      size: hex.length ~/ 2,
    );
  }

  /// Convenience method to return the Hex representation of the [BigInt]
  /// value which [bytes] become to.
  static String bytesToHex({
    @required Uint8List bytes,
    Endian endian = Endian.big,
    int padding,
  }) {
    return toHex(
      padding: padding,
      value: bytesToBigInt(
        bytes: bytes,
        endian: endian,
      ),
    );
  }

  /// Return the Hex representation of the [value].
  static String toHex({int padding, @required BigInt value}) {
    var result = '';
    final bytes = bigIntToBytes(number: value);
    for (var byte in bytes) {
      result += byte.toRadixString(16).padLeft(2, '0');
    }
    if (padding != null) {
      result = result.padLeft(padding, '0');
    }
    return result;
  }
}
