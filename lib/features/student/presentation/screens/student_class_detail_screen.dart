import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/enrolled_class_model.dart';
import '../../domain/student_todo_list_model.dart';
import '../providers/enrolled_classes_provider.dart';
import '../../../../core/extensions/datetime_extensions.dart';
import '../../../../shared/widgets/shimmer_widgets.dart';
import '../../../../shared/widgets/error_retry_widget.dart';
import '../../../../theme/app_theme.dart';

int _classColorIndex(String classId) =>
    classId.codeUnits.fold(0, (a, b) => a + b) % AppTheme.classColors.length;

class StudentClassDetailScreen extends ConsumerWidget {
  final EnrolledClassModel classModel;
  const StudentClassDetailScreen({super.key, required this.classModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listsAsync = ref.watch(studentClassListsProvider(classModel.id));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(classModel.name),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(36),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Code: ${classModel.code}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: listsAsync.when(
        loading: () =>
            ShimmerListView(itemBuilder: () => const ShimmerClassCard()),
        error: (e, _) => ErrorRetryWidget(
          error: e,
          onRetry: () =>
              ref.invalidate(studentClassListsProvider(classModel.id)),
        ),
        data: (lists) => lists.isEmpty
            ? Center(
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
                        'Your admin hasn\'t assigned any tasks yet.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            : RefreshIndicator(
                onRefresh: () async =>
                    ref.invalidate(studentClassListsProvider(classModel.id)),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: lists.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => _TaskListCard(
                    todoList: lists[i],
                    classColorIndex: _classColorIndex(classModel.id),
                    onTap: () async {
                      await context.push(
                        '/student/home/class/${classModel.id}/todo/${lists[i].id}',
                        extra: lists[i],
                      );
                      ref.invalidate(studentClassListsProvider(classModel.id));
                    },
                  ),
                ),
              ),
      ),
    );
  }
}

class _TaskListCard extends StatelessWidget {
  final StudentTodoListModel todoList;
  final int classColorIndex;
  final VoidCallback onTap;

  const _TaskListCard({
    required this.todoList,
    required this.classColorIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppTheme.classColors[classColorIndex];
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
                      color: isOverdue
                          ? theme.colorScheme.errorContainer
                          : isComplete
                              ? theme.colorScheme.primaryContainer
                              : palette.bg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isComplete
                          ? Icons.check_circle_rounded
                          : Icons.checklist_rounded,
                      color: isOverdue
                          ? theme.colorScheme.error
                          : isComplete
                              ? theme.colorScheme.primary
                              : palette.fg,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      todoList.title,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
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
                      color: isOverdue
                          ? theme.colorScheme.error
                          : isComplete
                              ? theme.colorScheme.primary
                              : palette.bg,
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
