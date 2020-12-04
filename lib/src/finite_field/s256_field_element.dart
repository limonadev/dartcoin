import 'package:dartcoin/src/models/operand.dart';
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
  String toString() {
    return 'S256FieldElement ${ObjectUtils.toHex(value: value)}';
  }
}
