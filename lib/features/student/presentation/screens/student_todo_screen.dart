import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/student_todo_list_model.dart';
import '../providers/student_completion_provider.dart';
import '../widgets/checkable_item_widget.dart';
import '../../../../core/extensions/datetime_extensions.dart';
import '../../../../shared/widgets/error_retry_widget.dart';
import '../../../../shared/widgets/shimmer_widgets.dart';

class StudentTodoScreen extends ConsumerWidget {
  final StudentTodoListModel todoList;
  const StudentTodoScreen({super.key, required this.todoList});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync =
        ref.watch(studentCompletionNotifierProvider(todoList.id));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(todoList.title),
        bottom: (todoList.dueDate != null || todoList.classNameLabel.isNotEmpty)
            ? PreferredSize(
                preferredSize: const Size.fromHeight(32),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (todoList.classNameLabel.isNotEmpty) ...[
                        Icon(Icons.class_rounded,
                            size: 14,
                            color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(todoList.classNameLabel,
                            style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant)),
                      ],
                      if (todoList.dueDate != null) ...[
                        const SizedBox(width: 12),
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 14,
                          color: todoList.dueDate!.isOverdue
                              ? theme.colorScheme.error
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Due ${todoList.dueDate!.toDisplayDate()}',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: todoList.dueDate!.isOverdue
                                ? theme.colorScheme.error
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              )
            : null,
      ),
      body: itemsAsync.when(
        loading: () =>
            ShimmerListView(itemBuilder: () => const ShimmerListTile()),
        error: (e, _) => ErrorRetryWidget(
          error: e,
          onRetry: () =>
              ref.invalidate(studentCompletionNotifierProvider(todoList.id)),
        ),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.checklist_rounded,
                      size: 64, color: theme.colorScheme.outline),
                  const SizedBox(height: 16),
                  Text('No items yet',
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('Your teacher hasn\'t added any tasks yet.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
            );
          }

          final completedCount = items.where((s) => s.isCompleted).length;

          return Column(
            children: [
              // Progress bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$completedCount of ${items.length} completed',
                          style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant),
                        ),
                        if (completedCount == items.length)
                          Row(
                            children: [
                              Icon(Icons.check_circle_rounded,
                                  size: 16,
                                  color: theme.colorScheme.primary),
                              const SizedBox(width: 4),
                              Text('All done!',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                      color: theme.colorScheme.primary)),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: items.isEmpty
                          ? 0
                          : completedCount / items.length,
                      borderRadius: BorderRadius.circular(4),
                      minHeight: 8,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => ref
                      .read(studentCompletionNotifierProvider(todoList.id)
                          .notifier)
                      .refresh(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, i) => CheckableItemWidget(
                      itemState: items[i],
                      onToggle: () => ref
                          .read(studentCompletionNotifierProvider(todoList.id)
                              .notifier)
                          .toggle(items[i].item.id),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
