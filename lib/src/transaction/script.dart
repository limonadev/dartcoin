import 'dart:typed_data';

import 'package:meta/meta.dart';

//TODO: MAKE THIS CLASS (CHAPTER 6)
class Script {
  Script({
    @required List<Uint8List> cmds,
  }) : cmds = cmds ?? [Uint8List.fromList([])];

  final List<Uint8List> cmds;
}
