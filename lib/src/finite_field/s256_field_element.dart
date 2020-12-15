import 'package:dartcoin/src/models/all.dart';
import 'package:dartcoin/src/utils/all.dart';
import 'package:meta/meta.dart';
import 'package:dartcoin/src/finite_field/field_element.dart';

class S256FieldElement extends FieldElement {
  S256FieldElement({@required BigInt value})
      : super(
          prime: Secp256Utils.prime,
          value: value,
        );

  factory S256FieldElement.infinity() => S256FieldElement(
        value: Operand.INF,
      );

  @override
  S256FieldElement buildInstanceWith({
    @required BigInt value,
    @required BigInt prime,
  }) {
    return S256FieldElement(
      value: value,
    );
  }

  @override
  FieldElement copy() {
    return S256FieldElement(value: value);
  }

  S256FieldElement sqrt() {
    return pow((prime + BigInt.one) / BigInt.from(4));
  }

  @override
  String toString() {
    return 'S256FieldElement ${ObjectUtils.toHex(padding: 64, value: value)}';
  }
}
