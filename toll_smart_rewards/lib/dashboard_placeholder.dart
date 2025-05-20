import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DashboardPlaceholder extends StatelessWidget {
  const DashboardPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Shimmer.fromColors(
          baseColor: Colors.deepPurple.shade800,
          highlightColor: Colors.deepPurple.shade400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(4, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(16),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
