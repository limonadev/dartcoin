import 'package:crypto/crypto.dart';
import 'package:dartcoin/src/elliptic_curves.dart/s256_point.dart';
import 'package:dartcoin/src/signature/signature.dart';
import 'package:dartcoin/src/utils/all.dart';
import 'package:meta/meta.dart';
import 'package:pointycastle/src/utils.dart';

class PrivateKey {
  PrivateKey({
    @required this.secret,
  }) : point = Secp256Utils.generator * secret;

  final S256Point point;
  final BigInt secret;

  BigInt deterministicK(BigInt z) {
    var k = List.filled(32, 0);
    var v = List.filled(32, 1);

    var currZ = BigInt.parse(z.toRadixString(10));
    if (currZ > Secp256Utils.order) {
      currZ -= Secp256Utils.order;
    }

    var zBytes = encodeBigInt(currZ);
    var secretBytes = encodeBigInt(secret);

    var hmacSha256 = Hmac(sha256, k);
    k = hmacSha256.convert(
      [...v, 0, ...secretBytes, ...zBytes],
    ).bytes;
    v = hmacSha256.convert(v).bytes;
    k = hmacSha256.convert(
      [...v, 1, ...secretBytes, ...zBytes],
    ).bytes;
    v = hmacSha256.convert(v).bytes;

    BigInt result;
    while (result == null) {
      v = hmacSha256.convert(v).bytes;
      final candidate = decodeBigInt(v);

      k = hmacSha256.convert(
        [...v, 0, ...secretBytes, ...zBytes],
      ).bytes;
      v = hmacSha256.convert(v).bytes;

      if (candidate >= BigInt.one && candidate < Secp256Utils.prime) {
        result = candidate;
      }
    }

    return result;
  }

  Signature sign({@required BigInt z}) {
    final k = deterministicK(z);
    final r = (Secp256Utils.generator * k).x.value;
    final kInv = k.modPow(Secp256Utils.order - BigInt.two, Secp256Utils.order);
    var s = (z + r * secret) * kInv % Secp256Utils.order;

    s = s > Secp256Utils.order ~/ BigInt.two ? Secp256Utils.order - s : s;

    return Signature(r: r, s: s);
  }

  String toHex() {
    return ObjectUtils.toHex(secret);
  }
}
