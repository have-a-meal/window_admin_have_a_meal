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
  // 사이드바의 상태를 관리하는 변수
  bool isExpanded = true;
  // 현재 선택된 인덱스를 저장하는 변수
  int selectedIndex = 0;

  ButtonStyle _sideButtonStyle(int index) {
    return ButtonStyle(
      alignment: Alignment.centerLeft,
      backgroundColor: MaterialStatePropertyAll(
        selectedIndex == index ? Colors.blue : Colors.blue.shade300,
      ),
      shape: const MaterialStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              6,
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(int index) {
    if (selectedIndex == index) return;
    setState(() {
      selectedIndex = index;
    });
  }

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
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: isExpanded ? 130 : 50, // 늘어난 상태면 150, 아니면 50
            height: MediaQuery.of(context).size.height,
            color: Colors.blue.shade300,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 4, right: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(
                        isExpanded ? Icons.chevron_left : Icons.chevron_right,
                        color: Colors.grey.shade800,
                      ),
                      onPressed: () {
                        setState(() {
                          isExpanded = !isExpanded; // 상태 토글
                        });
                      },
                    ),
                    if (isExpanded) ...[
                      // 메뉴 등록 버튼과 식권 인증 버튼을 표시
                      TextButton.icon(
                        onPressed: () => _onTap(0),
                        icon: Icon(Icons.playlist_add_rounded,
                            color: Colors.grey.shade800),
                        label: Text('메뉴 등록',
                            style: TextStyle(color: Colors.grey.shade800)),
                      ),
                      TextButton.icon(
                        onPressed: () => _onTap(1),
                        icon:
                            Icon(Icons.qr_code_2, color: Colors.grey.shade800),
                        label: Text('식권 인증',
                            style: TextStyle(color: Colors.grey.shade800)),
                      ),
                    ] else ...[
                      IconButton(
                        icon: Icon(
                          Icons.playlist_add_rounded,
                          color: Colors.grey.shade800,
                        ),
                        onPressed: () => _onTap(0),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.qr_code_2,
                          color: Colors.grey.shade800,
                        ),
                        onPressed: () => _onTap(1),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: selectedIndex,
              children: const [
                MenuInsertScreen(),
                QrPythonScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
