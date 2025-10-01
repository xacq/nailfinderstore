import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/presentation/main_page.dart';
import 'features/auth/presentation/login_page.dart';
import 'features/auth/presentation/register_page.dart';
import 'features/auth/presentation/new_password_page.dart';
import 'features/auth/presentation/verification_page.dart';
import 'features/auth/presentation/success_page.dart';
import 'features/dashboard/presentation/dashboard_page.dart';
import 'features/dashboard/presentation/model_preview_page.dart';
import 'features/dashboard/presentation/courses_page.dart';
import 'features/dashboard/presentation/sales_page.dart';
import 'features/dashboard/presentation/stores_page.dart';
import 'features/profile/presentation/profile_page.dart';


final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(path: '/', builder: (_, __) => const DashboardPage()),
      GoRoute(path: '/model-preview', builder: (_, __) => const ModelPreviewPage()),
      GoRoute(path: '/courses', builder: (_, __) => const CoursesPage()),
      GoRoute(path: '/sales', builder: (_, __) => const SalesPage()),
      GoRoute(path: '/stores', builder: (_, __) => const StoresPage()),
      GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),
      GoRoute(path: '/welcome', builder: (_, __) => const MainPage()),
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterPage()),
      GoRoute(path: '/new-password', builder: (_, __) => const NewPasswordPage()),
      GoRoute(path: '/verification', builder: (_, __) => const VerificationPage()),
      GoRoute(path: '/success', builder: (_, __) => const SuccessPage()),
    ],
    errorBuilder: (_, state) => Scaffold(
      body: Center(child: Text('Ruta no encontrada: ${state.uri}')),
    ),
  );
});