import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../domain/todo_list_model.dart';
import '../../domain/todo_item_model.dart';
import '../providers/todo_list_provider.dart';
import '../widgets/completion_matrix_widget.dart';
import '../../../../core/extensions/datetime_extensions.dart';
import '../../../../shared/widgets/error_retry_widget.dart';
import '../../../../shared/widgets/shimmer_widgets.dart';
import 'create_item_screen.dart';

class TodoListScreen extends ConsumerStatefulWidget {
  final TodoListModel todoList;
  final String classId;

  const TodoListScreen({
    super.key,
    required this.todoList,
    required this.classId,
  });

  @override
  ConsumerState<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends ConsumerState<TodoListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todoList = widget.todoList;

    return Scaffold(
      appBar: AppBar(
        title: Text(todoList.title),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.checklist_rounded), text: 'Items'),
            Tab(icon: Icon(Icons.grid_view_rounded), text: 'Progress'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ItemsTab(todoList: todoList),
          CompletionMatrixWidget(
            listId: todoList.id,
            classId: widget.classId,
          ),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        CreateItemScreen(listId: todoList.id)),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Add Item'),
            )
          : null,
    );
  }
}

// ── Items tab ─────────────────────────────────────────────────────────────────

class _ItemsTab extends ConsumerWidget {
  final TodoListModel todoList;
  const _ItemsTab({required this.todoList});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync =
        ref.watch(todoItemNotifierProvider(todoList.id));
    final theme = Theme.of(context);

    return itemsAsync.when(
      loading: () =>
          ShimmerListView(itemBuilder: () => const ShimmerListTile()),
      error: (e, _) => ErrorRetryWidget(
        error: e,
        onRetry: () =>
            ref.invalidate(todoItemNotifierProvider(todoList.id)),
      ),
      data: (items) => items.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.checklist_rounded,
                        size: 64, color: theme.colorScheme.outline),
                    const SizedBox(height: 16),
                    Text('No items yet',
                        style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text('Tap "Add Item" to create the first task.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant),
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: () => ref
                  .read(todoItemNotifierProvider(todoList.id).notifier)
                  .refresh(),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 8),
                itemBuilder: (context, i) => _ItemTile(
                  item: items[i],
                  onEdit: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreateItemScreen(
                        listId: todoList.id,
                        initialItem: items[i],
                      ),
                    ),
                  ),
                  onDelete: () =>
                      _confirmDelete(context, ref, items[i], todoList.id),
                ),
              ),
            ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref,
      TodoItemModel item, String listId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Remove "${item.title}"?'),
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
          .read(todoItemNotifierProvider(listId).notifier)
          .deleteItem(item.id);
    }
  }
}

class _ItemTile extends StatelessWidget {
  final TodoItemModel item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ItemTile({required this.item, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOverdue = item.dueDate?.isOverdue ?? false;

    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onEdit(),
            backgroundColor: theme.colorScheme.secondary,
            foregroundColor: theme.colorScheme.onSecondary,
            icon: Icons.edit_rounded,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (_) => onDelete(),
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
            icon: Icons.delete_rounded,
            label: 'Delete',
            borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(12)),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isOverdue
                ? theme.colorScheme.error.withValues(alpha: 0.4)
                : theme.colorScheme.outlineVariant,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.drag_indicator_rounded,
                color: theme.colorScheme.outlineVariant),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w500)),
                  if (item.description != null &&
                      item.description!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(item.description!,
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant)),
                  ],
                  if (item.dueDate != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_rounded,
                            size: 12,
                            color: isOverdue
                                ? theme.colorScheme.error
                                : theme.colorScheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(
                          item.dueDate!.toDisplayDate(),
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
          ],
        ),
      ),
    );
  }
}
