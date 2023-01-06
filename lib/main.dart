import 'package:carousel_slider/carousel_slider.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gql_dio_link/gql_dio_link.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mediamanager_flutter/constants.dart';
import 'package:mediamanager_flutter/pages/HomePage/home_page.dart';
import 'package:mediamanager_flutter/pages/LoginPage/login_page.dart';
import 'package:mediamanager_flutter/pages/RegisterPage/register_page.dart';
import 'package:mediamanager_flutter/queries/queries.dart';

void main() async {
  await initHiveForFlutter();
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  initialLocation: '/login',
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      path: '/register',
      builder: (BuildContext context, GoRouterState state) {
        return const RegisterPage();
      },
    ),
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const HomePage();
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dio = Dio();
    final cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));

    final Link link = DioLink(
      API_URL,
      client: dio,
    );

    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        cache: GraphQLCache(store: HiveStore()),
        link: link,
      ),
    );
    return GraphQLProvider(
      client: client,
      child: MaterialApp.router(
        routerConfig: _router,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}
