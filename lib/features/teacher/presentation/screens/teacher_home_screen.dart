import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/layout_constants.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/class_provider.dart';
import '../../domain/class_model.dart';
import 'teacher_shell.dart';
import '../../../../shared/widgets/error_retry_widget.dart';
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

// ── Mobile layout (unchanged behaviour) ──────────────────────────────────────

class _TeacherMobileHome extends ConsumerWidget {
  const _TeacherMobileHome();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(authNotifierProvider).valueOrNull;
    final classesAsync = ref.watch(classNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Classes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () => _confirmSignOut(context, ref),
          ),
        ],
      ),
      body: classesAsync.when(
        loading: () => ShimmerListView(
          itemBuilder: () => const ShimmerClassCard(),
        ),
        error: (e, _) => ErrorRetryWidget(
          error: e,
          onRetry: () => ref.invalidate(classNotifierProvider),
        ),
        data: (classes) => classes.isEmpty
            ? _EmptyState(name: profile?.fullName ?? '')
            : RefreshIndicator(
                onRefresh: () =>
                    ref.read(classNotifierProvider.notifier).refresh(),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: classes.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (_, i) => _ClassCard(
                    classModel: classes[i],
                    onTap: () => context.push(
                      '/teacher/home/class/${classes[i].id}',
                      extra: classes[i],
                    ),
                    onDelete: () => _confirmDelete(context, ref, classes[i]),
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('New Class'),
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
                backgroundColor: Theme.of(context).colorScheme.error),
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
  if (confirmed == true && context.mounted) {
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
            Icon(Icons.class_outlined,
                size: 72, color: theme.colorScheme.outline),
            const SizedBox(height: 16),
            Text('Welcome, $name!',
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text('Create your first class to get started.',
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _ClassCard extends StatelessWidget {
  final ClassModel classModel;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ClassCard({
    required this.classModel,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
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
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.class_rounded,
                    color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(classModel.name,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.people_outline,
                            size: 14,
                            color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text('${classModel.studentCount} students',
                            style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant)),
                        const SizedBox(width: 12),
                        Icon(Icons.checklist_rounded,
                            size: 14,
                            color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text('${classModel.listCount} lists',
                            style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Code: ${classModel.code}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
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
