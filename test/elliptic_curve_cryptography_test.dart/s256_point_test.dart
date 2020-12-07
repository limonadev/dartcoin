import 'package:dartcoin/dartcoin.dart';
import 'package:dartcoin/src/signature/signature.dart';
import 'package:test/test.dart';

void main() {
  test('test_order', () {
    final point = Secp256Utils.generator * Secp256Utils.order;

    expect(
      point.isPointAtInfinity,
      equals(true),
    );
  });

  test('test_pubpoint', () {
    final points = [
      [
        7,
        Operand.fromHex(
          hex:
              '5cbdf0646e5db4eaa398f365f2ea7a0e3d419b7e0330e39ce92bddedcac4f9bc',
          radix: 16,
        ),
        Operand.fromHex(
          hex:
              '6aebca40ba255960a3178d6d861a54dba813d0b813fde7b5a5082628087264da',
          radix: 16,
        )
      ],
      [
        1485,
        Operand.fromHex(
          hex:
              'c982196a7466fbbbb0e27a940b6af926c1a74d5ad07128c82824a11b5398afda',
          radix: 16,
        ),
        Operand.fromHex(
          hex:
              '7a91f9eae64438afb9ce6448a1c133db2d8fb9254e4546b6f001637d50901f55',
          radix: 16,
        )
      ],
      [
        BigInt.two.pow(128),
        Operand.fromHex(
          hex:
              '8f68b9d2f63b5f339239c1ad981f162ee88c5678723ea3351b7b444c9ec4c0da',
          radix: 16,
        ),
        Operand.fromHex(
          hex:
              '662a9f2dba063986de1d90c2b6be215dbbea2cfe95510bfdf23cbf79501fff82',
          radix: 16,
        )
      ],
      [
        BigInt.two.pow(240) + BigInt.two.pow(31),
        Operand.fromHex(
          hex:
              '9577ff57c8234558f293df502ca4f09cbc65a6572c842b39b366f21717945116',
          radix: 16,
        ),
        Operand.fromHex(
          hex:
              '10b49c67fa9365ad7b90dab070be339a1daf9052373ec30ffae4f72d5e66d053',
          radix: 16,
        )
      ],
    ];

    for (var p in points) {
      final point = S256Point(x: p[1], y: p[2]);
      expect(
        Secp256Utils.generator * p[0],
        equals(point),
      );
    }
  });

  test('test_verify', () {
    final point = S256Point(
      x: Operand.fromHex(
        hex: '887387e452b8eacc4acfde10d9aaf7f6d9a0f975aabb10d006e4da568744d06c',
        radix: 16,
      ),
      y: Operand.fromHex(
        hex: '61de6d95231cd89026e286df3b6ae4a894a3378e393e93a0f45b666329a0ae34',
        radix: 16,
      ),
    );

    var z = BigInt.parse(
      'ec208baa0fc1c19f708a9ca96fdeff3ac3f230bb4a7ba4aede4942ad003c0f60',
      radix: 16,
    );
    var r = BigInt.parse(
      'ac8d1c87e51d0d441be8b3dd5b05c8795b48875dffe00b7ffcfac23010d3a395',
      radix: 16,
    );
    var s = BigInt.parse(
      '68342ceff8935ededd102dd876ffd6ba72d6a427a3edb13d26eb0781cb423c4',
      radix: 16,
    );

    expect(
      point.verify(sig: Signature(r: r, s: s), z: z),
      equals(true),
    );

    z = BigInt.parse(
      '7c076ff316692a3d7eb3c3bb0f8b1488cf72e1afcd929e29307032997a838a3d',
      radix: 16,
    );
    r = BigInt.parse(
      'eff69ef2b1bd93a66ed5219add4fb51e11a840f404876325a1e8ffe0529a2c',
      radix: 16,
    );
    s = BigInt.parse(
      'c7207fee197d27c618aea621406f6bf5ef6fca38681d82b2f06fddbdce6feab6',
      radix: 16,
    );

    expect(
      point.verify(sig: Signature(r: r, s: s), z: z),
      equals(true),
    );
  });

  test('test_sec', () {
    var coefficient = BigInt.from(999).pow(3);
    var point = Secp256Utils.generator * coefficient;
    var uncompressed = BigInt.parse(
      '049d5ca49670cbe4c3bfa84c96a8c87df086c6ea6a24ba6b809c9de234496808d56fa15cc7f3d38cda98dee2419f415b7513dde1301f8643cd9245aea7f3f911f9',
      radix: 16,
    );
    var compressed = BigInt.parse(
      '039d5ca49670cbe4c3bfa84c96a8c87df086c6ea6a24ba6b809c9de234496808d5',
      radix: 16,
    );
    expect(
      point.sec(compressed: false),
      ObjectUtils.bigIntToBytes(
        number: uncompressed,
        size: 65,
      ),
    );
    expect(
      point.sec(compressed: true),
      ObjectUtils.bigIntToBytes(
        number: compressed,
        size: 33,
      ),
    );

    coefficient = BigInt.from(123);
    point = Secp256Utils.generator * coefficient;
    uncompressed = BigInt.parse(
      '04a598a8030da6d86c6bc7f2f5144ea549d28211ea58faa70ebf4c1e665c1fe9b5204b5d6f84822c307e4b4a7140737aec23fc63b65b35f86a10026dbd2d864e6b',
      radix: 16,
    );
    compressed = BigInt.parse(
      '03a598a8030da6d86c6bc7f2f5144ea549d28211ea58faa70ebf4c1e665c1fe9b5',
      radix: 16,
    );
    expect(
      point.sec(compressed: false),
      ObjectUtils.bigIntToBytes(
        number: uncompressed,
        size: 65,
      ),
    );
    expect(
      point.sec(compressed: true),
      ObjectUtils.bigIntToBytes(
        number: compressed,
        size: 33,
      ),
    );

    coefficient = BigInt.from(42424242);
    point = Secp256Utils.generator * coefficient;
    uncompressed = BigInt.parse(
      '04aee2e7d843f7430097859e2bc603abcc3274ff8169c1a469fee0f20614066f8e21ec53f40efac47ac1c5211b2123527e0e9b57ede790c4da1e72c91fb7da54a3',
      radix: 16,
    );
    compressed = BigInt.parse(
      '03aee2e7d843f7430097859e2bc603abcc3274ff8169c1a469fee0f20614066f8e',
      radix: 16,
    );
    expect(
      point.sec(compressed: false),
      ObjectUtils.bigIntToBytes(
        number: uncompressed,
        size: 65,
      ),
    );
    expect(
      point.sec(compressed: true),
      ObjectUtils.bigIntToBytes(
        number: compressed,
        size: 33,
      ),
    );
  });

  test('test_address', () {
    var secret = BigInt.from(888).pow(3);
    var mainnetAddress = '148dY81A9BmdpMhvYEVznrM45kWN32vSCN';
    var testnetAddress = 'mieaqB68xDCtbUBYFoUNcmZNwk74xcBfTP';
    var point = Secp256Utils.generator * secret;

    expect(
      Base58Utils.humanReadable(
        encoded: point.getAddress(compressed: true, testnet: false),
      ),
      equals(mainnetAddress),
    );
    expect(
      Base58Utils.humanReadable(
        encoded: point.getAddress(compressed: true, testnet: true),
      ),
      equals(testnetAddress),
    );

    secret = BigInt.from(321);
    mainnetAddress = '1S6g2xBJSED7Qr9CYZib5f4PYVhHZiVfj';
    testnetAddress = 'mfx3y63A7TfTtXKkv7Y6QzsPFY6QCBCXiP';
    point = Secp256Utils.generator * secret;

    expect(
      Base58Utils.humanReadable(
        encoded: point.getAddress(compressed: false, testnet: false),
      ),
      equals(mainnetAddress),
    );
    expect(
      Base58Utils.humanReadable(
        encoded: point.getAddress(compressed: false, testnet: true),
      ),
      equals(testnetAddress),
    );

    secret = BigInt.from(4242424242);
    mainnetAddress = '1226JSptcStqn4Yq9aAmNXdwdc2ixuH9nb';
    testnetAddress = 'mgY3bVusRUL6ZB2Ss999CSrGVbdRwVpM8s';
    point = Secp256Utils.generator * secret;

    expect(
      Base58Utils.humanReadable(
        encoded: point.getAddress(compressed: false, testnet: false),
      ),
      equals(mainnetAddress),
    );
    expect(
      Base58Utils.humanReadable(
        encoded: point.getAddress(compressed: false, testnet: true),
      ),
      equals(testnetAddress),
    );
  });
}
