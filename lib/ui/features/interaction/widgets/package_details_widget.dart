import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:voice_interaction/ui/core/details_container.dart';
import 'package:voice_interaction/ui/core/scroll_with_indicator.dart';

import 'package:voice_interaction/ui/models/grid.dart';
import 'package:voice_interaction/ui/models/package_detials.dart';

class PackageDetailsWidget extends StatefulWidget {
  final PackageDetials package;
  final VoidCallback? onDone;

  const PackageDetailsWidget({super.key, required this.package, this.onDone});

  @override
  State<PackageDetailsWidget> createState() => _PackageDetailsWidgetState();
}

class _PackageDetailsWidgetState extends State<PackageDetailsWidget> {
  Widget _buildGrid(Grid grid, {required Color itemBackgroundColor}) {
    const crossAxisCount = 5;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: grid.items.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 0,
          color: itemBackgroundColor,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14.0,
                vertical: 5.0,
              ),
              child: Text(
                grid.items[index],
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DetailsContainer(
      onClose: widget.onDone,
      child: ScrollWithIndicator(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.package.heading,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const Gap(8),
            Text(
              widget.package.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Gap(16),
            Text(
              'Price: ₹${widget.package.price.replaceAll(" Rupees", "")}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            if (widget.package.tests.isNotEmpty) ...[
              const Gap(32),
              Text(
                widget.package.tests.heading,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              _buildGrid(widget.package.tests, itemBackgroundColor: Colors.green),
            ],
            if (widget.package.consultations.isNotEmpty) ...[
              const Gap(32),
              Text(
                widget.package.consultations.heading,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              _buildGrid(
                widget.package.consultations,
                itemBackgroundColor: Colors.blue,
              ),
            ], // Extra space for floating button
          ],
        ),
      ),
    );
  }
}
