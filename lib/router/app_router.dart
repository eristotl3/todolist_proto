import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../features/auth/domain/user_profile.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/role_selection_screen.dart';
import '../features/auth/presentation/screens/use_case_selection_screen.dart';
import '../features/personal/presentation/screens/personal_home_screen.dart';
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
import '../features/auth/presentation/screens/email_verification_screen.dart';
import '../features/auth/presentation/screens/profile_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import 'route_names.dart';

part 'app_router.g.dart';

// Becomes true once the minimum splash duration has elapsed.
final _splashDoneProvider = StateProvider<bool>((ref) => false);

// How long the splash must stay visible regardless of how fast auth resolves.
const _minSplashDuration = Duration(milliseconds: 2100);

@riverpod
GoRouter appRouter(Ref ref) {
  // Do NOT watch authNotifierProvider here — that would recreate the entire
  // GoRouter (and reset navigation to initialLocation) on every auth state
  // change. Instead, read auth state inside the redirect callback and let
  // _RouterRefreshListenable tell the existing router to re-evaluate redirects.
  return GoRouter(
    initialLocation: RouteNames.splash,
    refreshListenable: _RouterRefreshListenable(ref),
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);
      final splashDone = ref.read(_splashDoneProvider);

      // Stay on splash while auth is loading OR the minimum display time
      // hasn't elapsed yet, so the entrance animation always plays fully.
      if (authState is AsyncLoading || !splashDone) {
        final onAuthOrSplash = state.fullPath == RouteNames.splash ||
            state.fullPath == RouteNames.login ||
            state.fullPath == RouteNames.register ||
            state.fullPath == RouteNames.roleSelection ||
            state.fullPath == RouteNames.useCaseSelection;
        return onAuthOrSplash ? null : RouteNames.splash;
      }

      final profile = authState.valueOrNull;
      final isAuthenticated = profile != null;
      final isOnAuthRoute = state.fullPath == RouteNames.login ||
          state.fullPath == RouteNames.register ||
          state.fullPath == RouteNames.roleSelection ||
          state.fullPath == RouteNames.useCaseSelection ||
          state.fullPath == RouteNames.emailVerification;

      // Not logged in → send to use-case selection
      if (!isAuthenticated) {
        return isOnAuthRoute ? null : RouteNames.useCaseSelection;
      }

      // Logged in but on auth route or splash → send to the right home
      if (isOnAuthRoute || state.fullPath == RouteNames.splash) {
        if (profile.role == UserRole.teacher) return RouteNames.teacherHome;
        if (profile.role == UserRole.student) return RouteNames.studentHome;
        return RouteNames.personalHome;
      }

      // Block personal users from school routes
      if (profile.role == UserRole.personal) {
        if ((state.fullPath?.startsWith('/teacher') ?? false) ||
            (state.fullPath?.startsWith('/student') ?? false)) {
          return RouteNames.personalHome;
        }
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
        path: RouteNames.emailVerification,
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return EmailVerificationScreen(email: email);
        },
      ),
      GoRoute(
        path: RouteNames.useCaseSelection,
        builder: (context, state) => const UseCaseSelectionScreen(),
      ),
      GoRoute(
        path: RouteNames.roleSelection,
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: RouteNames.personalHome,
        builder: (context, state) => const PersonalHomeScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
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
// or when the minimum splash duration elapses.
class _RouterRefreshListenable extends ChangeNotifier {
  _RouterRefreshListenable(Ref ref) {
    ref.listen(authNotifierProvider, (prev, next) => notifyListeners());
    Future.delayed(_minSplashDuration, () {
      if (!_disposed) {
        ref.read(_splashDoneProvider.notifier).state = true;
        notifyListeners();
      }
    });
  }

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
