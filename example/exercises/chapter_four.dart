import 'package:dartcoin/dartcoin.dart';

class ChapterFour {
  void runEverything({bool runOptionals = false}) {
    print('Run each exercise from Chapter Fourth');

    if (runOptionals) {
      print('Optional exercises');
      _optional_first();
    }
  }

  /// Exercise 1 from Programming Bitcoin book - Chapter 4
  void _optional_first() {
    print('Optional First Exercise');

    final secrets = [
      BigInt.from(5000),
      BigInt.from(2018).pow(5),
      BigInt.parse('deadbeef12345', radix: 16),
    ];

    for (var secret in secrets) {
      final pk = PrivateKey(secret: secret);
      final sec = pk.point.sec();
      print(ObjectUtils.toHex(
        padding: 130,
        value: ObjectUtils.decodeBigInt(sec),
      ));
    }
  }
}
