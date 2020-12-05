import 'dart:typed_data';

import 'package:dartcoin/src/elliptic_curves.dart/point.dart';
import 'package:dartcoin/src/finite_field/s256_field_element.dart';
import 'package:dartcoin/src/models/operand.dart';
import 'package:dartcoin/src/signature/signature.dart';
import 'package:dartcoin/src/utils/all.dart';
import 'package:meta/meta.dart';

class S256Point extends Point {
  S256Point({
    @required Operand x,
    @required Operand y,
  }) : super(
          a: S256FieldElement(value: Secp256Utils.valueA),
          b: S256FieldElement(value: Secp256Utils.valueB),
          x: x.isInf ? Operand.infinity() : S256FieldElement(value: x.value),
          y: y.isInf ? Operand.infinity() : S256FieldElement(value: y.value),
        );

  factory S256Point.fromSerialized({@required Uint8List sec}) {
    S256FieldElement x, y;
    if (sec[0] == 4) {
      x = S256FieldElement(
        value: ObjectUtils.decodeBigInt(sec.sublist(1, 33)),
      );
      y = S256FieldElement(
        value: ObjectUtils.decodeBigInt(sec.sublist(33)),
      );
    } else {
      x = S256FieldElement(
        value: ObjectUtils.decodeBigInt(sec.sublist(1)),
      );

      final isEven = sec[0] == 2;

      S256FieldElement right =
          x.pow(3) + S256FieldElement(value: Secp256Utils.valueB);
      final left = right.sqrt();

      final evenSolution =
          left.value.isEven ? left.value : Secp256Utils.prime - left.value;
      final oddSolution =
          left.value.isOdd ? left.value : Secp256Utils.prime - left.value;

      y = S256FieldElement(value: isEven ? evenSolution : oddSolution);
    }

    return S256Point(x: x, y: y);
  }

  @override
  S256Point operator *(dynamic o) {
    BigInt other;

    if (o is int) {
      other = BigInt.from(o);
    } else if (o is BigInt) {
      other = o;
    } else if (o.runtimeType == Operand) {
      other = o.value;
    } else {
      throw ArgumentError(
        'Cannot multiply a S256Point with a ${o.runtimeType}',
      );
    }

    other = other % Secp256Utils.order;
    final result = super * (other);

    return S256Point(
      x: result.x,
      y: result.y,
    );
  }

  Uint8List sec({bool compressed = true}) {
    final prefix = compressed ? (y.value.isEven ? 2 : 3) : 4;

    return Uint8List.fromList(
      [
        prefix,
        ...ObjectUtils.bigIntToBytes(
          number: x.value,
          size: 32,
        ),
        ...compressed
            ? []
            : ObjectUtils.bigIntToBytes(
                number: y.value,
                size: 32,
              ),
      ],
    );
  }

  @override
  String toString() {
    return 'S256Point ($x $y)';
  }

  bool verify({
    @required Signature sig,
    @required BigInt z,
  }) {
    final sInv = sig.s.modPow(
      Secp256Utils.order - BigInt.two,
      Secp256Utils.order,
    );

    final u = (z * sInv) % Secp256Utils.order;
    final v = (sig.r * sInv) % Secp256Utils.order;

    return (Secp256Utils.generator * u + this * v).x.value == sig.r;
  }
}
