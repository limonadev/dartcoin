import 'package:dartcoin/dartcoin.dart';

class ChapterSix {
  void runEverything({bool runOptionals = false}) {
    print('Run each exercise from Chapter Six');

    _first();

    if (runOptionals) {
      print('Optional exercises');
    }
  }

  /// Exercise 1 from https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch06/Chapter6.ipynb
  void _first() {
    print('First Exercise');

    final message = BigInt.parse(
      '7c076ff316692a3d7eb3c3bb0f8b1488cf72e1afcd929e29307032997a838a3d',
      radix: 16,
    );

    final sec = ObjectUtils.bytesFromHex(
      hex:
          '04887387e452b8eacc4acfde10d9aaf7f6d9a0f975aabb10d006e4da568744d06c61de6d95231cd89026e286df3b6ae4a894a3378e393e93a0f45b666329a0ae34',
    );
    final der = ObjectUtils.bytesFromHex(
      hex:
          '3045022000eff69ef2b1bd93a66ed5219add4fb51e11a840f404876325a1e8ffe0529a2c022100c7207fee197d27c618aea621406f6bf5ef6fca38681d82b2f06fddbdce6feab601',
    );

    final scriptPubKey = Script(
      cmds: [sec, OpCode.OP_CHECKSIG.byte],
    );
    final scriptSig = Script(
      cmds: [der],
    );

    final scriptExecutor = ScriptExecutor(
      message: message,
    );

    print(
      scriptExecutor.runBoth(
        first: scriptSig,
        second: scriptPubKey,
      ),
    );
  }
}
