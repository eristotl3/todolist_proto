import 'package:flutter/material.dart';

class ErrorRetryWidget extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry;
  final String? label;

  const ErrorRetryWidget({
    super.key,
    required this.error,
    this.onRetry,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final message = _humanize(error);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded,
                size: 56, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              label ?? 'Something went wrong',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try again'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _humanize(Object error) {
    final raw = error.toString();
    // Strip internal exception prefixes for cleaner display
    if (raw.startsWith('AppException: ')) return raw.substring(14);
    if (raw.startsWith('Exception: ')) return raw.substring(11);
    return raw;
  }
}
