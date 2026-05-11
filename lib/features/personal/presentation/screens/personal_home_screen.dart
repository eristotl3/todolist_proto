import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/personal_task_provider.dart';
import '../../domain/personal_task_model.dart';
import '../../../../router/route_names.dart';
import '../../../../shared/widgets/shimmer_widgets.dart';
import '../../../../theme/app_theme.dart';

final _dateFmt = DateFormat('MMM d');

String _formatDateRange(DateTime? start, DateTime? end) {
  if (start == null) return '';
  if (end == null || _sameDay(start, end)) return _dateFmt.format(start);
  return '${_dateFmt.format(start)} – ${_dateFmt.format(end)}';
}

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

// ── Screen ──────────────────────────────────────────────────────────────────

class PersonalHomeScreen extends ConsumerStatefulWidget {
  const PersonalHomeScreen({super.key});

  @override
  ConsumerState<PersonalHomeScreen> createState() => _PersonalHomeScreenState();
}

class _PersonalHomeScreenState extends ConsumerState<PersonalHomeScreen> {
  bool _showSwipeHint = true;

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(authNotifierProvider).valueOrNull;
    final tasksAsync = ref.watch(personalTaskNotifierProvider);
    final firstName = profile?.fullName.split(' ').first ?? 'there';

    void signOut() => _confirmSignOut(context, ref);

    return Scaffold(
      body: tasksAsync.when(
        loading: () => _buildShell(firstName, 0, 0, signOut,
            child: const ShimmerListView(
                itemBuilder: _shimmerCard)),
        error: (e, _) => _buildShell(firstName, 0, 0, signOut,
            child: const _EmptyTasksPlaceholder()),
        data: (tasks) {
          final done = tasks.where((t) => t.isCompleted).length;
          final total = tasks.length;

          if (tasks.isEmpty) {
            return _buildShell(firstName, 0, 0, signOut,
                child: const _EmptyTasksPlaceholder());
          }

          final sections = _buildSections(tasks);
          final hintCount = _showSwipeHint ? 1 : 0;
          final itemCount = hintCount +
              sections.fold<int>(
                  0,
                  (s, e) =>
                      s + e.items.length + (e.name != null ? 1 : 0));

          return _buildShell(
            firstName,
            done,
            total,
            signOut,
            child: RefreshIndicator(
              color: AppTheme.accent,
              onRefresh: () =>
                  ref.read(personalTaskNotifierProvider.notifier).refresh(),
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
                itemCount: itemCount,
                itemBuilder: (ctx, rawIndex) {
                  var idx = rawIndex;

                  if (_showSwipeHint) {
                    if (idx == 0) {
                      return _SwipeHintBanner(
                        onDismiss: () =>
                            setState(() => _showSwipeHint = false),
                      );
                    }
                    idx--;
                  }

                  for (final section in sections) {
                    final headerCount = section.name != null ? 1 : 0;
                    final total2 = headerCount + section.items.length;
                    if (idx < total2) {
                      if (section.name != null && idx == 0) {
                        return _GroupHeader(name: section.name!);
                      }
                      final task = section.items[idx - headerCount];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 9),
                        child: _TaskCard(
                          task: task,
                          onToggle: () => ref
                              .read(personalTaskNotifierProvider.notifier)
                              .toggleTask(task.id),
                          onDelete: () => ref
                              .read(personalTaskNotifierProvider.notifier)
                              .deleteTask(task.id),
                        ),
                      );
                    }
                    idx -= total2;
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final tasks =
              ref.read(personalTaskNotifierProvider).valueOrNull ?? [];
          final existingGroups = tasks
              .map((t) => t.groupName)
              .whereType<String>()
              .toSet()
              .toList()
            ..sort();
          _showAddDialog(context, ref, existingGroups);
        },
        icon: const Icon(Icons.add, size: 20),
        label: const Text('New task'),
      ),
    );
  }

  // Builds the full-page scaffold: top header + progress hero + scrollable child
  Widget _buildShell(
    String firstName,
    int done,
    int total,
    VoidCallback onSignOut, {
    required Widget child,
  }) {
    final today = DateFormat('EEEE, MMMM d').format(DateTime.now());
    final pct = total == 0 ? 0.0 : done / total;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── Top header (warm bg) ─────────────────────────────────
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
                _IconButton(
                  icon: Icons.logout_rounded,
                  onTap: onSignOut,
                ),
              ],
            ),
          ),
        ),

        // ── Progress hero card (terracotta) ──────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 4),
            child: _ProgressHeroCard(done: done, total: total, pct: pct),
          ),
        ),

        // ── Task list ────────────────────────────────────────────
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

  List<_Section> _buildSections(List<PersonalTaskModel> tasks) {
    final named = <String, List<PersonalTaskModel>>{};
    final ungrouped = <PersonalTaskModel>[];

    for (final t in tasks) {
      if (t.groupName != null && t.groupName!.isNotEmpty) {
        (named[t.groupName!] ??= []).add(t);
      } else {
        ungrouped.add(t);
      }
    }

    return [
      if (ungrouped.isNotEmpty) _Section(name: null, items: ungrouped),
      ...named.entries
          .map((e) => _Section(name: e.key, items: e.value))
          .toList()
        ..sort((a, b) => a.name!.compareTo(b.name!)),
    ];
  }
}

