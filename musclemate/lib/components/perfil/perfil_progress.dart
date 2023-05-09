
import 'package:flutter/material.dart';
import 'package:musclemate/components/charts/weight_progress_chart.dart';


class PerfilProgress extends StatelessWidget {
  const PerfilProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      color: Colors.white,
      child: const LineChartWithGrid(),
    );
  }
}