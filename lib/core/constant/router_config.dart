import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../screen/landing_screen/landing_screen.dart';
import '../../widget/base/loading.dart';

const rootKey = GlobalObjectKey<NavigatorState>('root');
const _mainShellKey = GlobalObjectKey<NavigatorState>('shell');

class AppRouterConfig {
  static final analytics = FirebaseAnalytics.instance;
  static final firebaseObserver = FirebaseAnalyticsObserver(analytics: analytics);

  static GoRouter router = GoRouter(
    navigatorKey: rootKey,
    initialLocation: '/landing_screen',
    redirect: (context, state) {
      if(state.error != null) {
        return '/';
      }
      else {
        return null;
      }
    },
    errorPageBuilder: (context, state) => NoTransitionPage(
        child: Scaffold(
          appBar: AppBar(),
          body: const SafeArea(
            child: PageError(),
          ),
        )
    ),
    observers: [firebaseObserver],
    routes: [
      GoRoute(
          path: '/landing_screen',
        parentNavigatorKey: rootKey,
        name: 'Karşılama Sayfası',
        builder: (context, state) => const LandingScreen()
      )
    ]
  );
}