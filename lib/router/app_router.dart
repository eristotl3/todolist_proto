import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../features/auth/domain/user_profile.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/role_selection_screen.dart';
import '../features/teacher/presentation/screens/teacher_home_screen.dart';
import '../features/teacher/presentation/screens/class_detail_screen.dart';
import '../features/teacher/domain/class_model.dart';
import '../features/student/presentation/screens/student_home_screen.dart';
import '../features/student/presentation/screens/join_class_screen.dart';
import 'route_names.dart';

part 'app_router.g.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}

@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: RouteNames.splash,
    refreshListenable: _AuthStateListenable(ref),
    redirect: (context, state) {
      // Still loading — show splash
      if (authState is AsyncLoading) {
        return state.fullPath == RouteNames.splash ? null : RouteNames.splash;
      }

      final profile = authState.valueOrNull;
      final isAuthenticated = profile != null;
      final isOnAuthRoute = state.fullPath == RouteNames.login ||
          state.fullPath == RouteNames.register ||
          state.fullPath == RouteNames.roleSelection;

      // Not logged in → send to role selection
      if (!isAuthenticated) {
        return isOnAuthRoute ? null : RouteNames.roleSelection;
      }

      // Logged in but on auth route or splash → send to home
      if (isOnAuthRoute || state.fullPath == RouteNames.splash) {
        return profile.role == UserRole.teacher
            ? RouteNames.teacherHome
            : RouteNames.studentHome;
      }

      // Block students from teacher routes and vice versa
      if (profile.role == UserRole.student &&
          (state.fullPath?.startsWith('/teacher') ?? false)) {
        return RouteNames.studentHome;
      }
      if (profile.role == UserRole.teacher &&
          (state.fullPath?.startsWith('/student') ?? false)) {
        return RouteNames.teacherHome;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.roleSelection,
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.register,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final role = extra?['role'] as String? ?? 'student';
          return RegisterScreen(role: role);
        },
      ),
      GoRoute(
        path: RouteNames.teacherHome,
        builder: (context, state) => const TeacherHomeScreen(),
        routes: [
          GoRoute(
            path: 'class/:classId',
            builder: (context, state) {
              final classModel = state.extra as ClassModel;
              return ClassDetailScreen(classModel: classModel);
            },
          ),
        ],
        // Desktop shell handles navigation internally; no sub-routes needed
      ),
      GoRoute(
        path: RouteNames.studentHome,
        builder: (context, state) => const StudentHomeScreen(),
        routes: [
          GoRoute(
            path: 'join-class',
            builder: (context, state) => const JoinClassScreen(),
          ),
        ],
      ),
    ],
  );
}

// Notifies GoRouter to re-evaluate redirects when auth state changes
class _AuthStateListenable extends ChangeNotifier {
  _AuthStateListenable(Ref ref) {
    ref.listen(authNotifierProvider, (prev, next) => notifyListeners());
  }
}
