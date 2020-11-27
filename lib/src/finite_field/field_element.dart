import 'package:dartcoin/src/utils/all.dart';
import 'package:meta/meta.dart';

class FieldElement {
  FieldElement({
    @required this.number,
    @required this.prime,
  })  : assert(number >= 0),
        assert(number < prime);

  final int number;
  final int prime;

  @override
  int get hashCode => ObjectUtils.buildHashCode([number, prime]);

  @override
  bool operator ==(dynamic other) {
    var result = false;

    if (other is FieldElement) {
      result = number == other.number && prime == other.prime;
    }

    return result;
  }

  @override
  String toString() {
    return 'FieldElement_$prime($number)';
  }
}
