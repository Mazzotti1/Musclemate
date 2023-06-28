
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class WeightProgressChart extends StatefulWidget {
   final List<double> pesos;
   final List<String> dataTreino;

  const WeightProgressChart({
    Key? key,
    required this.pesos,
    required this.dataTreino
  }) : super(key: key);

  @override
  State<WeightProgressChart> createState() => _WeightProgressChartState();
}

class _WeightProgressChartState extends State<WeightProgressChart> {

  bool showAvg = false;

 @override
  Widget build(BuildContext context) {
     if (widget.pesos.isEmpty || widget.dataTreino.isEmpty) {
    return const Center(
      child: Text(
        'Ainda não há dados suficientes.',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.30,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 30,
              left: 12,
              top: 0,
              bottom: 0,
            ),
            child: LineChart(
               mainData(),
            ),
          ),
        ),
        SizedBox(
          width: 60,
          height: 34,
          child: TextButton(
            onPressed: () {
              setState(() {
                showAvg = !showAvg;
              });
            },
            child: Text(
              'avg',
              style: TextStyle(
                fontSize: 12,
                color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }



  LineChartData mainData() {
  if (widget.pesos.length >= 6) {
    final List<double> groupedPesos = [];
    final List<double> groupedXValues = [];
    final int groupSize = 6;
    final int numGroups = widget.pesos.length ~/ groupSize;

    for (int i = 0; i < numGroups; i++) {
      final List<double> group = widget.pesos.sublist(i * groupSize, (i + 1) * groupSize);
      final double avgPeso = group.reduce((sum, peso) => sum + peso) / groupSize;
      final double x = i.toDouble();
      groupedPesos.add(avgPeso);
      groupedXValues.add(x);
    }

    final double maxPeso = groupedPesos.reduce((max, peso) => max > peso ? max : peso);
    final double minPeso = groupedPesos.reduce((min, peso) => min < peso ? min : peso);
    final double maxY = maxPeso.ceilToDouble();
    final double minY = minPeso.floorToDouble();

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        drawHorizontalLine: false,
        verticalInterval: 1,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.black38,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(

        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),

      ),

      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color(0xff37434d)),
          left: BorderSide(color: Color(0xff37434d)),
        ),
      ),

      minX: 0,
      maxX: groupedXValues.length - 1,
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(groupedXValues.length, (index) {
            final double peso = groupedPesos[index];
            final double x = groupedXValues[index];
            return FlSpot(x, peso);
          }),
          isCurved: false,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.black,
        getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
          final List<String> tooltips = [];

          for (final barSpot in touchedBarSpots) {
            final int index = barSpot.x.toInt();
            final double peso = barSpot.y;
            final String formattedPeso = 'Média: ${peso.toStringAsFixed(1)}Kg';

              final int groupIndex = index ~/ 6;
              final int startIndex = groupIndex * 6;
              final int endIndex = startIndex + 5;

              final DateTime startDate = DateFormat('dd/MM/yyyy').parse(widget.dataTreino[startIndex]);
                final DateTime endDate = DateFormat('dd/MM/yyyy').parse(widget.dataTreino[endIndex]);

                final String formattedStartDay = DateFormat('d').format(startDate);
                final String formattedStartMonth= DateFormat.MMM().format(startDate);

                final String formattedEndDay= DateFormat('d').format(endDate);
                final String formattedEndMonth = DateFormat.MMM().format(endDate);

                final String groupedDate = '$formattedStartDay de $formattedStartMonth a $formattedEndDay de $formattedEndMonth';

              tooltips.add('$groupedDate\n$formattedPeso');

          }

          return tooltips.map((tooltip) {
            return LineTooltipItem(
              tooltip,
              TextStyle(color: Colors.white, fontSize: 12),
            );
          }).toList();
        },

        ),
      ),
    );
  } else {
    final double maxPeso = widget.pesos.reduce((max, peso) => max > peso ? max : peso);
    final double minPeso = widget.pesos.reduce((min, peso) => min < peso ? min : peso);
    final double maxY = maxPeso.ceilToDouble();
    final double minY = minPeso.floorToDouble();

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        drawHorizontalLine: false,
        verticalInterval: 1,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.black38,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color(0xff37434d)),
          left: BorderSide(color: Color(0xff37434d)),
        ),
      ),
      minX: 0,
      maxX: widget.pesos.length - 1,
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(widget.pesos.length, (index) {
            final double peso = widget.pesos[index];
            final double x = index.toDouble();
            return FlSpot(x, peso);
          }),
          isCurved: false,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blue,
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final int index = barSpot.x.toInt();
              final double peso = barSpot.y;
              final String date = widget.dataTreino[index];
              final String formattedPeso = '${peso.toStringAsFixed(1)}Kg';
              final List<String> dateParts = date.split('/');
              final String formattedDate = '${dateParts[0]}/${dateParts[1]}';

              return LineTooltipItem(
                '$formattedDate\n$formattedPeso',
                TextStyle(color: Colors.white, fontSize: 12),
              );
            }).toList();
          },
        ),
      ),
    );
  }
}
}
