import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';

class LineChartWithGrid extends StatelessWidget {
  const LineChartWithGrid({super.key});

Widget chartToRun() {
  LabelLayoutStrategy? xContainerLabelLayoutStrategy;
  ChartData chartData;
  ChartOptions chartOptions = const ChartOptions();
  chartOptions = const ChartOptions(
  dataContainerOptions: DataContainerOptions(
  yTransform: log10,
  yInverseTransform: inverseLog10,
  ),
  );
  chartData = ChartData(
  dataRows: const [
  [10.0, 600.0, 1000000.0,10.0, 600.0, 1000000.0,10.0, 600.0, 1000000.0,10.0, 600.0, 1000000.0,],
  [20.0, 1000.0, 1500000.0,10.0, 600.0, 1000000.0,10.0, 600.0, 1000000.0,10.0, 600.0, 1000000.0,],
  ],
  xUserLabels: const ['Jan', 'Fev', 'Mar', 'abril ', 'Mai ', 'Jun', 'Jul' ,'Ago', 'Set' ,'Out', 'Nov', 'Dez'],
  dataRowsLegends: const [
  'Spring',
  'Summer',
  ],
  chartOptions: chartOptions,
  );
  var lineChartContainer = LineChartTopContainer(
    chartData: chartData,
    xContainerLabelLayoutStrategy: xContainerLabelLayoutStrategy,
  );

  var lineChart = LineChart(
    painter: LineChartPainter(
      lineChartContainer: lineChartContainer,
    ),
  );
  return lineChart;
}
  @override
  Widget build(BuildContext context) {
      return chartToRun();
  }
}