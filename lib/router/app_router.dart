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
import '../features/teacher/presentation/screens/todo_list_screen.dart';
import '../features/teacher/domain/class_model.dart';
import '../features/teacher/domain/todo_list_model.dart';
import '../features/student/presentation/screens/student_home_screen.dart';
import '../features/student/presentation/screens/join_class_screen.dart';
import '../features/student/presentation/screens/student_class_detail_screen.dart';
import '../features/student/presentation/screens/student_todo_screen.dart';
import '../features/student/domain/enrolled_class_model.dart';
import '../features/student/domain/student_todo_list_model.dart';
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
  // Do NOT watch authNotifierProvider here — that would recreate the entire
  // GoRouter (and reset navigation to initialLocation) on every auth state
  // change. Instead, read auth state inside the redirect callback and let
  // _AuthStateListenable tell the existing router to re-evaluate redirects.
  return GoRouter(
    initialLocation: RouteNames.splash,
    refreshListenable: _AuthStateListenable(ref),
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);

      // Still loading — show splash only on cold start; if the user is already
      // on an auth screen (e.g., tapped Sign In), keep them there so the login
      // screen can show the loading indicator and any error snackbars.
      if (authState is AsyncLoading) {
        final onAuthOrSplash = state.fullPath == RouteNames.splash ||
            state.fullPath == RouteNames.login ||
            state.fullPath == RouteNames.register ||
            state.fullPath == RouteNames.roleSelection;
        return onAuthOrSplash ? null : RouteNames.splash;
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
            routes: [
              GoRoute(
                path: 'list/:listId',
                builder: (context, state) {
                  final todoList = state.extra as TodoListModel;
                  return TodoListScreen(
                    todoList: todoList,
                    classId: state.pathParameters['classId']!,
                  );
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.studentHome,
        builder: (context, state) => const StudentHomeScreen(),
        routes: [
          GoRoute(
            path: 'join-class',
            builder: (context, state) => const JoinClassScreen(),
          ),
          GoRoute(
            path: 'class/:classId',
            builder: (context, state) {
              final classModel = state.extra as EnrolledClassModel;
              return StudentClassDetailScreen(classModel: classModel);
            },
            routes: [
              GoRoute(
                path: 'todo/:listId',
                builder: (context, state) {
                  final todoList = state.extra as StudentTodoListModel;
                  return StudentTodoScreen(todoList: todoList);
                },
              ),
            ],
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
