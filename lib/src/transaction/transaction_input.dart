import 'dart:typed_data';

import 'package:dartcoin/src/components/registry.dart';
import 'package:dartcoin/src/transaction/transaction.dart';
import 'package:dartcoin/src/utils/all.dart';
import 'package:meta/meta.dart';
import 'package:dartcoin/src/script/all.dart';

class TxInput {
  TxInput({
    @required this.prevTxId,
    @required this.prevTxIndex,
    @required Script scriptSig,
    @required BigInt sequence,
  })  : scriptSig = scriptSig ?? Script(cmds: null),
        sequence = sequence ??
            BigInt.parse(
              'ffffffff',
              radix: 16,
            );

  /// The [prevTxId] is stored as a list of bytes, when is necessary to
  /// decode it ensure setting [Endian.little] as part of the process.
  final Uint8List prevTxId;
  final BigInt prevTxIndex;
  final Script scriptSig;
  final BigInt sequence;

  /// Returns the [Transaction] from which this instance is an Utxo.
  Future<Transaction> fetchTx({testnet = true}) {
    return Registry().txFetcher.fetch(
          hexTxId: ObjectUtils.bytesToHex(
            bytes: prevTxId,
            endian: Endian.little,
          ),
          testnet: testnet,
        );
  }

  /// Returns the amount of Satoshis its Utxo has.
  Future<BigInt> outputValue({testnet = true}) async {
    final tx = await fetchTx(testnet: testnet);
    return tx.txOuts[prevTxIndex.toInt()].amount;
  }

  Future<Script> scriptPubKey({testnet = true}) async {
    final tx = await fetchTx(testnet: testnet);
    return tx.txOuts[prevTxIndex.toInt()].scriptPubkey;
  }

  Uint8List serialize() {
    final result = <int>[
      ...prevTxId,
      ...ObjectUtils.bigIntToBytes(
        number: prevTxIndex,
        endian: Endian.little,
        size: 4,
      ),
      ...scriptSig.serialize(),
      ...ObjectUtils.bigIntToBytes(
        number: sequence,
        endian: Endian.little,
        size: 4,
      ),
    ];

    return Uint8List.fromList(result);
  }

  @override
  String toString() {
    final id = ObjectUtils.bytesToBigInt(
      bytes: prevTxId,
      endian: Endian.little,
    );
    return '${ObjectUtils.toHex(padding: 64, value: id)}:$prevTxIndex';
  }
}
