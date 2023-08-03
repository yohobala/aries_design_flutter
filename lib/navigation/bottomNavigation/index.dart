import 'package:aries_design_flutter/router/index.dart';
import 'package:flutter/material.dart';

typedef ItemChangeCallback = void Function(int index, String route);

/// 底部导航栏
class AriNavigationBar extends StatefulWidget {
  const AriNavigationBar(
      {Key? key, this.itemChangeCallback, required this.navigationItems})
      : super(key: key);

  /// 底部导航栏切换回调
  final ItemChangeCallback? itemChangeCallback;

  /// 导航栏项
  final List<AriRouteItem> navigationItems;

  @override
  State<AriNavigationBar> createState() => _AriNavigationBarState();
}

class _AriNavigationBarState extends State<AriNavigationBar> {
  int _selectedIndex = 0;

  /// 底部导航栏的配置
  late List<AriRouteItem> itemRoutes;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (widget.itemChangeCallback != null && itemRoutes.length > index) {
        final route = itemRoutes[index].route;
        widget.itemChangeCallback!(index, route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    /*
     * 首先读取route中的底部导航栏配置
     * 然后转化为List<BottomNavigationBarItem>
     */
    itemRoutes = widget.navigationItems;
    final items = itemRoutes
        .map((e) => NavigationDestination(icon: e.icon!, label: e.label))
        .toList();

    return NavigationBar(
      destinations: items,
      selectedIndex: _selectedIndex,
      onDestinationSelected: _onItemTapped,
      // shadowColor: const Color.fromARGB(255, 4, 4, 4),
      elevation: 20.0,
    );
  }
}
