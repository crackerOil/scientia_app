import 'package:flutter/material.dart';

// this widget serves as a way to pass state information down the widget tree
class InheritedDataWidget extends InheritedWidget {
  final data;

  const InheritedDataWidget({
    Key? key,
    required Widget child,
    this.data
  }) : super(key: key, child: child);

  static InheritedDataWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedDataWidget>();
  }

  @override
  bool updateShouldNotify(InheritedDataWidget oldWidget) => data != oldWidget.data;
}
