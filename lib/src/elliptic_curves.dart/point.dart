import 'package:dartcoin/src/models/operand.dart';
import 'package:dartcoin/src/utils/all.dart';
import 'package:meta/meta.dart';

@immutable
class Point {
  Point({
    @required this.a,
    @required this.b,
    @required this.x,
    @required this.y,
  }) : assert(
          (x.isInf && y.isInf) || (y.pow(2) == x.pow(3) + a * x + b),
          '($x,$y) is not in the curve',
        );

  factory Point.atInfinity({
    @required dynamic a,
    @required dynamic b,
  }) {
    Operand realA, realB;
    assert(
      (a is int || a is BigInt || a is Operand) &&
          (b is int || b is BigInt || b is Operand),
      'Point needs an [int], a [BigInt] or an [Operand] to be constructed',
    );

    if (a is int) realA = Operand(value: BigInt.from(a));
    if (b is int) realB = Operand(value: BigInt.from(b));

    if (a is BigInt) realA = Operand(value: a);
    if (b is BigInt) realB = Operand(value: b);

    realA ??= a;
    realB ??= b;

    return Point(
      a: realA,
      b: realB,
      x: Operand.infinity(),
      y: Operand.infinity(),
    );
  }

  factory Point.fromBigNumbers({
    @required BigInt a,
    @required BigInt b,
    @required BigInt x,
    @required BigInt y,
  }) {
    return Point(
      a: Operand(value: a),
      b: Operand(value: b),
      x: Operand(value: x),
      y: Operand(value: y),
    );
  }

  factory Point.fromNumbers({
    @required int a,
    @required int b,
    @required int x,
    @required int y,
  }) {
    return Point(
      a: Operand(value: BigInt.from(a)),
      b: Operand(value: BigInt.from(b)),
      x: Operand(value: BigInt.from(x)),
      y: Operand(value: BigInt.from(y)),
    );
  }

  final Operand a;
  final Operand b;
  final Operand x;
  final Operand y;

  @override
  int get hashCode => ObjectUtils.buildHashCode(
        [a, b, x, y],
      );

  bool get isPointAtInfinity => x.isInf;

  @override
  bool operator ==(dynamic other) {
    var result = false;

    if (other is Point) {
      result = _isSameCurve(other) && x == other.x && y == other.y;
    }

    return result;
  }

  Point operator +(Point other) {
    if (!_isSameCurve(other)) {
      throw ArgumentError('Points $this and $other are not on the same curve');
    }

    Point result;
    var a = this.a.copy();
    var b = this.b.copy();

    if (isPointAtInfinity) {
      result = other.copy();
    } else if (other.isPointAtInfinity) {
      result = copy();
    } else if (_isAdditiveInverseOf(other)) {
      result = buildAtInfiniteInstance(a: a, b: b);
    } else if (x != other.x) {
      var slope = (other.y - this.y) ~/ (other.x - this.x);
      var x = slope.pow(2) - this.x - other.x;
      var y = slope * (this.x - x) - this.y;

      result = buildInstanceWith(a: a, b: b, x: x, y: y);
    } else {
      /// Both points are the same point
      if (y.isZero) {
        result = buildAtInfiniteInstance(a: a, b: b);
      } else {
        var slope = (this.x.pow(2) * 3 + a) ~/ (this.y * 2);
        var x = slope.pow(2) - this.x * 2;
        var y = slope * (this.x - x) - this.y;

        result = buildInstanceWith(a: a, b: b, x: x, y: y);
      }
    }

    return result;
  }

  Point operator *(dynamic o) {
    BigInt other;

    if (o is int) {
      other = BigInt.from(o);
    } else if (o is BigInt) {
      other = o;
    } else if (o.runtimeType == Operand) {
      other = o.value;
    } else {
      throw ArgumentError(
        'Cannot multiply a Point with a ${o.runtimeType}',
      );
    }

    var current = copy();
    var result = buildAtInfiniteInstance(a: a.copy(), b: b.copy());

    while (other > BigInt.zero) {
      if (other & BigInt.one == BigInt.one) {
        result += current;
      }

      current += current;
      other >>= 1;
    }

    return result;
  }

  Point buildAtInfiniteInstance({
    @required Operand a,
    @required Operand b,
  }) {
    return Point.atInfinity(
      a: a,
      b: b,
    );
  }

  /// Method to mimic the inheritance of the Python examples by using __class__ from
  /// https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch02/answers.py#L107
  Point buildInstanceWith({
    @required Operand a,
    @required Operand b,
    @required Operand x,
    @required Operand y,
  }) {
    return Point(
      a: a,
      b: b,
      x: x,
      y: y,
    );
  }

  Point copy() {
    return Point(a: a, b: b, x: x, y: y);
  }

  @override
  String toString() {
    String result;
    if (isPointAtInfinity) {
      result = 'Point at infinity on curve ($a, $b)';
    } else {
      result = 'Point ($x, $y) on curve ($a, $b)';
    }
    return result;
  }

  bool _isAdditiveInverseOf(Point other) {
    return x == other.x && y != other.y;
  }

  bool _isSameCurve(Point other) {
    return a == other.a && b == other.b;
  }
}
