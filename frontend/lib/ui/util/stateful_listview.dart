import 'package:flutter/material.dart';

class DoubleHolder {
  double value = 0.0;
}

// https://medium.com/@boldijar.paul/flutter-keeping-list-view-index-while-changing-page-view-c260352f35f8
class StatefulListView extends StatefulWidget {
  final DoubleHolder offset = new DoubleHolder();

  StatefulListView(this._itemCount, this._indexedWidgetBuilder, {
    Key key,
    EdgeInsetsGeometry padding})
      : super(key: key) {
    this._padding = padding;
  }

  double getOffsetMethod() {
    return offset.value;
  }

  void setOffsetMethod(double val) {
    offset.value = val;
  }


  /// The amount of space by which to inset the children.
  EdgeInsetsGeometry _padding;

  final int _itemCount;
  final IndexedWidgetBuilder _indexedWidgetBuilder;

  @override
  _StatefulListViewState createState() =>
      new _StatefulListViewState(_itemCount, _padding, _indexedWidgetBuilder);
}

class _StatefulListViewState extends State<StatefulListView>
    with SingleTickerProviderStateMixin {
  ScrollController scrollController;
  final EdgeInsetsGeometry _padding;
  final int _itemCount;
  final IndexedWidgetBuilder _itemBuilder;

  _StatefulListViewState(this._itemCount, this._padding, this._itemBuilder);

  @override
  void initState() {
    super.initState();
    scrollController =
        new ScrollController(initialScrollOffset: widget.getOffsetMethod());
  }

  @override
  Widget build(BuildContext context) {
    return new NotificationListener(
      child: new ListView.builder(
          controller: scrollController,
          padding: _padding,
          itemCount: _itemCount,
          itemBuilder: _itemBuilder),
      onNotification: (notification) {
        if (notification is ScrollNotification) {
          widget.setOffsetMethod(notification.metrics.pixels);
        }
      },
    );
  }
}
