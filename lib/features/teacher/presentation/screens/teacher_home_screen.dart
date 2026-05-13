import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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

    void onProfile() => context.push('/profile');
    void onSignOut() => _confirmSignOut(context, ref);

    Widget shell(int classCount, int activeCount, int studentCount,
        {required Widget child, bool scrollable = true}) {
      final today = DateFormat('EEEE, MMMM d').format(DateTime.now());
      final pct = classCount == 0 ? 0.0 : activeCount / classCount;
      return CustomScrollView(
        physics: scrollable
            ? const BouncingScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                22,
                MediaQuery.of(context).padding.top + 20,
                22,
                0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          today,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textMute,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Hi, $firstName.',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.text,
                            letterSpacing: -0.7,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _IconBtn(icon: Icons.person_outline_rounded, onTap: onProfile),
                  const SizedBox(width: 8),
                  _IconBtn(icon: Icons.logout_rounded, onTap: onSignOut),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 4),
              child: _TeacherHeroCard(
                classCount: classCount,
                studentCount: studentCount,
                pct: pct,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
            sliver: SliverFillRemaining(
              hasScrollBody: true,
              child: child,
            ),
          ),
        ],
      );
    }

    return Scaffold(
      body: classesAsync.when(
        loading: () => shell(0, 0, 0,
            scrollable: false,
            child:
                ShimmerListView(itemBuilder: () => const ShimmerClassCard())),
        error: (e, _) =>
            shell(0, 0, 0, scrollable: false, child: const _EmptyClassesPlaceholder()),
        data: (classes) {
          final totalStudents =
              classes.fold(0, (s, c) => s + c.studentCount);
          final activeCount =
              classes.where((c) => c.studentCount > 0).length;
          final body = classes.isEmpty
              ? const _EmptyClassesPlaceholder()
              : RefreshIndicator(
                  color: AppTheme.accent,
                  onRefresh: () =>
                      ref.read(classNotifierProvider.notifier).refresh(),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
                    itemCount: classes.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => _ClassCard(
                      classModel: classes[i],
                      colorIndex: i,
                      onTap: () async {
                        await context.push(
                          '/teacher/home/class/${classes[i].id}',
                          extra: classes[i],
                        );
                        ref.invalidate(classNotifierProvider);
                      },
                      onEdit: () => _showEditDialog(context, ref, classes[i]),
                      onDelete: () =>
                          _confirmDelete(context, ref, classes[i]),
                    ),
                  ),
                );
          return shell(classes.length, activeCount, totalStudents,
              scrollable: classes.isNotEmpty, child: body);
        },
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

// ── Small icon button ─────────────────────────────────────────────────────────

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.line),
        ),
        child: Icon(icon, size: 17, color: AppTheme.textMute),
      ),
    );
  }
}

// ── Teacher hero card ─────────────────────────────────────────────────────────

class _TeacherHeroCard extends StatelessWidget {
  final int classCount;
  final int studentCount;
  final double pct;

  const _TeacherHeroCard({
    required this.classCount,
    required this.studentCount,
    required this.pct,
  });

  @override
  Widget build(BuildContext context) {
    final subtitle = classCount == 0
        ? 'Create your first class to get started'
        : studentCount == 0
            ? 'No students enrolled yet'
            : '$studentCount ${studentCount == 1 ? 'student' : 'students'} enrolled';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.accent,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accent.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            right: -60,
            bottom: -50,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.10),
                  width: 1.5,
                ),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'YOUR CLASSES',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.accentInk,
                        letterSpacing: 0.1,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '$classCount',
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.accentInk,
                              letterSpacing: -1.2,
                              height: 1,
                            ),
                          ),
                          TextSpan(
                            text:
                                classCount == 1 ? ' class' : ' classes',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color:
                                  AppTheme.accentInk.withValues(alpha: 0.5),
                              letterSpacing: -0.5,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.accentInk.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ),
              _ProgressRing(pct: pct),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Progress ring ─────────────────────────────────────────────────────────────

class _ProgressRing extends StatelessWidget {
  final double pct;
  const _ProgressRing({required this.pct});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: CustomPaint(painter: _RingPainter(pct: pct)),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double pct;
  const _RingPainter({required this.pct});

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 6.0;
    final center = Offset(size.width / 2, size.height / 2);
    final r = (size.width - stroke) / 2;
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.18)
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke,
    );
    if (pct > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: r),
        -math.pi / 2,
        2 * math.pi * pct,
        false,
        Paint()
          ..color = AppTheme.accentInk
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.pct != pct;
}

// ── Empty placeholder ─────────────────────────────────────────────────────────

class _EmptyClassesPlaceholder extends StatelessWidget {
  const _EmptyClassesPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.surface2,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.class_outlined,
                size: 26, color: AppTheme.textMute),
          ),
          const SizedBox(height: 18),
          const Text(
            'No classes yet',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppTheme.text),
          ),
          const SizedBox(height: 6),
          const Text(
            "Tap 'New Class' to get started.",
            style: TextStyle(fontSize: 13.5, color: AppTheme.textMute),
          ),
        ],
      ),
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
