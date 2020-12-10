import 'dart:typed_data';

import 'package:dartcoin/src/utils/all.dart';
import 'package:meta/meta.dart';

@immutable
class Transaction {
  Transaction({
    @required this.locktime,
    @required this.testnet,
    @required this.txIns,
    @required this.txOuts,
    @required this.version,
  });

  final dynamic locktime;
  final bool testnet;
  final List<dynamic> txIns;
  final List<dynamic> txOuts;
  final int version;

  String get id => Base58Utils.humanReadable(
        encoded: hashed(),
      );

  static Future<Transaction> parse(Stream<int> stream) async {
    final stepsDone = [false];

    final acc = <int>[];
    int version;

    await for (var byte in stream) {
      acc.add(byte);
      if (acc.length == 4 && stepsDone[0] == false) {
        version = ObjectUtils.bytesToBigInt(
          bytes: Uint8List.fromList(acc),
          endian: Endian.little,
        ).toInt();

        acc.clear();
        stepsDone[0] = true;
      }
    }

    return Transaction(
      locktime: null,
      testnet: null,
      txIns: null,
      txOuts: null,
      version: version,
    );
  }

  /// TODO: CREATE A `serialize()` method, instead of passing a Fib seq
  Uint8List hashed() {
    return Uint8List.fromList(
      Secp256Utils.hash256(
        data: Uint8List.fromList([1, 1, 2, 3, 5]),
      ).reversed.toList(),
    );
  }

  @override
  String toString() {
    final ins = txIns.join('\n');
    final outs = txOuts.join('\n');

    return 'Tx:\t$id \nVersion:\t$version \nTxIns:\t$ins \nTxOuts:\t$outs \nLocktime:\t$locktime';
  }
}
