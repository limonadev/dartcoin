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
}