Widget _shimmerCard() => const ShimmerClassCard();

class _Section {
  final String? name;
  final List<PersonalTaskModel> items;
  const _Section({required this.name, required this.items});
}

// ── Small icon button (surface bg) ───────────────────────────────────────────

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconButton({required this.icon, required this.onTap});

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

// ── Progress hero card ────────────────────────────────────────────────────────

class _ProgressHeroCard extends StatelessWidget {
  final int done;
  final int total;
  final double pct;

  const _ProgressHeroCard(
      {required this.done, required this.total, required this.pct});

  @override
  Widget build(BuildContext context) {
    final subtitle = total == 0
        ? 'Nothing planned yet'
        : done == total
            ? "You're all done — nice."
            : '${total - done} left to go';

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
          // Decorative circles
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
          // Content
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "TODAY'S PROGRESS",
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
                            text: '$done',
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.accentInk,
                              letterSpacing: -1.2,
                              height: 1,
                            ),
                          ),
                          TextSpan(
                            text: ' / $total',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.accentInk
                                  .withValues(alpha: 0.5),
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

class _ProgressRing extends StatelessWidget {
  final double pct;
  const _ProgressRing({required this.pct});

  @override
  Widget build(BuildContext context) {
    const size = 64.0;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(pct: pct),
      ),
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

// ── Empty placeholder ────────────────────────────────────────────────────────

class _EmptyTasksPlaceholder extends StatelessWidget {
  const _EmptyTasksPlaceholder();

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
            child: const Icon(Icons.auto_awesome_rounded,
                size: 26, color: AppTheme.textMute),
          ),
          const SizedBox(height: 18),
          const Text(
            'No tasks yet',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppTheme.text),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tap New task to add your first.',
            style: TextStyle(fontSize: 13.5, color: AppTheme.textMute),
          ),
        ],
      ),
    );
  }
}

// ── Add task dialog ──────────────────────────────────────────────────────────

Future<void> _showAddDialog(
    BuildContext context, WidgetRef ref, List<String> existingGroups) async {
  final input = await showDialog<_TaskInput>(
    context: context,
    builder: (_) => _AddTaskDialog(existingGroups: existingGroups),
  );
  if (input == null || !context.mounted) return;
  try {
    await ref.read(personalTaskNotifierProvider.notifier).addTask(
          title: input.title,
          startDate: input.startDate,
          endDate: input.endDate,
          groupName: input.groupName,
        );
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add task: $e'),
          backgroundColor: AppTheme.danger,
        ),
      );
    }
  }
}

class _TaskInput {
  final String title;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? groupName;
  const _TaskInput(
      {required this.title, this.startDate, this.endDate, this.groupName});
}

class _AddTaskDialog extends StatefulWidget {
  final List<String> existingGroups;
  const _AddTaskDialog({required this.existingGroups});

  @override
  State<_AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<_AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _groupController = TextEditingController();
  DateTimeRange? _range;

