import 'dart:typed_data';

import 'package:dartcoin/src/transaction/transaction_input.dart';
import 'package:dartcoin/src/transaction/transaction_output.dart';
import 'package:dartcoin/src/transaction/varint.dart';
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
  })  : assert(txIns != null),
        assert(txOuts != null);

  final BigInt locktime;
  final bool testnet;
  final List<TxInput> txIns;
  final List<TxOutput> txOuts;
  final BigInt version;

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

  Uint8List serialize() {
    final result = <int>[
      ...ObjectUtils.bigIntToBytes(
        number: version,
        endian: Endian.little,
        size: 4,
      ),
      ...Varint.encode(
        varint: BigInt.from(txIns.length),
      ),
    ];

    txIns.forEach((txIn) {
      result.addAll(txIn.serialize());
    });

    result.addAll(
      Varint.encode(
        varint: BigInt.from(txOuts.length),
      ),
    );

    txOuts.forEach((txOut) {
      result.addAll(txOut.serialize());
    });

    result.addAll(
      ObjectUtils.bigIntToBytes(
        number: locktime,
        endian: Endian.little,
        size: 4,
      ),
    );

    return Uint8List.fromList(result);
  }

  @override
  String toString() {
    final ins = txIns.join('\n');
    final outs = txOuts.join('\n');

    return 'Tx:\t$id \nVersion:\t$version \nTxIns:\t$ins \nTxOuts:\t$outs \nLocktime:\t$locktime';
  }
}
