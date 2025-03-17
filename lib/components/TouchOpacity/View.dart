import 'package:flutter/material.dart';

class TouchOpacity extends StatefulWidget {
  final Widget child;
  final double activeOpacity;
  final GestureTapCallback? onTap;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCancelCallback? onTapCancel;

  const TouchOpacity({
    super.key,
    required this.child,
    this.activeOpacity = 0.5,
    this.onTapDown,
    this.onTapUp,
    this.onTap,
    this.onTapCancel,
  });

  @override
  State<StatefulWidget> createState() => _TouchOpacityState();
}

class _TouchOpacityState extends State<TouchOpacity>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 100),
        lowerBound: widget.activeOpacity,
        upperBound: 1.0,
        value: 1.0);
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.activeOpacity != 1.0) {
      _controller.reverse();
    }
    if (widget.onTapDown != null) {
      widget.onTapDown!(details);
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.activeOpacity != 1.0) {
      _controller.forward();
    }
    if (widget.onTapUp != null) {
      widget.onTapUp!(details);
    }
  }

  void _onTapCancel() {
    if (widget.activeOpacity != 1.0) {
      _controller.forward();
    }
    if (widget.onTapCancel != null) {
      widget.onTapCancel!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Opacity(
        opacity: _controller.value,
        child: widget.child,
      ),
    );
  }
}
