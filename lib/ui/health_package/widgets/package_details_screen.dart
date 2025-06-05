import 'package:flutter/material.dart';

import 'package:voice_interaction/domain/models/health_package.dart';

class PackageDetailsScreen extends StatefulWidget {
  final HealthPackage data;

  const PackageDetailsScreen({
    super.key,
    required this.data,
  });

  @override
  State<PackageDetailsScreen> createState() => _PackageDetailsScreenState();
}

class _PackageDetailsScreenState extends State<PackageDetailsScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  Widget _buildGrid(List<String> items, {IconData icon = Icons.check_circle, Color iconColor = Colors.green}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = (constraints.maxWidth / 200).floor().clamp(2, 4);
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 0,
              color: Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Icon(icon, size: 16, color: iconColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        items[index],
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
      child: Container(
        color: Colors.black.withValues(alpha: 0.7),
        child: Stack(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(24),
                constraints: const BoxConstraints(maxWidth: 800),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.data.package,
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.data.description,
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Price: ₹${widget.data.price.replaceAll(" Rupees", "")}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      if (widget.data.tests.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Tests Included:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        _buildGrid(widget.data.tests),
                      ],
                      if (widget.data.consultations.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Consultations Included:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        _buildGrid(
                          widget.data.consultations,
                          icon: Icons.medical_services,
                          iconColor: Colors.blue,
                        ),
                      ],
                      const SizedBox(height: 60), // Extra space for floating button
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: 40,
              bottom: 40,
              child: FloatingActionButton(
                onPressed: () {},
                child: const Text("Done"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
