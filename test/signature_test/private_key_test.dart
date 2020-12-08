import 'package:dartcoin/dartcoin.dart';
import 'package:test/test.dart';

void main() {
  /// Based on https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch03/ecc.py
  test('test_sign', () {
    final secret = Secp256Utils.bigRandom(max: Secp256Utils.order);

    final privateKey = PrivateKey(secret: secret);
    final z = Secp256Utils.bigRandom(max: BigInt.two.pow(256));

    final sig = privateKey.sign(z: z);

    expect(
      privateKey.point.verify(sig: sig, z: z),
      equals(true),
    );
  });

  /// Based on https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch04/ecc.py
  test('test_wif', () {
    // Secret, Compressed SEC, TestNet, Expected
    final arguments = [
      [
        BigInt.two.pow(256) - BigInt.two.pow(199),
        true,
        false,
        'L5oLkpV3aqBJ4BgssVAsax1iRa77G5CVYnv9adQ6Z87te7TyUdSC'
      ],
      [
        BigInt.two.pow(256) - BigInt.two.pow(201),
        false,
        true,
        '93XfLeifX7Jx7n7ELGMAf1SUR6f9kgQs8Xke8WStMwUtrDucMzn'
      ],
      [
        BigInt.parse(
          '0dba685b4511dbd3d368e5c4358a1277de9486447af7b3604a69b8d9d8b7889d',
          radix: 16,
        ),
        false,
        false,
        '5HvLFPDVgFZRK9cd4C5jcWki5Skz6fmKqi1GQJf5ZoMofid2Dty'
      ],
      [
        BigInt.parse(
          '1cca23de92fd1862fb5b76e5f4f50eb082165e5191e116c18ed1a6b24be6a53f',
          radix: 16,
        ),
        true,
        true,
        'cNYfWuhDpbNM1JWc3c6JTrtrFVxU4AGhUKgw5f93NP2QaBqmxKkg'
      ],
    ];

    for (final arg in arguments) {
      final privateKey = PrivateKey(
        secret: arg[0],
      );
      expect(
        Base58Utils.humanReadable(
          encoded: privateKey.wif(
            compressed: arg[1],
            testnet: arg[2],
          ),
        ),
        equals(arg[3]),
      );
    }
  });
}
