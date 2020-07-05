import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class GroupItem extends Item with ListMixin<Item> {
  Item header;

  List<Item> _items = new List();

  GlobalKey<AnimatedListState> _listKey;

  GlobalKey<AnimatedListState> get listKey => _listKey;

  set listKey(GlobalKey<AnimatedListState> listKey) => _listKey = listKey;

  GroupItem(String id) : super(id);

  int getItemCount() => _items.length + getHeaderCount();

  List<Item> getItems() => _items.toList();

  bool update(Item item) => Utils.replace(_items, item).item1;

  bool updateAll(GroupItem item) =>
      Utils.replaceAll(_items, item.getItems()).item1;

  void addItems(List<Item> items) => _items.addAll(items);

  void addItem(Item item) => _items.add(item);

  @override
  Widget create(BuildContext context, int position, int adapterPosition,
      [Animation<double> animation]) {}

  Item getItem(int index) => index == 0 ? header : _items[index - 1];

  int getItemPositionInGroup(Item item) {
    var index = _items.indexOf(item);
    if (index == -1) {
      return null;
    }
    return index;
  }

  int getItemPositionInAdapter(Item item) {
    var index = getItemPositionInGroup(item);

    if (index == null) {
      return null;
    }

    return index + getHeaderCount();
  }

  void addHeader(Item item) {
    this.header = item;
  }

  void updateHeader(Item item) {
    this.header = item;
  }

  int getHeaderCount() {
    if (_hasHeader()) {
      return 1;
    }

    return 0;
  }

  bool _hasHeader() {
    return length != 0 && header != null;
  }

  Tuple2<int, Item> removeItem(Item item, int adapterPosition) {
    var index = _items.indexOf(item);
    if (index == -1) {
      return null;
    }

    if (index == 0 && length == 1 && removeHeaderOnEmpty()) {
      _updateHeaderItem(adapterPosition - index - getHeaderCount());
    }

    var removedItem = _items.removeAt(index);

    return Tuple2(index, removedItem);
  }

  void _updateHeaderItem(int headerPosition) {
    if (header.shouldAnimateRemove()) {
      listKey.currentState.removeItem(headerPosition,
          (BuildContext context, Animation<double> animation) {
        return header.create(context, 0, headerPosition, animation);
      });
    }
  }

  bool removeHeaderOnEmpty() => true;

  @override
  int get length => _items.length;

  @override
  set length(int newLength) => _items.length = newLength;

  @override
  Item operator [](int index) => _items[index];

  @override
  void operator []=(int index, Item value) => _items[index] = value;
}

abstract class Item {
  final String _id;

  const Item(this._id);

  String getId() => _id;

  Widget create(BuildContext context, int position, int adapterPosition,
      [Animation<double> animation]);

  @override
  bool operator ==(other) =>
      this.runtimeType == other.runtimeType && other._id == _id;

  int get hashCode => _id.hashCode;

  bool shouldAnimateRemove() => false;

  bool shouldAnimateAddition() => false;

  String getFastScrollLabel() {}
}

class Adapter {
  List<Item> _items = new List();

  GlobalKey<AnimatedListState> listKey;

  bool notNull(Object o) => o != null;

  AnimatedListState get _animatedList => listKey.currentState;

  Widget onCreateWidget(BuildContext context, int adapterPosition) {
    return onCreateWidgetWithAnimation(context, adapterPosition, null);
  }

  Tuple2<Item, int> getItemAtPosition(int adapterPosition) {
    int count = 0;
    for (var index = 0; index < _items.length; index++) {
      var item = _items[index];

      if (item is GroupItem) {
        // Pass the animated list key so that the group an animate itself.
        item.listKey = listKey;

        var groupCount = item.getItemCount();
        if (adapterPosition < count + groupCount) {
          var groupItem = item.getItem(adapterPosition - count);
          var idx = item.getItemPositionInGroup(groupItem);
          return Tuple2(groupItem, idx);
        } else {
          count += groupCount;
        }
      } else {
        if (count == adapterPosition) {
          Item ungroupedItem = _items[index];
          return Tuple2(ungroupedItem, index);
        } else {
          count += 1;
        }
      }
    }
    return null;
  }

