import 'package:auto_route/auto_route.dart';
import 'package:curve/home/home_screen_page.dart';
import 'package:curve/splashscreen/splash_screen.dart';

@MaterialAutoRouter(
    replaceInRouteName: 'Page,Route',
    routes:<AutoRoute>[
      AutoRoute(
        path: "/splash",
        initial: true,
        page: SplashScreenPage,
        children: [
          RedirectRoute(path: '*', redirectTo: ''),
        ],
      ),
      AutoRoute(
        path: "/home",
        page: HomeScreenPage,
        children: [
          RedirectRoute(path: '*', redirectTo: ''),
        ],
      ),
    ]
)

class $AppRouter{

}