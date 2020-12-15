import 'package:dartcoin/src/transaction/all.dart';

class Registry {
  factory Registry() {
    return _registry;
  }

  Registry._internal()
      : _components = {
          _TxFetcherTag: BitcoinTxFetcher(),
        };

  static final Registry _registry = Registry._internal();

  static final _TxFetcherTag = 'TxFetcher';

  final Map<String, TxFetcher> _components;

  TxFetcher get txFetcher => _components[_TxFetcherTag];
  set txFetcher(TxFetcher txFetcher) => _components[_TxFetcherTag] = txFetcher;
}
