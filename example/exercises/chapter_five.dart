import 'dart:typed_data';

import 'package:dartcoin/dartcoin.dart';
import 'package:meta/meta.dart';

class ChapterFive {
  void runEverything({bool runOptionals = false}) async {
    print('Run each exercise from Chapter Five');

    await _first();

    if (runOptionals) {
      print('Optional exercises');
    }
  }

  Stream<int> _fakeSyncRead({@required Uint8List scriptPubKey}) async* {
    for (var byte in scriptPubKey) {
      yield byte;
    }
  }

  /// Exercise 1 from https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch04/Chapter5.ipynb
  void _first() async {
    print('First Exercise');

    final scriptPubKey = ObjectUtils.bigIntToBytes(
      number: BigInt.parse(
        '6b483045022100ed81ff192e75a3fd2304004dcadb746fa5e24c5031ccfcf21320b0277457c98f02207a986d955c6e0cb35d446a89d3f56100f4d7f67801c31967743a9c8e10615bed01210349fc4e631e3624a545de3f89f5d8684c7b8138bd94bdd531d2e213bf016b278a',
        radix: 16,
      ),
    );
    final stream = _fakeSyncRead(scriptPubKey: scriptPubKey);
    final script = await ScriptFactory.parse(stream);

    print(script);
  }
}
