import 'dart:convert';
import 'dart:math';

import 'package:meta/meta.dart';
import 'package:dartcoin/dartcoin.dart';

class ChapterThree {
  void runEverything({bool runOptionals = false}) {
    print('Run each exercise from Chapter Three');
    _first();
    _second();
    _third();
    _fourth();
    _fifth();

    if (runOptionals) {
      print('Optional exercises');
      _optional_first();
      _optional_second();
      _optional_third();
      _optional_fourth();
      _optional_fifth();
      _optional_sixth();
    }
  }

  /// Exercise 4 from https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch03/Chapter3.ipynb
  void _first() {
    print('First Exercise');
    const prime = 223;

    final a = FieldElement.fromNumbers(prime: prime, value: 0);
    final b = FieldElement.fromNumbers(prime: prime, value: 7);
    final x = FieldElement.fromNumbers(prime: prime, value: 47);
    final y = FieldElement.fromNumbers(prime: prime, value: 71);

    final point = Point(a: a, b: b, x: x, y: y);

    for (var i = 1; i < 21; i++) {
      print(point * i);
    }
  }

  /// Exercise 5 from https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch03/Chapter3.ipynb
  void _second() {
    print('Second Exercise');
    const prime = 223;

    final a = FieldElement.fromNumbers(prime: prime, value: 0);
    final b = FieldElement.fromNumbers(prime: prime, value: 7);
    final x = FieldElement.fromNumbers(prime: prime, value: 15);
    final y = FieldElement.fromNumbers(prime: prime, value: 86);

    final point = Point(a: a, b: b, x: x, y: y);

    print(point * 7);
  }

  /// Exercise 5 from https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch03/Chapter3.ipynb
  void _third() {
    print('Third Exercise');

    final z = BigInt.parse(
      'bc62d4b80d9e36da29c16c5d4d9f11731f36052c72401a76c23c0fb5a9b74423',
      radix: 16,
    );
    final r = BigInt.parse(
      '37206a0610995c58074999cb9767b87af4c4978db68c06e8e6e81d282047a7c6',
      radix: 16,
    );
    final s = BigInt.parse(
      '8ca63759c1157ebeaec0d03cecca119fc9a75bf8e6d0fa65c841c8e2738cdaec',
      radix: 16,
    );
    final px = Operand.fromHex(
      hex: '04519fac3d910ca7e7138f7013706f619fa8f033e6ec6e09370ea38cee6a7574',
      radix: 16,
    );
    final py = Operand.fromHex(
      hex: '82b51eab8c27c66e26c858a079bcdf4f1ada34cec420cafc7eac1a42216fb6c4',
      radix: 16,
    );

    final point = S256Point(x: px, y: py);
    final sInv = s.modPow(Secp256Utils.order - BigInt.two, Secp256Utils.order);

    final u = (z * sInv) % Secp256Utils.order;
    final v = (r * sInv) % Secp256Utils.order;

    print((Secp256Utils.generator * u + point * v).x.value == r);
  }

  /// Exercise 6 from https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch03/Chapter3.ipynb
  void _fourth() {
    print('Fourth Exercise');

    final point = S256Point(
      x: Operand.fromHex(
        hex: '887387e452b8eacc4acfde10d9aaf7f6d9a0f975aabb10d006e4da568744d06c',
        radix: 16,
      ),
      y: Operand.fromHex(
        hex: '61de6d95231cd89026e286df3b6ae4a894a3378e393e93a0f45b666329a0ae34',
        radix: 16,
      ),
    );

    var z = BigInt.parse(
      'ec208baa0fc1c19f708a9ca96fdeff3ac3f230bb4a7ba4aede4942ad003c0f60',
      radix: 16,
    );
    var r = BigInt.parse(
      'ac8d1c87e51d0d441be8b3dd5b05c8795b48875dffe00b7ffcfac23010d3a395',
      radix: 16,
    );
    var s = BigInt.parse(
      '68342ceff8935ededd102dd876ffd6ba72d6a427a3edb13d26eb0781cb423c4',
      radix: 16,
    );
    print(
      _isValidSignature(point: point, r: r, s: s, z: z),
    );

    z = BigInt.parse(
      '7c076ff316692a3d7eb3c3bb0f8b1488cf72e1afcd929e29307032997a838a3d',
      radix: 16,
    );
    r = BigInt.parse(
      'eff69ef2b1bd93a66ed5219add4fb51e11a840f404876325a1e8ffe0529a2c',
      radix: 16,
    );
    s = BigInt.parse(
      'c7207fee197d27c618aea621406f6bf5ef6fca38681d82b2f06fddbdce6feab6',
      radix: 16,
    );
    print(
      _isValidSignature(point: point, r: r, s: s, z: z),
    );
  }

