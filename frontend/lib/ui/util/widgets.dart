import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/animation/animation.dart';
import 'package:politic/ui/util/lib.dart';

import 'rv.dart';

class TextItem extends Item {
  String text;
  TextItem(this.text) : super(text);

  @override
  Widget create(BuildContext context, int position, int adapterPosition,
      [Animation<double> animation]) {
    return Row(children: <Widget>[Flexible(child: Text(text))]);
  }
}
