import 'dart:math';

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
          (x == INF && y == INF) || (pow(y, 2) == pow(x, 3) + a * x + b),
          '($x,$y) is not in the curve',
        );

  factory Point.atInfinity({
    @required int a,
    @required int b,
  }) {
    return Point(
      a: a,
      b: b,
      x: Point.INF,
      y: Point.INF,
    );
  }

  static const int INF = null;

  final int a;
  final int b;
  final int x;
  final int y;

  @override
  int get hashCode => ObjectUtils.buildHashCode(
        [a, b, x, y],
      );

  bool get isPointAtInfinity => x == INF;

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
    if (isPointAtInfinity) {
      result = other.copy();
    } else if (other.isPointAtInfinity) {
      result = copy();
    } else if (_isAdditiveInverseOf(other)) {
      result = Point.atInfinity(a: a, b: b);
    }

    return result;
  }

  Point copy() {
    return Point(a: a, b: b, x: x, y: y);
  }

  @override
  String toString() {
    return 'Point ($x, $y) on curve ($a, $b)';
  }

  bool _isAdditiveInverseOf(Point other) {
    return x == other.x && y != other.y;
  }

  bool _isSameCurve(Point other) {
    return a == other.a && b == other.b;
  }
}
