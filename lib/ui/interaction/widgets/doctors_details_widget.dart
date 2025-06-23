import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:voice_interaction/ui/core/details_container.dart';
import 'package:voice_interaction/ui/core/scroll_with_indicator.dart';
import 'package:voice_interaction/ui/models/doctors_details.dart';
import 'package:voice_interaction/ui/models/grid.dart';

class DoctorsDetailsWidget extends StatefulWidget {
  final DoctorsDetails doctors;
  final VoidCallback? onDone;

  const DoctorsDetailsWidget({
    super.key,
    required this.doctors,
    this.onDone
  });

  @override
  State<DoctorsDetailsWidget> createState() => _DoctorsDetailsWidgetState();
}

class _DoctorsDetailsWidgetState extends State<DoctorsDetailsWidget> {
  Widget _buildGrid(Grid grid, {required Color itemBackgroundColor}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Column(
          children: grid.items.map((item) {
            // Split each item by colon to get name and department
            final parts = item.split(':');
            final fullName = parts.isNotEmpty ? parts[0].trim() : '';
            final department = parts.length > 1 ? parts[1].trim() : '';
            
            // Remove "Dr. " prefix for avatar initial
            final nameForAvatar = fullName.startsWith('Dr. ') ? fullName.substring(4) : fullName;
            
            return Card(
              margin: EdgeInsets.symmetric(vertical: 16.0),
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: Text(
                        nameForAvatar.isNotEmpty ? nameForAvatar[0] : '',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    Gap(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            fullName,
                            style: TextStyle(color: Colors.white, fontSize: 30),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            department,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
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
            Text(widget.doctors.heading, style: Theme.of(context).textTheme.displayMedium),
            const Gap(8),
            Text(widget.doctors.items.heading, style: Theme.of(context).textTheme.bodyLarge),
            if (widget.doctors.items.isNotEmpty) ...[
              _buildGrid(
                widget.doctors.items,
                itemBackgroundColor: Colors.green,
              ),
            ],
          ],
        ),
      )
    );
  }
}