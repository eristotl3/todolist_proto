import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/class_model.dart';
import '../../domain/todo_list_model.dart';
import '../../data/class_repository.dart';
import '../providers/todo_list_provider.dart';
import '../../../../core/extensions/datetime_extensions.dart';
import 'create_list_screen.dart';
import 'todo_list_screen.dart';

part 'class_detail_screen.g.dart';

class ClassDetailScreen extends ConsumerStatefulWidget {
  final ClassModel classModel;
  const ClassDetailScreen({super.key, required this.classModel});

  @override
  ConsumerState<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends ConsumerState<ClassDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.classModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(c.name),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.checklist_rounded), text: 'Todo Lists'),
            Tab(icon: Icon(Icons.people_rounded), text: 'Students'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _TodoListsTab(classModel: c),
          _StudentsTab(classId: c.id),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: () => _openCreateList(context, c.id),
              icon: const Icon(Icons.add),
              label: const Text('New List'),
            )
          : null,
    );
  }

  Future<void> _openCreateList(BuildContext context, String classId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => CreateListScreen(classId: classId)),
    );
  }
}

// ── Todo Lists tab ────────────────────────────────────────────────────────────

class _TodoListsTab extends ConsumerWidget {
  final ClassModel classModel;
  const _TodoListsTab({required this.classModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listsAsync = ref.watch(todoListNotifierProvider(classModel.id));
    final theme = Theme.of(context);

    return listsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (lists) => lists.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.checklist_rounded,
                        size: 64, color: theme.colorScheme.outline),
                    const SizedBox(height: 16),
                    Text('No lists yet', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text('Tap "New List" to create the first todo list.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant),
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: () => ref
                  .read(todoListNotifierProvider(classModel.id).notifier)
                  .refresh(),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: lists.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, i) => _ListCard(
                  todoList: lists[i],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => TodoListScreen(todoList: lists[i])),
                  ),
                  onDelete: () => _confirmDelete(context, ref, lists[i]),
                ),
              ),
            ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, TodoListModel list) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete List'),
        content: Text('Delete "${list.title}"? All items will be removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref
          .read(todoListNotifierProvider(classModel.id).notifier)
          .deleteList(list.id);
    }
  }
}

class _ListCard extends StatelessWidget {
  final TodoListModel todoList;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ListCard({
    required this.todoList,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOverdue =
        todoList.dueDate != null && todoList.dueDate!.isOverdue;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isOverdue
              ? theme.colorScheme.error.withValues(alpha: 0.5)
              : theme.colorScheme.outlineVariant,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isOverdue
                      ? theme.colorScheme.errorContainer
                      : theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.checklist_rounded,
                  color: isOverdue
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(todoList.title,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.task_alt_rounded,
                            size: 14,
                            color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text('${todoList.itemCount} items',
                            style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant)),
                        if (todoList.dueDate != null) ...[
                          const SizedBox(width: 12),
                          Icon(Icons.calendar_today_rounded,
                              size: 14,
                              color: isOverdue
                                  ? theme.colorScheme.error
                                  : theme.colorScheme.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text(
                            todoList.dueDate!.toDisplayDate(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isOverdue
                                  ? theme.colorScheme.error
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline,
                    color: theme.colorScheme.error),
                onPressed: onDelete,
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Students tab ──────────────────────────────────────────────────────────────

class _StudentsTab extends ConsumerWidget {
  final String classId;
  const _StudentsTab({required this.classId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentsAsync = ref.watch(studentsProvider(classId));
    final theme = Theme.of(context);

    return studentsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (students) => Column(
        children: [
          _JoinCodeBanner(classId: classId),
          Expanded(
            child: students.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people_outline,
                              size: 64, color: theme.colorScheme.outline),
                          const SizedBox(height: 16),
                          Text('No students yet',
                              style: theme.textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text(
                            'Share the class code with your students so they can join.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: students.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final profile =
                          students[i]['profiles'] as Map<String, dynamic>;
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            (profile['full_name'] as String? ?? '?')
                                .substring(0, 1)
                                .toUpperCase(),
                          ),
                        ),
                        title: Text(profile['full_name'] as String? ?? ''),
                        subtitle: Text(profile['email'] as String? ?? ''),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _JoinCodeBanner extends ConsumerWidget {
  final String classId;
  const _JoinCodeBanner({required this.classId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classAsync = ref.watch(classCodeProvider(classId));
    final theme = Theme.of(context);

    return classAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (e, st) => const SizedBox.shrink(),
      data: (code) => Container(
        width: double.infinity,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.key_rounded, color: theme.colorScheme.secondary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Class join code',
                      style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSecondaryContainer)),
                  Text(
                    code,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy_rounded),
              color: theme.colorScheme.secondary,
              tooltip: 'Copy code',
              onPressed: () {
                Clipboard.setData(ClipboardData(text: code));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Code copied to clipboard')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

@riverpod
Future<List<Map<String, dynamic>>> students(Ref ref, String classId) =>
    ref.read(classRepositoryProvider).getEnrolledStudents(classId);

@riverpod
Future<String> classCode(Ref ref, String classId) async {
  final data = await Supabase.instance.client
      .from('classes')
      .select('code')
      .eq('id', classId)
      .single();
  return data['code'] as String;
}