  @override
  void dispose() {
    _titleController.dispose();
    _groupController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      initialDateRange: _range,
      helpText: 'Select date or range',
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: Theme.of(ctx)
              .colorScheme
              .copyWith(primary: AppTheme.accent),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _range = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final group = _groupController.text.trim();
    Navigator.pop(
      context,
      _TaskInput(
        title: _titleController.text.trim(),
        startDate: _range?.start,
        endDate: _range?.end,
        groupName: group.isEmpty ? null : group,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New task'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Task',
                  hintText: 'e.g. Email Prof. Lin',
                  prefixIcon: Icon(Icons.check_circle_outline_rounded,
                      size: 18, color: AppTheme.textFaint),
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Enter a task name'
                    : null,
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 12),
              if (_range == null)
                OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today_outlined, size: 15),
                  label: const Text('Add date  (optional)'),
                  onPressed: _pickDate,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 46),
                    side: const BorderSide(
                        color: AppTheme.line, style: BorderStyle.none),
                    foregroundColor: AppTheme.textMute,
                    backgroundColor: AppTheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                          color: AppTheme.line,
                          style: BorderStyle.solid,
                          width: 1),
                    ),
                  ),
                )
              else
                GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.accentMute,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.accent),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined,
                            size: 15, color: AppTheme.accent),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _formatDateRange(_range!.start, _range!.end),
                            style: const TextStyle(
                                color: AppTheme.accent,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _range = null),
                          child: const Icon(Icons.close,
                              size: 15, color: AppTheme.accent),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _groupController,
                decoration: const InputDecoration(
                  labelText: 'Group',
                  hintText: 'optional',
                  prefixIcon: Icon(Icons.folder_outlined,
                      size: 18, color: AppTheme.textFaint),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              if (widget.existingGroups.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: widget.existingGroups
                      .map((g) => ActionChip(
                            label: Text(g),
                            visualDensity: VisualDensity.compact,
                            onPressed: () => setState(
                                () => _groupController.text = g),
                          ))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          style: FilledButton.styleFrom(
              minimumSize: const Size(80, 40)),
          child: const Text('Add'),
        ),
      ],
    );
  }
}

// ── Sign-out ──────────────────────────────────────────────────────────────────

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

// ── Swipe hint banner ────────────────────────────────────────────────────────

class _SwipeHintBanner extends StatelessWidget {
  final VoidCallback onDismiss;
  const _SwipeHintBanner({required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.accentSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accent.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.swipe_left_alt_rounded,
              size: 15, color: AppTheme.accent),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Swipe left on a task to delete it',
              style: TextStyle(
                  color: AppTheme.accent,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            ),
          ),
          GestureDetector(
            onTap: onDismiss,
            child: const Icon(Icons.close, size: 14, color: AppTheme.textFaint),
          ),
        ],
      ),
    );
  }
}

// ── Group header ─────────────────────────────────────────────────────────────

class _GroupHeader extends StatelessWidget {
  final String name;
  const _GroupHeader({required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 10),
      child: Row(
        children: [
          Text(
            name.toUpperCase(),
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppTheme.textMute,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(child: Divider(color: AppTheme.lineSoft)),
        ],
      ),
    );
  }
}

// ── Task card ─────────────────────────────────────────────────────────────────

class _TaskCard extends StatelessWidget {
  final PersonalTaskModel task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _TaskCard(
      {required this.task, required this.onToggle, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final dateLabel = _formatDateRange(task.startDate, task.endDate);

    return Slidable(
      key: ValueKey(task.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (_) => onDelete(),
            backgroundColor: AppTheme.danger,
            foregroundColor: Colors.white,
            icon: Icons.delete_rounded,
            label: 'Delete',
            borderRadius:
                const BorderRadius.horizontal(right: Radius.circular(18)),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onToggle,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 15, 12, 15),
          decoration: BoxDecoration(
            color: task.isCompleted ? AppTheme.surface2 : AppTheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: task.isCompleted ? AppTheme.lineSoft : AppTheme.line,
            ),
            boxShadow: task.isCompleted
                ? null
                : [
                    BoxShadow(
                      color: const Color(0x0A321E00),
                      blurRadius: 6,
                      offset: const Offset(0, 1),
                    ),
                  ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Checkbox
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color:
                      task.isCompleted ? AppTheme.accent : Colors.transparent,
                  border: Border.all(
                    color: task.isCompleted ? AppTheme.accent : AppTheme.line,
                    width: 1.7,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: task.isCompleted
                      ? [
                          BoxShadow(
                            color: AppTheme.accent.withValues(alpha: 0.3),
                            blurRadius: 0,
                            spreadRadius: 3,
                          ),
                        ]
                      : null,
                ),
                child: task.isCompleted
                    ? const Icon(Icons.check_rounded,
                        size: 13, color: AppTheme.accentInk)
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.15,
                        color: task.isCompleted
                            ? AppTheme.textFaint
                            : AppTheme.text,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        decorationColor: AppTheme.textFaint,
                      ),
                    ),
                    if (dateLabel.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined,
                              size: 11, color: AppTheme.textFaint),
                          const SizedBox(width: 4),
                          Text(
                            dateLabel,
                            style: const TextStyle(
                                fontSize: 12, color: AppTheme.textFaint),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // Inline delete
              GestureDetector(
                onTap: onDelete,
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(Icons.close,
                      size: 15, color: AppTheme.textFaint),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
