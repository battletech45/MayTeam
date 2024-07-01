import 'package:MayTeam/screen/auth_screen/email_verification_screen.dart';
import 'package:MayTeam/screen/auth_screen/login_screen.dart';
import 'package:MayTeam/screen/auth_screen/register_screen.dart';
import 'package:MayTeam/screen/main_screen/main_screen.dart';
import 'package:MayTeam/screen/profile_screen/profile_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../screen/chat_screen/chat_screen.dart';
import '../../screen/landing_screen/landing_screen.dart';
import '../../screen/search_screen/search_screen.dart';
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
      ),
      GoRoute(
        path: '/',
        parentNavigatorKey: rootKey,
        name: 'Ana Sayfa',
        builder: (context, state) => const MainScreen()
      ),
      GoRoute(
        path: '/chat/:id',
        parentNavigatorKey: rootKey,
        name: 'Chat Sayfası',
        builder: (context, state) => ChatScreen(groupID: state.pathParameters['id'] as String, groupName: state.extra as String)
      ),
      GoRoute(
        path: '/search',
        parentNavigatorKey: rootKey,
        name: 'Arama Sayfası',
        builder: (context, state) => const SearchScreen()
      ),
      GoRoute(
        path: '/verification',
        parentNavigatorKey: rootKey,
        name: 'Mail Onaylama Sayfası',
        builder: (context, state) => const EmailVerificationScreen()
      ),
      GoRoute(
        path: '/login',
        parentNavigatorKey: rootKey,
        name: 'Giriş Sayfası',
        builder: (context, state) => const LoginScreen()
      ),
      GoRoute(
        path: '/register',
        parentNavigatorKey: rootKey,
        name: 'Kayıt Sayfası',
        builder: (context, state) => const RegisterScreen()
      ),
      GoRoute(
        path: '/profile',
        parentNavigatorKey: rootKey,
        name: 'Profil Sayfası',
        builder: (context, state) => const ProfileScreen()
      )
    ]
  );
}