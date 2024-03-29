import 'package:chat_app/core/enums/enums.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseView<T extends ChangeNotifier> extends StatefulWidget {
  final Widget staticChild;
  final Function(T) onModelReady;
  final Widget Function(BuildContext, T, Widget) builder;
  final T viewModel;
  final BaseViewType baseViewType;

  BaseView.withoutConsumer({
    @required this.builder,
    @required this.viewModel,
    this.onModelReady,
  })  : baseViewType = BaseViewType.WithoutConsumer,
        staticChild = null;

  BaseView.withConsumer({
    @required this.viewModel,
    @required this.builder,
    this.staticChild,
    this.onModelReady,
  }) : baseViewType = BaseViewType.WithConsumer;

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends ChangeNotifier> extends State<BaseView<T>> {
  T _model;

  @override
  void initState() {
    super.initState();
    _model = widget.viewModel;

    if (widget.onModelReady != null) {
      widget.onModelReady(_model);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.baseViewType == BaseViewType.WithoutConsumer) {
      return ChangeNotifierProvider(
        create: (context) => _model,
        child: widget.builder(context, _model, null),
      );
    }

    return ChangeNotifierProvider(
      create: (context) => _model,
      child: Consumer(
        builder: widget.builder,
        child: widget.staticChild,
      ),
    );
  }
}
