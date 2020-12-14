import 'package:dartcoin/src/transaction/script.dart';
import 'package:meta/meta.dart';

class TxOutput {
  TxOutput({
    @required this.amount,
    @required this.scriptPubkey,
  });

  final BigInt amount;
  final Script scriptPubkey;

  @override
  String toString() {
    return '$amount $scriptPubkey';
  }
}
