import 'package:dartcoin/src/utils/all.dart';
import 'package:meta/meta.dart';

//TODO: Migrate to latest Dart SDK to enable null safety

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

  FieldElement operator +(FieldElement other) {
    if (prime != other.prime) {
      throw ArgumentError('Cannot add two numbers in different Fields');
    }
    var number = (this.number + other.number) % prime;
    return FieldElement(number: number, prime: prime);
  }

  FieldElement operator -(FieldElement other) {
    if (prime != other.prime) {
      throw ArgumentError('Cannot subtract two numbers in different Fields');
    }
    var number = (this.number - other.number) % prime;
    return FieldElement(number: number, prime: prime);
  }

  @override
  String toString() {
    return 'FieldElement_$prime($number)';
  }
}