  int getItemPositionInAdapter(Item itemToFind) {
    int count = 0;
    for (var index = 0; index < _items.length; index++) {
      var item = _items[index];

      if (item is GroupItem) {
        var groupCount = item.getItemCount();
        var indexInGroup = item.getItemPositionInAdapter(itemToFind);

        if (indexInGroup != null) {
          return count + indexInGroup;
        } else {
          count += groupCount;
        }
      } else {
        if (itemToFind == item) {
          return count;
        } else {
          count += 1;
        }
      }
    }

    return null;
  }

  Widget onCreateWidgetWithAnimation(
      BuildContext context, int adapterPosition, Animation<double> animation) {
    Tuple2<Item, int> itemIndexTuple = getItemAtPosition(adapterPosition);

    var count = getItemCount();

    if (itemIndexTuple != null) {
      var item = itemIndexTuple.item1;
      var index = itemIndexTuple.item2;
      if (item != null) {
        return item.create(context, index, adapterPosition, animation);
      }
    }

    return null;
  }

  int getItemCount() => countItems(_items);

  static int countItems(List<Item> items) {
    var count = 0;

    for (Item i in items) {
      if (i is GroupItem) {
        count += i.getItemCount();
      } else {
        count += 1;
      }
    }

    return count;
  }

  bool updateItem(Item item) {
    bool updated = false;

    for (var index = 0; index < _items.length; index++) {
      var i = _items[index];
      if (!updated) {
        if (i == item && i is GroupItem) {
          _items[index] = item;
          return true;
        } else if (i is GroupItem) {
          updated = i.updateAll(item);
        } else {
          return Utils.replace(_items, item).item1;
        }
      }

      if (updated) {
        return updated;
      }
    }

    return updated;
  }

  Item removeItem(Item item) {
    Item removed;

    for (var index = 0; index < _items.length; ++index) {
      var i = _items[index];

      var adapterPosition = getItemPositionInAdapter(item);

      // Could not find item
      if (adapterPosition == null) {
        return null;
      }

      var position = index;

      if (i is GroupItem) {
        var indexItem = i.removeItem(item, adapterPosition);
        if (indexItem != null) {
          position = indexItem.item1;
          removed = indexItem.item2;
        }
      } else {
        position = adapterPosition;
        var index = _items.indexOf(item);
        if (index != -1) {
          removed = _items.removeAt(index);
        }
      }

      if (removed != null) {
        if (removed.shouldAnimateRemove()) {
          _animatedList.removeItem(adapterPosition,
              (BuildContext context, Animation<double> animation) {
            return item.create(context, position, adapterPosition, animation);
          });
        }
        return removed;
      }
    }

    return removed;
  }

  String _getFastScrollLabel(int position) {
    Tuple2<Item, int> itemIndexTuple = getItemAtPosition(position);

    if (itemIndexTuple != null) {
      var item = itemIndexTuple.item1;
      if (item != null) {
        return item.getFastScrollLabel();
      }
    }

    return null;
  }

  String getFastScrollLabel(int position, {int radius = 6}) {
    var label = _getFastScrollLabel(position);

    if (label == null) {
      for (int i = 0; i < radius / 2; i++) {
        label = _getFastScrollLabel(position - i);
        if (label != null) {
          return label;
        }

        label = _getFastScrollLabel(position + i);
        if (label != null) {
          return label;
        }
      }

      if (label == null) {
        label = "NONE";
      }
    }

    return label;
  }

  Item getItemAt(int position) => _items[position];

  void swapData(List<Item> items) {
    if (items != null) {
      this._items = items.where(notNull).toList();
    }
  }

  void setListKey(GlobalKey<AnimatedListState> listKey) {
    this.listKey = listKey;
  }
}

class Utils {
  static Tuple2<bool, int> replace(List<Item> items, Item item) {
    var index = items.indexOf(item);

    if (index == -1) {
      return Tuple2(false, index);
    }

    items.replaceRange(index, index + 1, [item]);

    return Tuple2(true, index);
  }

  static Tuple2<bool, int> replaceAll(
      List<Item> items, List<Item> itemsToReplace) {
    var replacedItem = false;
    for (var i in itemsToReplace) {
      var tupe = replace(items, i);
      if (tupe.item1) {
        replacedItem = true;
      }
    }
    return Tuple2(replacedItem, -1);
  }
}
