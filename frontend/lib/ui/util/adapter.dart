import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'rv.dart';
import 'styles.dart';

class DividerItem extends Item {
  const DividerItem() : super("");

  @override
  Widget create(BuildContext context, int position, int adapterPosition,
      [Animation<double> animation]) {
    return Divider(
      indent: Dimens.spacingStandard,
    );
  }
}

class SpaceItem extends Item {
  final double height;
  final double width;

  SpaceItem({
    this.height: Dimens.spacingStandard,
    this.width: Dimens.spacingStandard,
  })  : assert(height >= 0.0),
        assert(width >= 0.0),
        super("");

  @override
  Widget create(BuildContext context, int position, int adapterPosition,
      [Animation<double> animation]) {
    return SizedBox(height: height, width: width);
  }
}
