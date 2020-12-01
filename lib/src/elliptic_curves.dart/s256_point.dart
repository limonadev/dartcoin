import 'package:dartcoin/src/elliptic_curves.dart/point.dart';
import 'package:dartcoin/src/finite_field/s256_field_element.dart';
import 'package:dartcoin/src/utils/all.dart';
import 'package:meta/meta.dart';

class S256Point extends Point {
  S256Point({
    @required S256FieldElement x,
    @required S256FieldElement y,
  }) : super(
          a: S256FieldElement(value: Secp256Utils.valueA),
          b: S256FieldElement(value: Secp256Utils.valueB),
          x: x,
          y: y,
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
    final multi = super * (other);

    return S256Point(
      x: !multi.x.isInf
          ? S256FieldElement(value: multi.x.value)
          : S256FieldElement.infinity(),
      y: !multi.y.isInf
          ? S256FieldElement(value: multi.y.value)
          : S256FieldElement.infinity(),
    );
  }
}
