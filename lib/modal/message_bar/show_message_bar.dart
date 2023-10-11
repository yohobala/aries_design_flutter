import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:flutter/material.dart';

import 'message_bar.dart';

class _OverlayInfo {
  _OverlayInfo({
    required this.overlayEntry,
    required this.key,
  });

  final OverlayEntry overlayEntry;
  final GlobalKey<_AnimatedOverlayState> key;
}

List<_OverlayInfo> _overlayEntryList = []; // 假设你有这个全局或状态变量来存储所有OverlayEntry

void showAriMessageBar(
  BuildContext context, {
  Widget? title,
  Widget? content,
  List<Widget> Function(BuildContext)? buttonBuilder,
  bool barrierDismissible = true,
  bool isOnly = true,
  bool autoClose = false,
}) {
  if (isOnly) {
    for (var entry in _overlayEntryList) {
      _closeOverlay(entry);
    }
  }

  // 创建一个 GlobalKey，这样我们就能访问动画状态。
  final GlobalKey<_AnimatedOverlayState> key = GlobalKey();

  OverlayEntry overlayEntry = OverlayEntry(
    builder: (BuildContext context) {
      return _AnimatedOverlay(key: key);
    },
  );

  Overlay.of(context).insert(overlayEntry);
  _OverlayInfo overlayInfo = _OverlayInfo(
    overlayEntry: overlayEntry,
    key: key,
  );
  _overlayEntryList.add(overlayInfo);

  if (autoClose) {
    // 使用延时来启动动画并在结束后移除 OverlayEntry。
    Future.delayed(Duration(seconds: 2), () {
      _closeOverlay(overlayInfo);
    });
  }
}

void _closeOverlay(_OverlayInfo info) {
  final GlobalKey<_AnimatedOverlayState> key = info.key;
  final OverlayEntry overlayEntry = info.overlayEntry;
  key.currentState?.reverseAnimation().then((_) {
    overlayEntry.remove();
    _overlayEntryList.remove(info);
  });
}

class _AnimatedOverlay extends StatefulWidget {
  const _AnimatedOverlay({Key? key}) : super(key: key);

  @override
  _AnimatedOverlayState createState() => _AnimatedOverlayState();
}

class _AnimatedOverlayState extends State<_AnimatedOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _positionAnimation;

  bool _isAnimationInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // 不透明度动画，从 0 (完全透明) 到 1 (完全不透明)
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    // 自动开始动画
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  Future<void> startAnimation() async {
    await _controller.forward();
  }

  Future<void> reverseAnimation() async {
    await _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    double safeTop = MediaQuery.of(context).padding.top;

    if (!_isAnimationInitialized) {
      _isAnimationInitialized = true;
      // 位置动画，从 -100 (完全不可见) 到 safeTop (完全可见)
      _positionAnimation = Tween<double>(begin: -100, end: safeTop).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOut,
        ),
      );
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          top: _positionAnimation.value,
          left: 0,
          right: 0,
          child: AriMessageBar("12321"),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
