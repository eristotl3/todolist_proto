import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/class_model.dart';
import '../../domain/todo_list_model.dart';
import '../providers/class_provider.dart';
import '../providers/todo_list_provider.dart';
import '../widgets/completion_matrix_widget.dart';
import '../../../../core/constants/layout_constants.dart';
import '../../../../core/extensions/datetime_extensions.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../shared/widgets/error_retry_widget.dart';
import '../../../../shared/widgets/shimmer_widgets.dart';
import 'create_list_screen.dart';
import 'create_item_screen.dart';

/// Desktop master-detail shell for teachers.
/// Used when screen width > [LayoutConstants.desktopBreakpoint].
class TeacherDesktopShell extends ConsumerStatefulWidget {
  const TeacherDesktopShell({super.key});

  @override
  ConsumerState<TeacherDesktopShell> createState() =>
      _TeacherDesktopShellState();
}

class _TeacherDesktopShellState extends ConsumerState<TeacherDesktopShell>
    with SingleTickerProviderStateMixin {
  ClassModel? _selectedClass;
  TodoListModel? _selectedList;
  late TabController _classTabController;

  @override
  void initState() {
    super.initState();
    _classTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _classTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final classesAsync = ref.watch(classNotifierProvider);

    return Scaffold(
      body: Row(
        children: [
          // ── Sidebar ────────────────────────────────────────────────────────
          Container(
            width: LayoutConstants.sidebarWidth,
            decoration: BoxDecoration(
              border: Border(
                  right: BorderSide(color: theme.colorScheme.outlineVariant)),
              color: theme.colorScheme.surface,
            ),
            child: Column(
              children: [
                _SidebarHeader(
                  onSignOut: () async {
                    final router = GoRouter.of(context);
                    await ref.read(authNotifierProvider.notifier).signOut();
                    router.go('/role-selection');
                  },
                  onCreateClass: () => _createClass(context),
                  onProfile: () => context.push('/profile'),
                ),
                Expanded(
                  child: classesAsync.when(
                    loading: () => ShimmerListView(
                      itemBuilder: () => const ShimmerListTile(),
                    ),
                    error: (e, _) => ErrorRetryWidget(
                      error: e,
                      onRetry: () => ref.invalidate(classNotifierProvider),
                    ),
                    data: (classes) => classes.isEmpty
                        ? _SidebarEmpty(onCreateClass: () => _createClass(context))
                        : ListView.builder(
                            itemCount: classes.length,
                            itemBuilder: (_, i) => _SidebarClassTile(
                              classModel: classes[i],
                              isSelected: _selectedClass?.id == classes[i].id,
                              onTap: () => setState(() {
                                _selectedClass = classes[i];
                                _selectedList = null;
                                _classTabController.index = 0;
                              }),
                              onEdit: () =>
                                  _editClass(context, classes[i]),
                              onDelete: () =>
                                  _deleteClass(context, classes[i]),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),

          // ── Main content ───────────────────────────────────────────────────
          Expanded(
            child: _selectedClass == null
                ? _WelcomePanel()
                : _selectedList == null
                    ? _ClassPanel(
                        classModel: _selectedClass!,
                        tabController: _classTabController,
                        onListTap: (list) =>
                            setState(() => _selectedList = list),
                        onListDeleted: () =>
                            setState(() => _selectedList = null),
                      )
                    : _ListPanel(
                        todoList: _selectedList!,
                        classId: _selectedClass!.id,
                        onBack: () => setState(() => _selectedList = null),
                      ),
          ),
        ],
      ),
    );
  }

  Future<void> _createClass(BuildContext context) async {
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
              border: OutlineInputBorder(),
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
              Navigator.pop(ctx);
              await ref
                  .read(classNotifierProvider.notifier)
                  .createClass(controller.text.trim());
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteClass(BuildContext context, ClassModel c) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Class'),
        content: Text('Delete "${c.name}"? All data will be removed.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
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
      await ref.read(classNotifierProvider.notifier).deleteClass(c.id);
      if (_selectedClass?.id == c.id) {
        setState(() {
          _selectedClass = null;
          _selectedList = null;
        });
      }
    }
  }

  Future<void> _editClass(BuildContext context, ClassModel c) async {
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
            decoration: const InputDecoration(
              labelText: 'Class name',
              border: OutlineInputBorder(),
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
              Navigator.pop(ctx);
              await ref
                  .read(classNotifierProvider.notifier)
                  .editClass(c.id, controller.text.trim());
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

// ── Sidebar pieces ─────────────────────────────────────────────────────────

class _SidebarHeader extends StatelessWidget {
  final Future<void> Function() onSignOut;
  final VoidCallback onCreateClass;
  final VoidCallback onProfile;
  const _SidebarHeader(
      {required this.onSignOut, required this.onCreateClass, required this.onProfile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 12),
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      child: Row(
        children: [
          Icon(Icons.checklist_rounded,
              color: theme.colorScheme.primary, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Text('ClassTask',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            tooltip: 'New class',
            onPressed: onCreateClass,
          ),
          IconButton(
            icon: const Icon(Icons.person_outline_rounded),
            tooltip: 'Profile',
            onPressed: onProfile,
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Sign out',
            onPressed: () async {
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
              if (confirmed == true && context.mounted) await onSignOut();
            },
          ),
        ],
      ),
    );
  }
}

class _SidebarEmpty extends StatelessWidget {
  final VoidCallback onCreateClass;
  const _SidebarEmpty({required this.onCreateClass});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.class_outlined,
                size: 48, color: theme.colorScheme.outline),
            const SizedBox(height: 12),
            Text('No classes yet',
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onCreateClass,
              icon: const Icon(Icons.add),
              label: const Text('Create class'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SidebarClassTile extends StatelessWidget {
  final ClassModel classModel;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _SidebarClassTile({
    required this.classModel,
    required this.isSelected,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      selected: isSelected,
      selectedTileColor: theme.colorScheme.primaryContainer,
      leading: Icon(Icons.class_rounded,
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurfaceVariant),
      title: Text(classModel.name,
          style: TextStyle(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
      subtitle: Text(
          '${classModel.studentCount} students · ${classModel.listCount} lists',
          style: theme.textTheme.labelSmall),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit_outlined,
                size: 16, color: theme.colorScheme.onSurfaceVariant),
            onPressed: onEdit,
            tooltip: 'Rename',
          ),
          IconButton(
            icon: Icon(Icons.delete_outline,
                size: 18, color: theme.colorScheme.error),
            onPressed: onDelete,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}

// ── Main panel pieces ──────────────────────────────────────────────────────

class _WelcomePanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.arrow_back_rounded,
              size: 48, color: theme.colorScheme.outline),
          const SizedBox(height: 16),
          Text('Select a class to get started',
              style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _ClassPanel extends ConsumerWidget {
  final ClassModel classModel;
  final TabController tabController;
  final ValueChanged<TodoListModel> onListTap;
  final VoidCallback onListDeleted;
  const _ClassPanel({
    required this.classModel,
    required this.tabController,
    required this.onListTap,
    required this.onListDeleted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listsAsync = ref.watch(todoListNotifierProvider(classModel.id));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(classModel.name),
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(icon: Icon(Icons.checklist_rounded), text: 'Todo Lists'),
            Tab(icon: Icon(Icons.people_rounded), text: 'Students'),
          ],
        ),
        actions: [
          FilledButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      CreateListScreen(classId: classModel.id)),
            ),
            icon: const Icon(Icons.add),
            label: const Text('New List'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          // Lists tab
          listsAsync.when(
            loading: () =>
                ShimmerListView(itemBuilder: () => const ShimmerListTile()),
            error: (e, _) => ErrorRetryWidget(
              error: e,
              onRetry: () =>
                  ref.invalidate(todoListNotifierProvider(classModel.id)),
            ),
            data: (lists) => lists.isEmpty
                ? Center(
                    child: Text('No lists yet — create one!',
                        style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant)))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: lists.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (_, i) => _DesktopListTile(
                      list: lists[i],
                      onTap: () => onListTap(lists[i]),
                      onEdit: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CreateListScreen(
                            classId: classModel.id,
                            initialList: lists[i],
                          ),
                        ),
                      ),
                      onDelete: () async {
                        await ref
                            .read(todoListNotifierProvider(classModel.id)
                                .notifier)
                            .deleteList(lists[i].id);
                        onListDeleted();
                      },
                    ),
                  ),
          ),
          // Students tab (reuse mobile widget inline)
          _DesktopStudentsPanel(classModel: classModel),
        ],
      ),
    );
  }
}

class _DesktopListTile extends StatelessWidget {
  final TodoListModel list;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _DesktopListTile(
      {required this.list,
      required this.onTap,
      required this.onEdit,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOverdue = list.dueDate != null && list.dueDate!.isOverdue;
    return ListTile(
      leading: Icon(Icons.checklist_rounded,
          color:
              isOverdue ? theme.colorScheme.error : theme.colorScheme.primary),
      title: Text(list.title),
      subtitle: Text(
          '${list.itemCount} items${list.dueDate != null ? ' · Due ${list.dueDate!.toDisplayDate()}' : ''}',
          style: TextStyle(color: isOverdue ? theme.colorScheme.error : null)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit_outlined,
                size: 18, color: theme.colorScheme.onSurfaceVariant),
            onPressed: onEdit,
            tooltip: 'Edit',
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
            onPressed: onDelete,
          ),
        ],
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}

class _DesktopStudentsPanel extends ConsumerWidget {
  final ClassModel classModel;
  const _DesktopStudentsPanel({required this.classModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Reuses the same data the mobile class detail screen uses
    // (classCode and students providers from class_detail_screen.dart)
    return Center(
      child: Text(
        'Students panel — join code: ${classModel.code}',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

class _ListPanel extends ConsumerStatefulWidget {
  final TodoListModel todoList;
  final String classId;
  final VoidCallback onBack;
  const _ListPanel(
      {required this.todoList, required this.classId, required this.onBack});

  @override
  ConsumerState<_ListPanel> createState() => _ListPanelState();
}

class _ListPanelState extends ConsumerState<_ListPanel>
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
    final itemsAsync =
        ref.watch(todoItemNotifierProvider(widget.todoList.id));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: widget.onBack,
        ),
        title: Text(widget.todoList.title),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.checklist_rounded), text: 'Items'),
            Tab(icon: Icon(Icons.grid_view_rounded), text: 'Progress'),
          ],
        ),
        actions: [
          if (_tabController.index == 0)
            FilledButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        CreateItemScreen(listId: widget.todoList.id)),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Add Item'),
            ),
          const SizedBox(width: 16),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          itemsAsync.when(
            loading: () =>
                ShimmerListView(itemBuilder: () => const ShimmerListTile()),
            error: (e, _) => ErrorRetryWidget(
              error: e,
              onRetry: () =>
                  ref.invalidate(todoItemNotifierProvider(widget.todoList.id)),
            ),
            data: (items) => items.isEmpty
                ? const Center(child: Text('No items yet — add one!'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    itemBuilder: (_, i) => ListTile(
                      leading: const Icon(Icons.drag_indicator_rounded),
                      title: Text(items[i].title),
                      subtitle: items[i].dueDate != null
                          ? Text('Due ${items[i].dueDate!.toDisplayDate()}')
                          : null,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit_outlined,
                                size: 18,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant),
                            tooltip: 'Edit',
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CreateItemScreen(
                                  listId: widget.todoList.id,
                                  initialItem: items[i],
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            color: Theme.of(context).colorScheme.error,
                            onPressed: () => ref
                                .read(todoItemNotifierProvider(
                                        widget.todoList.id)
                                    .notifier)
                                .deleteItem(items[i].id),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
          CompletionMatrixWidget(
            listId: widget.todoList.id,
            classId: widget.classId,
          ),
        ],
      ),
    );
  }
}
