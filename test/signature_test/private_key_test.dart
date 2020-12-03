import 'package:dartcoin/dartcoin.dart';
import 'package:test/test.dart';

void main() {
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
}
