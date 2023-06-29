
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
      ],
    );
  }

// Widget bottomTitleWidgets(double value, TitleMeta meta) {
//   final style = TextStyle(
//     fontWeight: FontWeight.bold,
//     fontSize: 10,
//   );

//   final dateFormatter = DateFormat('dd/MM/yy');
//   final monthAbbreviationFormatter = DateFormat('MMM');

//   final formattedDates = widget.dataTreino.map((dateString) {
//     final date = dateFormatter.parse(dateString);
//     return monthAbbreviationFormatter.format(date);
//   }).toList();

//   if (formattedDates.length < 6) {
//     // Retorne um título vazio ou alternativo se não houver dados suficientes.
//     return Container();
//   }

//   final groupSize = 6;
//   final firstGroupDates = formattedDates.sublist(0, groupSize);

//   final mostFrequentMonth = _getMostFrequentMonth(firstGroupDates);

//   final text = Text(mostFrequentMonth, style: style);

//   return SideTitleWidget(
//     axisSide: meta.axisSide,
//     child: text,
//   );
// }

// String _getMostFrequentMonth(List<String> dates) {
//   final counts = <String, int>{};
//   String mostFrequentMonth = '';

//   for (final date in dates) {
//     counts[date] = (counts[date] ?? 0) + 1;
//     if (mostFrequentMonth.isEmpty || counts[date]! > counts[mostFrequentMonth]!) {
//       mostFrequentMonth = date;
//     }
//   }

//   return mostFrequentMonth;
// }



 LineChartData mainData() {

  if (widget.pesos.length >= 6) {
    final List<double> groupedPesos = [];
    final List<double> groupedXValues = [];
    final List<String> groupedDates = [];

    final int groupSize = 6;
    final int numGroups = widget.pesos.length ~/ groupSize;

    for (int i = 0; i < numGroups; i++) {
      final List<double> group = widget.pesos.sublist(i * groupSize, (i + 1) * groupSize);
      final double avgPeso = group.reduce((sum, peso) => sum + peso) / groupSize;
      // aqui esta rolando a definição do que fica escrito nos elementos do X
      //usar de formatação do widget.dataTreino [i * groupSize ] pra tentar resolver
      final double dates = i.toDouble();
      groupedPesos.add(avgPeso);
      groupedXValues.add(dates);

      final String startDate = widget.dataTreino[i * groupSize]; // Data inicial do grupo
      final String endDate = widget.dataTreino[(i + 1) * groupSize - 1]; // Data final do grupo
      groupedDates.add('$startDate a $endDate'); // Adiciona a data inicial e final ao formato desejado
    }

    final int maxLinesX = 8;
    final int numLinesX = numGroups < maxLinesX ? maxLinesX : numGroups;

    final double maxPeso = groupedPesos.reduce((max, peso) => max > peso ? max : peso);
    final double minPeso = groupedPesos.reduce((min, peso) => min < peso ? min : peso);
    final double maxY = maxPeso.ceilToDouble() + 1;
    final double minY = minPeso.floorToDouble();

    final List<double> verticalValues = [1, 2, 3, 4, 5];

    return LineChartData(
       gridData: FlGridData(
    show: true,
    drawVerticalLine: true,
    drawHorizontalLine: false,
    verticalInterval: 1,
    getDrawingVerticalLine: (value) {
      if (value < numGroups) {
        if (verticalValues.contains(value)) {
          return FlLine(
            color: Colors.black,
            strokeWidth: 1,
          );
        } else {
          return FlLine(
            color: Colors.black,
            strokeWidth: 1,
          );
        }
      } else {
        return FlLine(
          color: Colors.black,
          strokeWidth: 1,
        );
      }
    }
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

      minX: 1,
      maxX: numLinesX.toDouble() - 1,
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
         spots: List.generate(groupedXValues.length, (index) {
          final double peso = groupedPesos[index];
          final double x = groupedXValues[index];
          return FlSpot(x + 1, peso);
        }),

          isCurved: true,
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
              final double peso = barSpot.y;
              final String formattedPeso = 'Média: ${peso.toStringAsFixed(1)}Kg';

              final int index = barSpot.x.toInt() - 1;
              final String dateRange = groupedDates[index]; // Obtém a data inicial e final do grupo

              tooltips.add('$dateRange\n$formattedPeso');
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
            color: Colors.black,
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
