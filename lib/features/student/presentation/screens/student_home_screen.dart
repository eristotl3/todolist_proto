import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/enrolled_classes_provider.dart';
import '../../domain/student_todo_list_model.dart';
import '../../../../core/extensions/datetime_extensions.dart';
import '../../../../shared/widgets/error_retry_widget.dart';
import '../../../../shared/widgets/shimmer_widgets.dart';
import 'join_class_screen.dart';
import 'student_todo_screen.dart';

class StudentHomeScreen extends ConsumerWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(authNotifierProvider).valueOrNull;
    final listsAsync = ref.watch(assignedListsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () => _confirmSignOut(context, ref),
          ),
        ],
      ),
      body: listsAsync.when(
        loading: () => ShimmerListView(
          itemBuilder: () => const ShimmerClassCard(),
        ),
        error: (e, _) => ErrorRetryWidget(
          error: e,
          onRetry: () => ref.invalidate(assignedListsNotifierProvider),
        ),
        data: (lists) => lists.isEmpty
            ? _EmptyState(name: profile?.fullName ?? '')
            : RefreshIndicator(
                onRefresh: () =>
                    ref.read(assignedListsNotifierProvider.notifier).refresh(),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: lists.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, i) => _AssignedListCard(
                    todoList: lists[i],
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            StudentTodoScreen(todoList: lists[i]),
                      ),
                    ),
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const JoinClassScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Join Class'),
      ),
    );
  }
}

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
  if (confirmed == true) {
    ref.read(authNotifierProvider.notifier).signOut();
  }
}

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
            Icon(Icons.school_outlined,
                size: 72, color: theme.colorScheme.outline),
            const SizedBox(height: 16),
            Text('Welcome, $name!',
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'Tap "Join Class" and enter the code your teacher gave you.',
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

class _AssignedListCard extends StatelessWidget {
  final StudentTodoListModel todoList;
  final VoidCallback onTap;

  const _AssignedListCard({required this.todoList, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOverdue = todoList.dueDate != null &&
        todoList.dueDate!.isOverdue &&
        todoList.completedCount < todoList.itemCount;
    final isComplete = todoList.itemCount > 0 &&
        todoList.completedCount == todoList.itemCount;
    final progress = todoList.itemCount == 0
        ? 0.0
        : todoList.completedCount / todoList.itemCount;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isOverdue
              ? theme.colorScheme.error.withValues(alpha: 0.5)
              : isComplete
                  ? theme.colorScheme.primary.withValues(alpha: 0.4)
                  : theme.colorScheme.outlineVariant,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isComplete
                          ? theme.colorScheme.primaryContainer
                          : isOverdue
                              ? theme.colorScheme.errorContainer
                              : theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isComplete
                          ? Icons.check_circle_rounded
                          : Icons.checklist_rounded,
                      color: isComplete
                          ? theme.colorScheme.primary
                          : isOverdue
                              ? theme.colorScheme.error
                              : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          todoList.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600),
                        ),
                        if (todoList.classNameLabel.isNotEmpty)
                          Text(
                            todoList.classNameLabel,
                            style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant),
                          ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: progress,
                      borderRadius: BorderRadius.circular(4),
                      minHeight: 6,
                      color: isComplete
                          ? theme.colorScheme.primary
                          : isOverdue
                              ? theme.colorScheme.error
                              : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${todoList.completedCount}/${todoList.itemCount}',
                    style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
              if (todoList.dueDate != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded,
                        size: 12,
                        color: isOverdue
                            ? theme.colorScheme.error
                            : theme.colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      'Due ${todoList.dueDate!.toDisplayDate()}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isOverdue
                            ? theme.colorScheme.error
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
