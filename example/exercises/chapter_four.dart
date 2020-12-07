import 'package:dartcoin/dartcoin.dart';

class ChapterFour {
  void runEverything({bool runOptionals = false}) {
    print('Run each exercise from Chapter Fourth');

    _first();
    _second();
    _third();
    _fourth();
    _fifth();

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

  /// Exercise 3 from https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch04/Chapter4.ipynb
  void _third() {
    print('Third Exercise');

    final r = BigInt.parse(
      '37206a0610995c58074999cb9767b87af4c4978db68c06e8e6e81d282047a7c6',
      radix: 16,
    );
    final s = BigInt.parse(
      '8ca63759c1157ebeaec0d03cecca119fc9a75bf8e6d0fa65c841c8e2738cdaec',
      radix: 16,
    );
    final signature = Signature(r: r, s: s);
    final der = signature.der();

    print(
      ObjectUtils.toHex(
        value: ObjectUtils.decodeBigInt(der),
      ),
    );
  }

  /// Exercise 4 from https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch04/Chapter4.ipynb
  void _fourth() {
    print('Fourth Exercise');

    final hexNumbers = [
      '7c076ff316692a3d7eb3c3bb0f8b1488cf72e1afcd929e29307032997a838a3d',
      'eff69ef2b1bd93a66ed5219add4fb51e11a840f404876325a1e8ffe0529a2c',
      'c7207fee197d27c618aea621406f6bf5ef6fca38681d82b2f06fddbdce6feab6',
    ];

    for (var hex in hexNumbers) {
      var bytes = ObjectUtils.bigIntToBytes(
        number: BigInt.parse(
          hex,
          radix: 16,
        ),
      );

      print(
        Base58Utils.humanReadable(
          encoded: Base58Utils.encode(bytes: bytes),
        ),
      );
    }
  }

  /// Exercise 5 from https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch04/Chapter4.ipynb
  void _fifth() {
    print('Fifth Exercise');

    // PrivateKey, Compressed SEC, TestNet
    final arguments = [
      [BigInt.from(5002), false, true],
      [BigInt.from(2020).pow(5), true, true],
      [BigInt.parse('12345deadbeef', radix: 16), true, false],
    ];

    for (var arg in arguments) {
      final pk = PrivateKey(secret: arg[0]);
      final address = pk.point.getAddress(
        compressed: arg[1],
        testnet: arg[2],
      );
      final humanAddress = Base58Utils.humanReadable(
        encoded: address,
      );
      print(humanAddress);
    }
  }
}
