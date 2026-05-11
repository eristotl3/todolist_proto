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
      appBar: AppBar(
        title: Text('Hi, $firstName!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () => _confirmSignOut(context, ref),
          ),
        ],
      ),
      body: tasksAsync.when(
        loading: () => ShimmerListView(itemBuilder: () => const ShimmerClassCard()),
        error: (e, _) => _EmptyState(name: profile?.fullName ?? ''),
        data: (tasks) {
          if (tasks.isEmpty) return _EmptyState(name: profile?.fullName ?? '');

          // Build flat list: hint + grouped sections
          final sections = _buildSections(tasks);
          final itemCount = (_showSwipeHint ? 1 : 0) +
              sections.fold<int>(
                  0, (s, e) => s + e.items.length + (e.name != null ? 1 : 0));

          return RefreshIndicator(
            onRefresh: () =>
                ref.read(personalTaskNotifierProvider.notifier).refresh(),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: itemCount,
              itemBuilder: (ctx, rawIndex) {
                var idx = rawIndex;

                // Swipe hint banner
                if (_showSwipeHint) {
                  if (idx == 0) return _SwipeHintBanner(onDismiss: () => setState(() => _showSwipeHint = false));
                  idx--;
                }

                // Map flat index to section/item
                for (final section in sections) {
                  final headerCount = section.name != null ? 1 : 0;
                  final total = headerCount + section.items.length;
                  if (idx < total) {
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
                  idx -= total;
                }
                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final tasks = ref.read(personalTaskNotifierProvider).valueOrNull ?? [];
          final existingGroups = tasks
              .map((t) => t.groupName)
              .whereType<String>()
              .toSet()
              .toList()
            ..sort();
          _showAddDialog(context, ref, existingGroups);
        },
        icon: const Icon(Icons.add),
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
          backgroundColor: Theme.of(context).colorScheme.error,
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
    final theme = Theme.of(context);
    return AlertDialog(
      title: const Text('New Task'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Task name
              TextFormField(
                controller: _titleController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Task name',
                  hintText: 'e.g. Buy groceries',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.check_circle_outline),
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter a task name' : null,
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 12),

              // Date picker
              if (_range == null)
                OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today_outlined, size: 16),
                  label: const Text('Add date (optional)'),
                  onPressed: _pickDate,
                )
              else
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.colorScheme.primary),
                      borderRadius: BorderRadius.circular(8),
                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,
                            size: 16, color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _formatDateRange(_range!.start, _range!.end),
                            style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.primary),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _range = null),
                          child: Icon(Icons.close,
                              size: 16,
                              color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 12),

              // Group field
              TextFormField(
                controller: _groupController,
                decoration: const InputDecoration(
                  labelText: 'Group (optional)',
                  hintText: 'e.g. Groceries',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.folder_outlined),
                ),
                textCapitalization: TextCapitalization.words,
              ),

              // Existing group quick-select chips
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
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.swipe_left_outlined,
              size: 18, color: theme.colorScheme.onSecondaryContainer),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Swipe left on a task to reveal the delete button',
              style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer),
            ),
          ),
          GestureDetector(
            onTap: onDismiss,
            child: Icon(Icons.close,
                size: 16, color: theme.colorScheme.onSecondaryContainer),
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
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        children: [
          Icon(Icons.folder_rounded,
              size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 6),
          Text(
            name,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Divider(
              thickness: 1,
              color: theme.colorScheme.outlineVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final String name;
  const _EmptyState({required this.name});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.checklist_rounded,
                size: 72, color: theme.colorScheme.outline),
            const SizedBox(height: 16),
            Text('No tasks yet',
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              "Tap 'Add Task' to get started.",
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
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
    final theme = Theme.of(context);
    final dateLabel = _formatDateRange(task.startDate, task.endDate);

    return Slidable(
      key: ValueKey(task.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.28,
        children: [
          SlidableAction(
            onPressed: (_) => onDelete(),
            backgroundColor: theme.colorScheme.error,
            foregroundColor: Colors.white,
            icon: Icons.delete_rounded,
            label: 'Delete',
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(16),
            ),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: task.isCompleted
                ? theme.colorScheme.outlineVariant.withValues(alpha: 0.4)
                : theme.colorScheme.outlineVariant,
          ),
        ),
        color: task.isCompleted
            ? theme.colorScheme.surfaceContainerHighest
            : theme.colorScheme.surface,
        child: InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Checkbox
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: task.isCompleted
                        ? theme.colorScheme.primary
                        : Colors.transparent,
                    border: Border.all(
                      color: task.isCompleted
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: task.isCompleted
                      ? Icon(Icons.check_rounded,
                          size: 16, color: theme.colorScheme.onPrimary)
                      : null,
                ),
                const SizedBox(width: 14),
                // Title + date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: task.isCompleted
                              ? theme.colorScheme.onSurfaceVariant
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      if (dateLabel.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 12,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              dateLabel,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                // Delete shortcut
                IconButton(
                  icon: Icon(Icons.delete_outline,
                      size: 20, color: theme.colorScheme.onSurfaceVariant),
                  onPressed: onDelete,
                  tooltip: 'Delete',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
