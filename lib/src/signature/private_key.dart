import 'dart:math';

import 'package:dartcoin/src/elliptic_curves.dart/s256_point.dart';
import 'package:dartcoin/src/signature/signature.dart';
import 'package:dartcoin/src/utils/all.dart';
import 'package:meta/meta.dart';

class PrivateKey {
  PrivateKey({
    @required this.secret,
  }) : point = Secp256Utils.generator * secret;

  final S256Point point;
  final BigInt secret;

  Signature sign({@required BigInt z}) {
    // NEVER GENERATE K FROM THE RANDOM LIBRARY, THIS WAS ONLY WITH
    // EDUCATIONAL PURPOSES
    final k = BigInt.from(Random().nextInt(10000000));
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
