import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:window_have_a_meal/features/navigation_screen.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = "signIn";
  static const routeURL = "/";
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _idController =
      TextEditingController(text: "22471026");
  final FocusNode _idFocusNode = FocusNode();
  final TextEditingController _passwordController =
      TextEditingController(text: "Test@1234");
  final FocusNode _pwFocusNode = FocusNode();

  bool _rememberMe = false;
  final bool _simpleLogin = false;
  bool _isSubmitted = true;

  // 학번 정규식
  final RegExp _idRegExp = RegExp(r'^\d{8}$');
  // 비밀번호 정규식
  final RegExp _passwordRegExp =
      RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[\W_])[A-Za-z\d\W_]{8,}$');

  String? _idErrorText; // 아이디 오류 메시지
  String? _passwordErrorText; // 비밀번호 오류 메시지

  void _validateIdStudentNumber(String value) {
    if (value.isEmpty) {
      setState(() {
        _idErrorText = '아이디를 입력하세요.';
      });
    } else if (!_idRegExp.hasMatch(value)) {
      setState(() {
        _idErrorText = '8자리 숫자를 입력하세요.';
      });
    } else {
      setState(() {
        _idErrorText = null; // 오류가 없을 경우 null로 설정
      });
      _checkSubmitted();
    }
  }

  void _validatePassword(String value) {
    if (value.isEmpty) {
      setState(() {
        _passwordErrorText = '비밀번호를 입력하세요.';
      });
    } else if (!_passwordRegExp.hasMatch(value)) {
      setState(() {
        _passwordErrorText = '영문자와 숫자, 특수기호를 포함한 8자 이상 입력하세요.';
      });
    } else {
      setState(() {
        _passwordErrorText = null; // 오류가 없을 경우 null로 설정
      });
      _checkSubmitted();
    }
  }

  void _checkSubmitted() {
    setState(() {
      _isSubmitted =
          (_idController.text.trim().isNotEmpty && _idErrorText == null) &&
              (_passwordController.text.trim().isNotEmpty &&
                  _passwordErrorText == null);
    });
  }

  void _handleLogin() async {
    if (_idController.text.trim() == "22471026" &&
        _passwordController.text.trim() == "Test@1234") {
      context.replaceNamed(NavigationScreen.routeName);
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    _idFocusNode.dispose();
    _pwFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Gap(80),
            const Center(
              child: Text(
                "Have-A-Meal",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Gap(40),
            Container(
              width: 400,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 60,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _idController,
                    focusNode: _idFocusNode,
                    autofocus: false,
                    keyboardType: TextInputType.number,
                    maxLength: 8,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: Colors.grey.shade600,
                      ),
                      labelText: '관리자 번호',
                      counterText: '', // 글자수 제한 표시 없애기
                      errorText: _idErrorText, // 아이디 오류 메시지 표시
                      labelStyle: TextStyle(
                        color: _idErrorText == null ? Colors.black : Colors.red,
                      ),
                    ),
                    onChanged: _validateIdStudentNumber, // 입력 값이 변경될 때마다 검증
                  ),
                  const Gap(10),
                  TextFormField(
                    controller: _passwordController,
                    focusNode: _pwFocusNode,
                    obscureText: true,
                    autofocus: false,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Colors.grey.shade600,
                      ),
                      labelText: '비밀번호',
                      errorText: _passwordErrorText, // 비밀번호 오류 메시지 표시
                      labelStyle: TextStyle(
                        color: _passwordErrorText == null
                            ? Colors.black
                            : Colors.red,
                      ),
                    ),
                    onChanged: _validatePassword, // 입력 값이 변경될 때마다 검증
                  ),
                  const Gap(10),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox.adaptive(
                              value: _rememberMe,
                              activeColor: Colors.blue,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value!;
                                });
                              },
                            ),
                            GestureDetector(
                              onTap: () {
                                if (_rememberMe) {
                                  _rememberMe = false;
                                } else {
                                  _rememberMe = true;
                                }
                                setState(() {});
                              },
                              child: const Text('로그인 정보 저장'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(10),
                  ElevatedButton(
                    style: const ButtonStyle(),
                    onPressed: _isSubmitted ? () => _handleLogin() : null,
                    child: const Text('로그인'),
                  ),
                ],
              ),
            ),
            const Gap(80),
          ],
        ),
      ),
    );
  }
}
