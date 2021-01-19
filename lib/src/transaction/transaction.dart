import 'dart:typed_data';

import 'package:dartcoin/src/script/all.dart';
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

  String get id => ObjectUtils.toHex(
        value: ObjectUtils.bytesToBigInt(
          bytes: hashed(),
        ),
      );

  /// TODO: This method is very similar to the [serialize] method.
  /// Is it possible to reduce thee code duplication?
  Future<BigInt> getSigHash({@required int inputIndex}) async {
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

    for (var i = 0; i < txIns.length; i++) {
      final txIn = txIns[i];
      if (i == inputIndex) {
        final scriptPubKey = await txIn.scriptPubKey(
          testnet: testnet,
        );
        result.addAll(
          txIn.copyWith(scriptSig: scriptPubKey).serialize(),
        );
      } else {
        result.addAll(
          txIn.serialize(ignoreScriptSig: true),
        );
      }
    }

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
    result.addAll(
      TransactionUtils.hashTypeBytes(
        hashType: HashType.sigHashAll,
      ),
    );
    final serialized = Uint8List.fromList(result);

    final hashed = Secp256Utils.hash256(data: serialized);
    return ObjectUtils.bytesToBigInt(bytes: hashed);
  }

  Future<BigInt> getFee() async {
    var totalIn = BigInt.zero;
    for (final txIn in txIns) {
      totalIn += await txIn.outputValue(testnet: testnet);
    }

    var totalOut = BigInt.zero;
    txOuts.forEach((txOut) {
      totalOut += txOut.amount;
    });

    return totalIn - totalOut;
  }

  Uint8List hashed() {
    return Uint8List.fromList(
      Secp256Utils.hash256(
        data: serialize(),
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
  Future<bool> verifyInput({@required int inputIndex}) async {
    final scriptSig = txIns[inputIndex].scriptSig;
    final scriptPubKey = await txIns[inputIndex].scriptPubKey(
      testnet: testnet,
    );
    final signatureHash = await getSigHash(
      inputIndex: inputIndex,
    );

    final executor = ScriptExecutor(
      message: signatureHash,
    );
    return executor.runBoth(
      first: scriptSig,
      second: scriptPubKey,
    );
  }
}
