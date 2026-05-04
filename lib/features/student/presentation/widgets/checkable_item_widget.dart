import 'package:flutter/material.dart';
import '../../domain/student_item_state.dart';
import '../../../../core/extensions/datetime_extensions.dart';

class CheckableItemWidget extends StatelessWidget {
  final StudentItemState itemState;
  final VoidCallback onToggle;

  const CheckableItemWidget({
    super.key,
    required this.itemState,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final item = itemState.item;
    final isCompleted = itemState.isCompleted;
    final isOverdue = item.dueDate != null && item.dueDate!.isOverdue && !isCompleted;

    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isCompleted
              ? theme.colorScheme.surfaceContainerHighest
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isOverdue
                ? theme.colorScheme.error.withValues(alpha: 0.4)
                : isCompleted
                    ? theme.colorScheme.outlineVariant.withValues(alpha: 0.4)
                    : theme.colorScheme.outlineVariant,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted
                    ? theme.colorScheme.primary
                    : Colors.transparent,
                border: Border.all(
                  color: isCompleted
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: isCompleted
                  ? Icon(Icons.check_rounded,
                      size: 16, color: theme.colorScheme.onPrimary)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      decoration:
                          isCompleted ? TextDecoration.lineThrough : null,
                      color: isCompleted
                          ? theme.colorScheme.onSurfaceVariant
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  if (item.description != null &&
                      item.description!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      item.description!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        decoration:
                            isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ],
                  if (item.dueDate != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 12,
                          color: isOverdue
                              ? theme.colorScheme.error
                              : theme.colorScheme.onSurfaceVariant,
                        ),
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
