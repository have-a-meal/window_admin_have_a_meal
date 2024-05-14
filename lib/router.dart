import 'package:go_router/go_router.dart';
import 'package:window_have_a_meal/features/account/sign_in_screen.dart';
import 'package:window_have_a_meal/features/navigation_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: SignInScreen.routeURL,
      name: SignInScreen.routeName,
      builder: (context, state) {
        return const SignInScreen();
      },
    ),
    GoRoute(
      path: NavigationScreen.routeURL,
      name: NavigationScreen.routeName,
      builder: (context, state) {
        return const NavigationScreen();
      },
    ),
  ],
);
