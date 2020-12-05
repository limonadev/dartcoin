import 'package:dartcoin/dartcoin.dart';

class ChapterFour {
  void runEverything({bool runOptionals = false}) {
    print('Run each exercise from Chapter Fourth');

    _first();
    _second();

    if (runOptionals) {
      print('Optional exercises');
    }
  }

  /// Exercise 1 from https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch04/Chapter4.ipynb
  void _first() {
    print('First Exercise');

    final secrets = [
      BigInt.from(5000),
      BigInt.from(2018).pow(5),
      BigInt.parse('deadbeef12345', radix: 16),
    ];

    for (var secret in secrets) {
      final pk = PrivateKey(secret: secret);
      final sec = pk.point.sec(compressed: false);
      print(ObjectUtils.toHex(
        padding: 130,
        value: ObjectUtils.decodeBigInt(sec),
      ));
    }
  }

  /// Exercise 2 from https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch04/Chapter4.ipynb
  void _second() {
    print('Second Exercise');

    final secrets = [
      BigInt.from(5001),
      BigInt.from(2019).pow(5),
      BigInt.parse('deadbeef54321', radix: 16),
    ];

    for (var secret in secrets) {
      final pk = PrivateKey(secret: secret);
      final sec = pk.point.sec(compressed: true);
      print(ObjectUtils.toHex(
        padding: 66,
        value: ObjectUtils.decodeBigInt(sec),
      ));
    }
  }
}
