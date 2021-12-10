import 'package:auto_route/auto_route.dart';
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
    ]
)

class $AppRouter{

}