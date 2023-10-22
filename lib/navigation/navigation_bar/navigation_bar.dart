import 'package:aries_design_flutter/router/index.dart';
import 'package:flutter/material.dart';

typedef PageChangeCallback = void Function(int index);

/// 导航栏
class AriNavigationBar extends StatefulWidget {
  AriNavigationBar(
      {Key? key,
      this.pageChangeCallback,
      required this.navigationItems,
      this.initSelectedIndex = 0})
      : super(key: key);

  /// 底部导航栏切换回调
  final PageChangeCallback? pageChangeCallback;

  /// 导航栏项
  final List<AriRouteItem> navigationItems;

  final int initSelectedIndex;

  @override
  State<AriNavigationBar> createState() => _AriNavigationBarState();
}

class _AriNavigationBarState extends State<AriNavigationBar> {
  int _selectedIndex = 0;

  /// 底部导航栏的配置
  late List<AriRouteItem> itemRoutes;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initSelectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    /*
     * 首先读取route中的底部导航栏配置
     * 然后转化为List<BottomNavigationBarItem>
     */
    itemRoutes = widget.navigationItems;
    final items = itemRoutes.asMap().entries.map((e) {
      Widget iconElement;
      AriRouteItem item = e.value;
      if (e.key == _selectedIndex) {
        if (item.activeIcon != null) {
          iconElement = Icon(item.activeIcon!);
        } else {
          iconElement = Icon(item.icon!);
        }
      } else {
        iconElement = Icon(item.icon!);
      }

      return NavigationDestination(
          icon: iconElement,
          label: item.label != null ? item.label!(context) : item.name);
    }).toList();

    return NavigationBar(
      destinations: items,
      selectedIndex: _selectedIndex,
      onDestinationSelected: _onItemTapped,
      elevation: 5.0,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (widget.pageChangeCallback != null && itemRoutes.length > index) {
        widget.pageChangeCallback!(index);
      }
    });
  }
}
