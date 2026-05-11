import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../router/route_names.dart';
import '../../../../theme/app_theme.dart';
import '../providers/enrolled_classes_provider.dart';
import '../../domain/enrolled_class_model.dart';
import '../../../../shared/widgets/shimmer_widgets.dart';

class StudentHomeScreen extends ConsumerWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(authNotifierProvider).valueOrNull;
    final classesAsync = ref.watch(enrolledClassesNotifierProvider);
    final firstName = profile?.fullName.split(' ').first ?? 'there';

    return Scaffold(
      body: classesAsync.when(
        loading: () => SafeArea(
          child: ShimmerListView(itemBuilder: () => const ShimmerClassCard()),
        ),
        error: (e, _) => SafeArea(
          child: _EmptyBody(
            firstName: firstName,
            onSignOut: () => _confirmSignOut(context, ref),
          ),
        ),
        data: (classes) => classes.isEmpty
            ? SafeArea(
                child: _EmptyBody(
                  firstName: firstName,
                  onSignOut: () => _confirmSignOut(context, ref),
                ),
              )
            : RefreshIndicator(
                color: AppTheme.accent,
                onRefresh: () =>
                    ref.read(enrolledClassesNotifierProvider.notifier).refresh(),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: _StudentHeader(
                        firstName: firstName,
                        classCount: classes.length,
                        onSignOut: () => _confirmSignOut(context, ref),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_, i) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _ClassCard(
                              classModel: classes[i],
                              colorIndex: i,
                              onTap: () => context.push(
                                '/student/home/class/${classes[i].id}',
                                extra: classes[i],
                              ),
                            ),
                          ),
                          childCount: classes.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/student/home/join-class'),
        icon: const Icon(Icons.add, size: 20),
        label: const Text('Join Class'),
      ),
    );
  }
}

// ── Student header ────────────────────────────────────────────────────────────

class _StudentHeader extends StatelessWidget {
  final String firstName;
  final int classCount;
  final VoidCallback onSignOut;

  const _StudentHeader({
    required this.firstName,
    required this.classCount,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.accent,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        MediaQuery.of(context).padding.top + 16,
        24,
        28,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, $firstName 👋',
                  style: const TextStyle(
                    color: AppTheme.accentInk,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  classCount == 1 ? '1 class enrolled' : '$classCount classes enrolled',
                  style: TextStyle(
                    color: AppTheme.accentInk.withValues(alpha: 0.75),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded,
                color: AppTheme.accentInk, size: 20),
            tooltip: 'Sign out',
            onPressed: onSignOut,
          ),
        ],
      ),
    );
  }
}

// ── Sign out ──────────────────────────────────────────────────────────────────

Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Sign out?'),
      content: const Text('Are you sure you want to sign out?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: FilledButton.styleFrom(minimumSize: const Size(80, 40)),
          child: const Text('Sign out'),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return;
  final router = GoRouter.of(context);
  await ref.read(authNotifierProvider.notifier).signOut();
  router.go(RouteNames.useCaseSelection);
}

// ── Empty body ────────────────────────────────────────────────────────────────

class _EmptyBody extends StatelessWidget {
  final String firstName;
  final VoidCallback onSignOut;

  const _EmptyBody({required this.firstName, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: AppTheme.accent,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
          ),
          padding: EdgeInsets.fromLTRB(
            24,
            MediaQuery.of(context).padding.top + 16,
            24,
            28,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Hi, $firstName 👋',
                  style: const TextStyle(
                    color: AppTheme.accentInk,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.logout_rounded,
                    color: AppTheme.accentInk, size: 20),
                tooltip: 'Sign out',
                onPressed: onSignOut,
              ),
            ],
          ),
        ),
        const Expanded(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school_outlined, size: 64, color: AppTheme.line),
                  SizedBox(height: 16),
                  Text('No classes yet',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.text)),
                  SizedBox(height: 8),
                  Text(
                    "Tap 'Join Class' to get started.",
                    style: TextStyle(color: AppTheme.textMute, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Class card ────────────────────────────────────────────────────────────────

class _ClassCard extends StatelessWidget {
  final EnrolledClassModel classModel;
  final int colorIndex;
  final VoidCallback onTap;

  const _ClassCard({
    required this.classModel,
    required this.colorIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette =
        AppTheme.classColors[colorIndex % AppTheme.classColors.length];
    final initials = _initials(classModel.name);

    return Material(
      color: AppTheme.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.lineSoft),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: palette.bg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: TextStyle(
                      color: palette.fg,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      classModel.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.text,
                        letterSpacing: -0.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.surface2,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        classModel.code,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textMute,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded,
                  color: AppTheme.textFaint, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _initials(String name) {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return name.substring(0, math.min(2, name.length)).toUpperCase();
  }
}
