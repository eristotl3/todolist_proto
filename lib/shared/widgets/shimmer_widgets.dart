import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerClassCard extends StatelessWidget {
  const ShimmerClassCard({super.key});

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceContainerHighest;
    final highlight = Theme.of(context).colorScheme.surfaceContainerHigh;
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: base,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: 140, height: 16,
                        decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(4))),
                    const SizedBox(height: 8),
                    Container(
                        width: 100, height: 12,
                        decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(4))),
                    const SizedBox(height: 8),
                    Container(
                        width: 80, height: 20,
                        decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(6))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShimmerListTile extends StatelessWidget {
  const ShimmerListTile({super.key});

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceContainerHighest;
    final highlight = Theme.of(context).colorScheme.surfaceContainerHigh;
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: base,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        title: Container(
          width: double.infinity,
          height: 14,
          decoration: BoxDecoration(
            color: base,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        subtitle: Container(
          width: 120,
          height: 12,
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            color: base,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

class ShimmerListView extends StatelessWidget {
  final int itemCount;
  final Widget Function() itemBuilder;

  const ShimmerListView({
    super.key,
    this.itemCount = 4,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => itemBuilder(),
    );
  }
}
