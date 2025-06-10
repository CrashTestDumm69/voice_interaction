import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:voice_interaction/ui/core/details_container.dart';

import 'package:voice_interaction/ui/models/department_details.dart';

import 'package:voice_interaction/ui/models/grid.dart';

class DepartmentDetailsWidget extends StatefulWidget {
  final DepartmentDetails department;
  final VoidCallback? onDone;

  const DepartmentDetailsWidget({
    super.key,
    required this.department,
    this.onDone
  });

  @override
  State<DepartmentDetailsWidget> createState() => _DepartmentDetailsWidgetState();
}

class _DepartmentDetailsWidgetState extends State<DepartmentDetailsWidget> {
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
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Text(
                grid.items[index],
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.department.heading, style: Theme.of(context).textTheme.displayMedium),
          const Gap(8),
          Text(widget.department.description, style: Theme.of(context).textTheme.bodyLarge),
          const Gap(16),
          if (widget.department.doctors.isNotEmpty) ...[
            const Gap(32),
            Text(widget.department.doctors.heading, style: Theme.of(context).textTheme.headlineMedium),
            _buildGrid(
              widget.department.doctors,
              itemBackgroundColor: Colors.green,
            ),
          ],
        ],
      ),
    );
  }
}