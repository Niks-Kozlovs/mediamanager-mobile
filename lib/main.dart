import 'dart:io';

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
import 'package:mediamanager_flutter/pages/MovieDetailsPage/movie_details_page.dart';
import 'package:mediamanager_flutter/pages/RegisterPage/register_page.dart';
import 'package:mediamanager_flutter/pages/TVShowDetailsPage/tv_show_details_page.dart';
import 'package:provider/provider.dart';

void main() async {
  await initHiveForFlutter();
  runApp(ChangeNotifierProvider(
    create: (context) => CookiesProvider(),
    child: const MyApp(),
  ));
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
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
    GoRoute(
      path: '/404',
      builder: (context, state) => const Text('404'),
    ),
    GoRoute(
      name: '/movieDetails',
      path: '/movieDetails/:id',
      redirect: (context, state) {
        final movieId = state.params['id'];
        if (movieId == null || movieId.isEmpty) {
          return '/404';
        }
        return '/movieDetails/$movieId';
      },
      builder: (context, state) {
        return MovieDetailsPage(movieId: state.params['id']!);
      },
    ),
    GoRoute(
      name: '/tvShowDetails',
      path: '/tvShowDetails/:id',
      redirect: (context, state) {
        final tvShowId = state.params['id'];
        if (tvShowId == null || tvShowId.isEmpty) {
          return '/404';
        }
        return '/tvShowDetails/$tvShowId';
      },
      builder: (context, state) {
        return TVShowDetailsPage(tvShowId: state.params['id']!);
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
    final cookieJar = context.read<CookiesProvider>().cookieJar;
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

class CookiesProvider extends ChangeNotifier {
  final _cookieJar = CookieJar();
  bool _isLoggedin = false;

  CookieJar get cookieJar => _cookieJar;

  bool get isLoggedin => _isLoggedin;

  set isLoggedIn(bool value) {
    _isLoggedin = value;
    notifyListeners();
  }

  void clearCookies() {
    _cookieJar.deleteAll();
    _isLoggedin = false;
    notifyListeners();
  }

  Future<List<Cookie>> getCookies() async {
    return _cookieJar.loadForRequest(Uri.parse(API_URL));
  }
}
