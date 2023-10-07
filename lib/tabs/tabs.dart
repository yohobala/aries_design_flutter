import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:flutter/material.dart';

class AriTabBar extends StatefulWidget {
  const AriTabBar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
    required this.tabs,
    this.width = 80,
    this.height = 40,
    this.duration,
  }) : super(key: key);

  /// 当前选中的标签项的索引
  final int selectedIndex;

  /// 点击标签项的回调
  final SelectIndexCallback? onTap;

  /// 标签项
  final List<String> tabs;

  /// 标签项的宽度
  final double width;

  /// 标签项的高度
  final double height;

  /// 动画时长
  final Duration? duration;
  @override
  State<AriTabBar> createState() => _AriTabsState();
}

class _AriTabsState extends State<AriTabBar>
    with TickerProviderStateMixin<AriTabBar> {
  int selectedIndex = 0;
  double position = 0;

  BorderRadiusGeometry radius =
      BorderRadius.all(AriTheme.borderRadius.standard);

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    position = calculatePosition(selectedIndex);
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: radius,
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            left: position,
            duration: widget.duration ?? AriTheme.duration.medium1,
            child: Container(
              width: widget.width, // 根据需要设置宽度
              height: widget.height,
              decoration: BoxDecoration(
                color: AriThemeColor.of(context).colorScheme.primaryContainer,
                borderRadius: radius,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: widget.tabs
                .map((e) => navItem(e, widget.tabs.indexOf(e)))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget navItem(String text, int index) {
    Color selectedColor =
        AriThemeColor.of(context).colorScheme.onPrimaryContainer;
    Color unSelectedColor = AriThemeColor.of(context).prime.onGrey!;

    return GestureDetector(
      behavior: HitTestBehavior.opaque, // 添加这一行
      onTap: () {
        setState(
          () {
            selectedIndex = index;
            // 手动计算位置
            position = calculatePosition(index);
            widget.onTap?.call(index);
          },
        );
      },
      child: Container(
        width: widget.width, // 根据需要设置宽度
        height: widget.height,
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: selectedIndex == index ? selectedColor : unSelectedColor,
          ),
        ),
      ),
    );
  }

  double calculatePosition(int index) {
    return (MediaQuery.of(context).size.width / 6) * (index * 2 + 1) -
        widget.width / 2;
  }
}
