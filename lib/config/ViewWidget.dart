import 'package:base/config/ViewActions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class ViewWidget<V extends StatefulWidget, M extends ViewActions>
    extends State<V> {
  late M _viewActions;

  M get viewActions => _viewActions;
  @protected
  void loadArguments() {}

  @protected
  M createViewActions();

  @protected
  Widget render(BuildContext context);

  @override
  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    _viewActions = createViewActions();
    _viewActions.initState();
  }

  @override
  void didUpdateWidget(covariant V oldWidget) {
    super.didUpdateWidget(oldWidget);
    loadArguments();
  }

  @override
  @protected
  @mustCallSuper
  void dispose() {
    super.dispose();
    _viewActions.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => render(context.obs.value));
  }

  AppBar header({required String title, List<Widget>? iconRight}) {
    return AppBar(
      shadowColor: Colors.white,
      title: Text(title),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: iconRight,
      centerTitle: true,
    );
  }
}
