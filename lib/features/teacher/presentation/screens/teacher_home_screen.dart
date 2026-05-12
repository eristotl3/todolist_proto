import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/layout_constants.dart';
import '../../../../router/route_names.dart';
import '../../../../theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/class_provider.dart';
import '../../domain/class_model.dart';
import 'teacher_shell.dart';
import '../../../../shared/widgets/shimmer_widgets.dart';

class TeacherHomeScreen extends ConsumerWidget {
  const TeacherHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= LayoutConstants.desktopBreakpoint) {
          return const TeacherDesktopShell();
        }
        return const _TeacherMobileHome();
      },
    );
  }
}

// ── Mobile layout ─────────────────────────────────────────────────────────────

class _TeacherMobileHome extends ConsumerWidget {
  const _TeacherMobileHome();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(authNotifierProvider).valueOrNull;
    final classesAsync = ref.watch(classNotifierProvider);
    final firstName = profile?.fullName.split(' ').first ?? 'there';

    return Scaffold(
      body: classesAsync.when(
        loading: () => SafeArea(
          child: ShimmerListView(itemBuilder: () => const ShimmerClassCard()),
        ),
        error: (e, _) => SafeArea(
          child: _EmptyBody(
            name: profile?.fullName ?? '',
            firstName: firstName,
            onProfile: () => context.push('/profile'),
            onSignOut: () => _confirmSignOut(context, ref),
          ),
        ),
        data: (classes) => classes.isEmpty
            ? SafeArea(
                child: _EmptyBody(
                  name: profile?.fullName ?? '',
                  firstName: firstName,
                  onProfile: () => context.push('/profile'),
                  onSignOut: () => _confirmSignOut(context, ref),
                ),
              )
            : RefreshIndicator(
                color: AppTheme.accent,
                onRefresh: () =>
                    ref.read(classNotifierProvider.notifier).refresh(),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: _TeacherHeader(
                        firstName: firstName,
                        classCount: classes.length,
                        onProfile: () => context.push('/profile'),
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
                                '/teacher/home/class/${classes[i].id}',
                                extra: classes[i],
                              ),
                              onEdit: () =>
                                  _showEditDialog(context, ref, classes[i]),
                              onDelete: () =>
                                  _confirmDelete(context, ref, classes[i]),
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
        onPressed: () => _showCreateDialog(context, ref),
        icon: const Icon(Icons.add, size: 20),
        label: const Text('New Class'),
      ),
    );
  }

  Future<void> _showEditDialog(
      BuildContext context, WidgetRef ref, ClassModel c) async {
    final controller = TextEditingController(text: c.name);
    final formKey = GlobalKey<FormState>();
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename Class'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Class name'),
            textCapitalization: TextCapitalization.words,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Enter a class name' : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              final name = controller.text.trim();
              Navigator.pop(ctx);
              try {
                await ref
                    .read(classNotifierProvider.notifier)
                    .editClass(c.id, name);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to rename: $e'),
                      backgroundColor: AppTheme.danger,
                    ),
                  );
                }
              }
            },
            style: FilledButton.styleFrom(minimumSize: const Size(80, 40)),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _showCreateDialog(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create Class'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Class name',
              hintText: 'e.g. Math Period 3',
            ),
            textCapitalization: TextCapitalization.words,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Enter a class name' : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              final name = controller.text.trim();
              Navigator.pop(ctx);
              try {
                await ref
                    .read(classNotifierProvider.notifier)
                    .createClass(name);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to create class: $e'),
                      backgroundColor: AppTheme.danger,
                    ),
                  );
                }
              }
            },
            style: FilledButton.styleFrom(minimumSize: const Size(80, 40)),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, ClassModel c) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Class'),
        content: Text(
            'Delete "${c.name}"? All lists and student data will be removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: AppTheme.danger,
                foregroundColor: Colors.white,
                minimumSize: const Size(80, 40)),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(classNotifierProvider.notifier).deleteClass(c.id);
    }
  }
}

// ── Teacher header ────────────────────────────────────────────────────────────

class _TeacherHeader extends StatelessWidget {
  final String firstName;
  final int classCount;
  final VoidCallback onProfile;
  final VoidCallback onSignOut;

  const _TeacherHeader({
    required this.firstName,
    required this.classCount,
    required this.onProfile,
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
                  classCount == 1 ? '1 class' : '$classCount classes',
                  style: TextStyle(
                    color: AppTheme.accentInk.withValues(alpha: 0.75),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline_rounded,
                color: AppTheme.accentInk, size: 20),
            tooltip: 'Profile',
            onPressed: onProfile,
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

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyBody extends StatelessWidget {
  final String name;
  final String firstName;
  final VoidCallback onSignOut;
  final VoidCallback? onProfile;

  const _EmptyBody({
    required this.name,
    required this.firstName,
    required this.onSignOut,
    this.onProfile,
  });

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
              if (onProfile != null)
                IconButton(
                  icon: const Icon(Icons.person_outline_rounded,
                      color: AppTheme.accentInk, size: 20),
                  tooltip: 'Profile',
                  onPressed: onProfile,
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
                  Icon(Icons.class_outlined, size: 64, color: AppTheme.line),
                  SizedBox(height: 16),
                  Text('No classes yet',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.text)),
                  SizedBox(height: 8),
                  Text(
                    "Tap 'New Class' to get started.",
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
  final ClassModel classModel;
  final int colorIndex;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ClassCard({
    required this.classModel,
    required this.colorIndex,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.classColors[colorIndex % AppTheme.classColors.length];
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
              // Color-coded initials circle
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
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.people_outline_rounded,
                            size: 12, color: AppTheme.textFaint),
                        const SizedBox(width: 3),
                        Text(
                          '${classModel.studentCount}',
                          style: const TextStyle(
                              fontSize: 12, color: AppTheme.textMute),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.checklist_rounded,
                            size: 12, color: AppTheme.textFaint),
                        const SizedBox(width: 3),
                        Text(
                          '${classModel.listCount} lists',
                          style: const TextStyle(
                              fontSize: 12, color: AppTheme.textMute),
                        ),
                        const SizedBox(width: 10),
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
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined,
                    color: AppTheme.textMute, size: 18),
                onPressed: onEdit,
                padding: EdgeInsets.zero,
                constraints:
                    const BoxConstraints(minWidth: 36, minHeight: 36),
                tooltip: 'Rename',
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded,
                    color: AppTheme.danger, size: 18),
                onPressed: onDelete,
                padding: EdgeInsets.zero,
                constraints:
                    const BoxConstraints(minWidth: 36, minHeight: 36),
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
