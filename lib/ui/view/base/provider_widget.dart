import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class ProviderWidget<T> extends Widget {
  @protected
  Widget build(BuildContext context, T model);

  @override
  _DataProviderElement<T> createElement() => _DataProviderElement<T>(this);
}

class _DataProviderElement<T> extends ComponentElement {
  _DataProviderElement(ProviderWidget widget) : super(widget);

  @override
  ProviderWidget get widget => super.widget;

  @override
  Widget build() => widget.build(this, Provider.of<T>(this));

  @override
  void update(ProviderWidget newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    rebuild();
  }
}
