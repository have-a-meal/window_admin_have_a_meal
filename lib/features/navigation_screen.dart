import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:window_have_a_meal/features/account/sign_in_screen.dart';
import 'package:window_have_a_meal/features/menu_insert/menu_insert_screen_test.dart';
import 'package:window_have_a_meal/features/qr_python/qr_python_screen.dart';

class NavigationScreen extends StatefulWidget {
  static const routeName = "navigation";
  static const routeURL = "/navigation";
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  bool isExpanded = true;
  int _selectedIndex = 0;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Have a Meal"),
        actions: [
          TextButton.icon(
            onPressed: () {
              context.goNamed(SignInScreen.routeName);
            },
            icon: const Icon(Icons.logout),
            label: const Text("로그아웃"),
          )
        ],
      ),
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            groupAlignment: -1.0,
            onDestinationSelected: (int index) {
              if (_selectedIndex == index) return;
              setState(() {
                _selectedIndex = index;
              });
            },
            extended: _isExpanded,
            indicatorShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            minExtendedWidth: 150,
            leading: IconButton(
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              icon: Icon(
                _isExpanded
                    ? Icons.keyboard_double_arrow_left
                    : Icons.keyboard_double_arrow_right,
              ),
            ),
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.playlist_add_rounded),
                label: Text('메뉴 등록'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.qr_code_2),
                label: Text('식권 인증'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // Expanded(
          //   child: IndexedStack(
          //     index: _selectedIndex,
          //     children: const [
          //       MenuInsertScreen(),
          //       QrPythonScreen(),
          //     ],
          //   ),
          // ),
          Expanded(
            child: Stack(
              children: [
                Offstage(
                  offstage: _selectedIndex != 0,
                  child: const MenuInsertScreen(),
                ),
                Offstage(
                  offstage: _selectedIndex != 1,
                  child: const QrPythonScreen(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
