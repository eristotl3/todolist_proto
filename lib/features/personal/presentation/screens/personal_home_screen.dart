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

    return Scaffold(
      body: tasksAsync.when(
        loading: () => SafeArea(
          child: ShimmerListView(itemBuilder: () => const ShimmerClassCard()),
        ),
        error: (e, _) => SafeArea(child: _EmptyBody(firstName: firstName)),
        data: (tasks) {
          final done = tasks.where((t) => t.isCompleted).length;
          final total = tasks.length;

          if (tasks.isEmpty) {
            return SafeArea(child: _EmptyBody(firstName: firstName));
          }

          final sections = _buildSections(tasks);
          final hintCount = _showSwipeHint ? 1 : 0;
          final itemCount = hintCount +
              sections.fold<int>(
                  0, (s, e) => s + e.items.length + (e.name != null ? 1 : 0));

          return RefreshIndicator(
            color: AppTheme.accent,
            onRefresh: () =>
                ref.read(personalTaskNotifierProvider.notifier).refresh(),
            child: CustomScrollView(
              slivers: [
                // ── Hero header ──────────────────────────────────────
                SliverToBoxAdapter(
                  child: _HeroHeader(
                    firstName: firstName,
                    done: done,
                    total: total,
                    onSignOut: () => _confirmSignOut(context, ref),
                  ),
                ),
                // ── Task list ─────────────────────────────────────────
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, rawIndex) {
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
                              padding: const EdgeInsets.only(bottom: 10),
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
                      childCount: itemCount,
                    ),
                  ),
                ),
              ],
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
        label: const Text('Add Task'),
      ),
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

class _Section {
  final String? name;
  final List<PersonalTaskModel> items;
  const _Section({required this.name, required this.items});
}

// ── Hero header ──────────────────────────────────────────────────────────────

class _HeroHeader extends StatelessWidget {
  final String firstName;
  final int done;
  final int total;
  final VoidCallback onSignOut;

  const _HeroHeader({
    required this.firstName,
    required this.done,
    required this.total,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    final allDone = total > 0 && done == total;
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
                  allDone
                      ? 'All done! Great work today.'
                      : '$done of $total tasks complete',
                  style: TextStyle(
                    color: AppTheme.accentInk.withValues(alpha: 0.75),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          _CompletionRing(done: done, total: total),
          const SizedBox(width: 12),
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

class _CompletionRing extends StatelessWidget {
  final int done;
  final int total;

  const _CompletionRing({required this.done, required this.total});

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : done / total;
    return SizedBox(
      width: 60,
      height: 60,
      child: CustomPaint(
        painter: _RingPainter(progress: progress),
        child: Center(
          child: Text(
            total == 0 ? '–' : '$done',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.accentInk,
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  const _RingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 8) / 2;
    final trackPaint = Paint()
      ..color = AppTheme.accentInk.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5;
    canvas.drawCircle(center, radius, trackPaint);
    if (progress > 0) {
      final arcPaint = Paint()
        ..color = AppTheme.accentInk
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.5
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        arcPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
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
  const _TaskInput({
    required this.title,
    this.startDate,
    this.endDate,
    this.groupName,
  });
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
          colorScheme: Theme.of(ctx).colorScheme.copyWith(primary: AppTheme.accent),
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
      title: const Text('New Task'),
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
                  labelText: 'Task name',
                  hintText: 'e.g. Buy groceries',
                  prefixIcon: Icon(Icons.check_circle_outline_rounded, size: 20),
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter a task name' : null,
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 12),
              if (_range == null)
                OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today_outlined, size: 16),
                  label: const Text('Add date (optional)'),
                  onPressed: _pickDate,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 44),
                  ),
                )
              else
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: AppTheme.accent.withValues(alpha: 0.6)),
                      borderRadius: BorderRadius.circular(10),
                      color: AppTheme.accentSoft,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined,
                            size: 16, color: AppTheme.accent),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _formatDateRange(_range!.start, _range!.end),
                            style: const TextStyle(
                                color: AppTheme.accent, fontSize: 13),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _range = null),
                          child: const Icon(Icons.close,
                              size: 16, color: AppTheme.textFaint),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _groupController,
                decoration: const InputDecoration(
                  labelText: 'Group (optional)',
                  hintText: 'e.g. Groceries',
                  prefixIcon: Icon(Icons.folder_outlined, size: 20),
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
                            onPressed: () =>
                                setState(() => _groupController.text = g),
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
            minimumSize: const Size(80, 40),
          ),
          child: const Text('Add'),
        ),
      ],
    );
  }
}

// ── Sign-out ─────────────────────────────────────────────────────────────────

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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.accentSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accent.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.swipe_left_alt_rounded,
              size: 16, color: AppTheme.accent),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Swipe left on a task to reveal the delete button',
              style: TextStyle(
                  color: AppTheme.accent,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            ),
          ),
          GestureDetector(
            onTap: onDismiss,
            child:
                const Icon(Icons.close, size: 14, color: AppTheme.textFaint),
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
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.folder_rounded, size: 14, color: AppTheme.accent),
          const SizedBox(width: 6),
          Text(
            name.toUpperCase(),
            style: const TextStyle(
              color: AppTheme.accent,
              fontWeight: FontWeight.w700,
              fontSize: 10,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(child: Divider(color: AppTheme.lineSoft)),
        ],
      ),
    );
  }
}

// ── Empty body ───────────────────────────────────────────────────────────────

class _EmptyBody extends StatelessWidget {
  final String firstName;
  const _EmptyBody({required this.firstName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Minimal hero header (no stats)
        Container(
          decoration: const BoxDecoration(
            color: AppTheme.accent,
            borderRadius:
                BorderRadius.vertical(bottom: Radius.circular(28)),
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
                onPressed: () {
                  // handled by parent consumer
                },
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
                  Icon(Icons.checklist_rounded,
                      size: 64, color: AppTheme.line),
                  SizedBox(height: 16),
                  Text('No tasks yet',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.text)),
                  SizedBox(height: 8),
                  Text(
                    "Tap 'Add Task' to get started.",
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

// ── Task card ─────────────────────────────────────────────────────────────────

class _TaskCard extends StatelessWidget {
  final PersonalTaskModel task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _TaskCard({
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateLabel = _formatDateRange(task.startDate, task.endDate);

    return Slidable(
      key: ValueKey(task.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.28,
        children: [
          SlidableAction(
            onPressed: (_) => onDelete(),
            backgroundColor: AppTheme.danger,
            foregroundColor: Colors.white,
            icon: Icons.delete_rounded,
            label: 'Delete',
            borderRadius:
                const BorderRadius.horizontal(right: Radius.circular(16)),
          ),
        ],
      ),
      child: Material(
        color: task.isCompleted ? AppTheme.surface2 : AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: task.isCompleted
                    ? AppTheme.lineSoft
                    : AppTheme.line,
              ),
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
                    color: task.isCompleted ? AppTheme.accent : Colors.transparent,
                    border: Border.all(
                      color: task.isCompleted
                          ? AppTheme.accent
                          : AppTheme.line,
                      width: 1.8,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: task.isCompleted
                      ? const Icon(Icons.check_rounded,
                          size: 14, color: AppTheme.accentInk)
                      : null,
                ),
                const SizedBox(width: 12),
                // Title + date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
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
                                  fontSize: 11, color: AppTheme.textFaint),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                // Inline delete
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded,
                      size: 18, color: AppTheme.textFaint),
                  onPressed: onDelete,
                  tooltip: 'Delete',
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