  /// Exercise 7 from https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch03/Chapter3.ipynb
  void _fifth() {
    print('Fifth Exercise');

    final e = BigInt.from(12345);
    final z = ObjectUtils.decodeBigInt(
      Secp256Utils.hash256(
        data: utf8.encode('Programming Bitcoin!'),
      ),
    );

    // NEVER GENERATE K FROM THE RANDOM LIBRARY, THIS WAS ONLY WITH
    // EDUCATIONAL PURPOSES
    final k = BigInt.from(Random().nextInt(10000000));
    final r = (Secp256Utils.generator * k).x.value;
    final kInv = k.modPow(Secp256Utils.order - BigInt.two, Secp256Utils.order);
    final s = (z + r * e) * kInv % Secp256Utils.order;

    final point = Secp256Utils.generator * e;

    print(point);
    print(z.toRadixString(16));
    print(r.toRadixString(16));
    print(s.toRadixString(16));
  }

  /// Exercise 1 from Programming Bitcoin book - Chapter 3
  void _optional_first() {
    print('Optional First Exercise');

    const prime = 223;
    final b = FieldElement.fromNumbers(prime: prime, value: 7);

    var points = [
      [192, 105],
      [17, 56],
      [200, 119],
      [1, 193],
      [42, 99]
    ];

    for (var p in points) {
      var x = FieldElement.fromNumbers(prime: prime, value: p[0]);
      var y = FieldElement.fromNumbers(prime: prime, value: p[1]);

      print(y.pow(2) == x.pow(3) + b);
    }
  }

  /// Exercise 2 from Programming Bitcoin book - Chapter 3
  void _optional_second() {
    print('Optional Second Exercise');

    const prime = 223;
    final a = FieldElement.fromNumbers(prime: prime, value: 0);
    final b = FieldElement.fromNumbers(prime: prime, value: 7);

    var pointsA = [
      [192, 105],
      [170, 142],
      [47, 71],
      [143, 98]
    ];
    var pointsB = [
      [17, 56],
      [60, 139],
      [17, 56],
      [76, 66]
    ];

    for (var i = 0; i < pointsA.length; i++) {
      var p1 = pointsA[i];
      var p2 = pointsB[i];

      var first = Point(
        a: a,
        b: b,
        x: FieldElement.fromNumbers(prime: prime, value: p1[0]),
        y: FieldElement.fromNumbers(prime: prime, value: p1[1]),
      );
      var second = Point(
        a: a,
        b: b,
        x: FieldElement.fromNumbers(prime: prime, value: p2[0]),
        y: FieldElement.fromNumbers(prime: prime, value: p2[1]),
      );

      print(first + second);
    }
  }

  /// Exercise 5 from Programming Bitcoin book - Chapter 3
  void _optional_third() {
    print('Optional Third Exercise');

    const prime = 223;
    final a = FieldElement.fromNumbers(prime: prime, value: 0);
    final b = FieldElement.fromNumbers(prime: prime, value: 7);

    final genPoint = Point(
      a: a,
      b: b,
      x: FieldElement.fromNumbers(prime: prime, value: 15),
      y: FieldElement.fromNumbers(prime: prime, value: 86),
    );

    var sum = genPoint.copy();

    var order = 1;
    while (!sum.isPointAtInfinity) {
      sum += genPoint;
      order++;
    }

    print(order);
  }

  /// Exercise on page 60 from Programming Bitcoin book - Chapter 3
  void _optional_fourth() {
    final gx = BigInt.parse(
      '79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798',
      radix: 16,
    );
    final gy = BigInt.parse(
      '483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8',
      radix: 16,
    );
    final p = BigInt.two.pow(256) - BigInt.two.pow(32) - BigInt.from(977);
    final n = BigInt.parse(
      'fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141',
      radix: 16,
    );
    final x = FieldElement(prime: p, value: gx);
    final y = FieldElement(prime: p, value: gy);
    final g = Point(
      a: FieldElement(prime: p, value: BigInt.zero),
      b: FieldElement(prime: p, value: BigInt.from(7)),
      x: x,
      y: y,
    );

    print(g * n);
  }

  /// Exercise on page 61 from Programming Bitcoin book - Chapter 3
  void _optional_fifth() {
    print('Optional Fifth Exercise');

    print(Secp256Utils.generator * Secp256Utils.order);
  }

  /// Exercise on page 69 from Programming Bitcoin book - Chapter 3
  void _optional_sixth() {
    print('Optional Sixth Exercise');
    final e = ObjectUtils.decodeBigInt(
      Secp256Utils.hash256(
        data: utf8.encode('my secret'),
      ),
    );
    final z = ObjectUtils.decodeBigInt(
      Secp256Utils.hash256(
        data: utf8.encode('my message'),
      ),
    );

    final k = BigInt.from(1234567890);
    final r = (Secp256Utils.generator * k).x.value;
    final kInv = k.modPow(Secp256Utils.order - BigInt.two, Secp256Utils.order);
    final s = (z + r * e) * kInv % Secp256Utils.order;

    final point = Secp256Utils.generator * e;

    print(point);
    print(z.toRadixString(16));
    print(r.toRadixString(16));
    print(s.toRadixString(16));
  }

  bool _isValidSignature({
    @required S256Point point,
    @required BigInt r,
    @required BigInt s,
    @required BigInt z,
  }) {
    final sInv = s.modPow(Secp256Utils.order - BigInt.two, Secp256Utils.order);

    final u = (z * sInv) % Secp256Utils.order;
    final v = (r * sInv) % Secp256Utils.order;

    return (Secp256Utils.generator * u + point * v).x.value == r;
  }
}
