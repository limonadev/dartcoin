import 'package:dartcoin/src/elliptic_curves.dart/point.dart';
import 'package:dartcoin/src/finite_field/s256_field_element.dart';
import 'package:dartcoin/src/models/operand.dart';
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

  @override
  S256Point operator *(dynamic o) {
    BigInt other;

    if (o is int) {
      other = BigInt.from(o);
    } else if (o is BigInt) {
      other = o;
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
}
