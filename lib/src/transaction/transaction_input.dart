import 'package:dartcoin/src/utils/all.dart';
import 'package:meta/meta.dart';
import 'package:dartcoin/src/transaction/script.dart';

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

  final BigInt prevTxId;
  final BigInt prevTxIndex;
  final Script scriptSig;
  final BigInt sequence;

  @override
  String toString() {
    return '${ObjectUtils.toHex(value: prevTxId)}:$prevTxIndex';
  }
}
