import 'dart:typed_data';

import 'package:dartcoin/src/transaction/transaction_input.dart';
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
  }) : assert(txIns != null);

  final dynamic locktime;
  final bool testnet;
  final List<TxInput> txIns;
  final List<dynamic> txOuts;
  final int version;

  String get id => Base58Utils.humanReadable(
        encoded: hashed(),
      );

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
