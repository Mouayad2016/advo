import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget shimmerWidget(child) {
  return Shimmer(
      enabled: true,
      gradient: LinearGradient(
        colors: [
          Colors.grey[700]!,
          Colors.grey[200]!,
          Colors.grey[300]!,
        ],
        stops: const [
          0.0,
          0.5,
          1.0,
        ],
        begin: const Alignment(-1.0, -0.5),
        end: const Alignment(1.0, 0.5),
      ),
      child: child);
}
