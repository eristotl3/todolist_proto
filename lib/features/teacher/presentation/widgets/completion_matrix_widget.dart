import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/completion_matrix_state.dart';
import '../providers/completion_provider.dart';

class CompletionMatrixWidget extends ConsumerWidget {
  final String listId;
  final String classId;

  const CompletionMatrixWidget({
    super.key,
    required this.listId,
    required this.classId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matrixAsync =
        ref.watch(completionMatrixNotifierProvider(listId, classId));

    return matrixAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text('Could not load completions: $e',
            textAlign: TextAlign.center),
      ),
      data: (matrix) {
        if (matrix.students.isEmpty) {
          return _EmptyMatrix();
        }
        if (matrix.items.isEmpty) {
          return _EmptyMatrix(message: 'Add items to see student progress.');
        }
        return _MatrixTable(matrix: matrix);
      },
    );
  }
}

class _EmptyMatrix extends StatelessWidget {
  final String message;
  const _EmptyMatrix(
      {this.message = 'No students enrolled yet.'});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.grid_view_rounded,
                size: 48, color: theme.colorScheme.outline),
            const SizedBox(height: 12),
            Text(message,
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _MatrixTable extends StatelessWidget {
  final CompletionMatrixState matrix;
  const _MatrixTable({required this.matrix});

  static const double _rowHeight = 52;
  static const double _nameColWidth = 140;
  static const double _cellWidth = 56;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            'Student Progress',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _buildTable(context, theme),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTable(BuildContext context, ThemeData theme) {
    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: item titles
          _HeaderRow(matrix: matrix, nameColWidth: _nameColWidth, cellWidth: _cellWidth),
          const Divider(height: 1),
          // Data rows: one per student
          ...matrix.students.map((student) => Column(
            children: [
              _StudentRow(
                student: student,
                matrix: matrix,
                nameColWidth: _nameColWidth,
                cellWidth: _cellWidth,
                rowHeight: _rowHeight,
              ),
              const Divider(height: 1),
            ],
          )),
        ],
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  final CompletionMatrixState matrix;
  final double nameColWidth;
  final double cellWidth;

  const _HeaderRow({
    required this.matrix,
    required this.nameColWidth,
    required this.cellWidth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Row(
        children: [
          SizedBox(
            width: nameColWidth,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text('Student',
                  style: theme.textTheme.labelMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ),
          ),
          ...matrix.items.map((item) => SizedBox(
                width: cellWidth,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                  child: Column(
                    children: [
                      Text(
                        item.title,
                        style: theme.textTheme.labelSmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${matrix.itemCompletionCount(item.id)}/${matrix.students.length}',
                        style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class _StudentRow extends StatelessWidget {
  final StudentSummary student;
  final CompletionMatrixState matrix;
  final double nameColWidth;
  final double cellWidth;
  final double rowHeight;

  const _StudentRow({
    required this.student,
    required this.matrix,
    required this.nameColWidth,
    required this.cellWidth,
    required this.rowHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final doneCount = matrix.studentCompletionCount(student.id);
    final totalCount = matrix.items.length;
    final allDone = doneCount == totalCount && totalCount > 0;

    return SizedBox(
      height: rowHeight,
      child: Row(
        children: [
          SizedBox(
            width: nameColWidth,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: allDone
                        ? theme.colorScheme.primaryContainer
                        : theme.colorScheme.surfaceContainerHighest,
                    child: Text(
                      student.fullName.isNotEmpty
                          ? student.fullName[0].toUpperCase()
                          : '?',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: allDone
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.fullName,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '$doneCount/$totalCount',
                          style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ...matrix.items.map((item) {
            final done = matrix.isCompleted(item.id, student.id);
            return SizedBox(
              width: cellWidth,
              height: rowHeight,
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: done
                      ? Icon(
                          Icons.check_circle_rounded,
                          key: const ValueKey(true),
                          color: theme.colorScheme.primary,
                          size: 22,
                        )
                      : Icon(
                          Icons.radio_button_unchecked_rounded,
                          key: const ValueKey(false),
                          color: theme.colorScheme.outlineVariant,
                          size: 22,
                        ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
