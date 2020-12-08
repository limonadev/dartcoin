import 'dart:typed_data';

import 'package:dartcoin/src/elliptic_curves.dart/s256_point.dart';
import 'package:dartcoin/src/signature/signature.dart';
import 'package:dartcoin/src/utils/all.dart';
import 'package:hash/hash.dart';
import 'package:meta/meta.dart';

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

    var zBytes = ObjectUtils.bigIntToBytes(
      number: currZ,
      size: 32,
    );
    var secretBytes = ObjectUtils.bigIntToBytes(
      number: secret,
      size: 32,
    );

    var hmacSha256 = Hmac(SHA256(), k);
    k = hmacSha256.update(
      [...v, 0, ...secretBytes, ...zBytes],
    ).digest();
    v = hmacSha256.update(v).digest();
    k = hmacSha256.update(
      [...v, 1, ...secretBytes, ...zBytes],
    ).digest();
    v = hmacSha256.update(v).digest();

    BigInt result;
    while (result == null) {
      v = hmacSha256.update(v).digest();
      final candidate = ObjectUtils.decodeBigInt(v);

      k = hmacSha256.update(
        [...v, 0, ...secretBytes, ...zBytes],
      ).digest();
      v = hmacSha256.update(v).digest();

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
    return ObjectUtils.toHex(value: secret);
  }

  Uint8List wif({
    bool compressed = true,
    bool testnet = true,
  }) {
    final encodedSecret = ObjectUtils.bigIntToBytes(
      number: secret,
      size: 32,
    );
    final prefix = testnet ? 0xef : 0x80;
    final bytes = [prefix, ...encodedSecret];

    if (compressed) {
      bytes.add(0x01);
    }

    return Base58Utils.encodeChecksum(
      bytes: Uint8List.fromList(bytes),
    );
  }
}
