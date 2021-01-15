import 'package:dartcoin/dartcoin.dart';

class ChapterSix {
  void runEverything({bool runOptionals = false}) {
    print('Run each exercise from Chapter Six');

    _first();
    _second();
    _third();

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

  /// Exercise 3 from https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch06/Chapter6.ipynb
  void _second() {
    print('Second Exercise');

    final scriptPubKey = Script(
      cmds: [
        OpCode.OP_DUP.byte,
        OpCode.OP_DUP.byte,
        OpCode.OP_MUL.byte,
        OpCode.OP_ADD.byte,
        OpCode.OP_6.byte,
        OpCode.OP_EQUAL.byte,
      ],
    );
    final scriptSig = Script(
      cmds: [OpCode.OP_2.byte],
    );

    final scriptExecutor = ScriptExecutor();

    print(
      scriptExecutor.runBoth(
        first: scriptSig,
        second: scriptPubKey,
      ),
    );
  }

  /// Exercise 4 from https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch06/Chapter6.ipynb
  void _third() {
    print('Third Exercise');

    final firstCollision = ObjectUtils.bytesFromHex(
      hex:
          '255044462d312e330a25e2e3cfd30a0a0a312030206f626a0a3c3c2f57696474682032203020522f4865696768742033203020522f547970652034203020522f537562747970652035203020522f46696c7465722036203020522f436f6c6f7253706163652037203020522f4c656e6774682038203020522f42697473506572436f6d706f6e656e7420383e3e0a73747265616d0affd8fffe00245348412d3120697320646561642121212121852fec092339759c39b1a1c63c4c97e1fffe017f46dc93a6b67e013b029aaa1db2560b45ca67d688c7f84b8c4c791fe02b3df614f86db1690901c56b45c1530afedfb76038e972722fe7ad728f0e4904e046c230570fe9d41398abe12ef5bc942be33542a4802d98b5d70f2a332ec37fac3514e74ddc0f2cc1a874cd0c78305a21566461309789606bd0bf3f98cda8044629a1',
    );
    final secondCollision = ObjectUtils.bytesFromHex(
      hex:
          '255044462d312e330a25e2e3cfd30a0a0a312030206f626a0a3c3c2f57696474682032203020522f4865696768742033203020522f547970652034203020522f537562747970652035203020522f46696c7465722036203020522f436f6c6f7253706163652037203020522f4c656e6774682038203020522f42697473506572436f6d706f6e656e7420383e3e0a73747265616d0affd8fffe00245348412d3120697320646561642121212121852fec092339759c39b1a1c63c4c97e1fffe017346dc9166b67e118f029ab621b2560ff9ca67cca8c7f85ba84c79030c2b3de218f86db3a90901d5df45c14f26fedfb3dc38e96ac22fe7bd728f0e45bce046d23c570feb141398bb552ef5a0a82be331fea48037b8b5d71f0e332edf93ac3500eb4ddc0decc1a864790c782c76215660dd309791d06bd0af3f98cda4bc4629b1',
    );

    final collisionScript = Script(
      cmds: [firstCollision, secondCollision],
    );

    final mainScript = ScriptFactory.parseSync(
      bytes: ObjectUtils.bytesFromHex(
        hex: '086e879169a77ca787',
      ),
    ).result;
    final scriptExecutor = ScriptExecutor();

    final result = scriptExecutor.runBoth(
      first: collisionScript,
      second: mainScript,
    );
    print(result);
  }
}
