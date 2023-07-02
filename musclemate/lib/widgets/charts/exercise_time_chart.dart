
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ExerciseTimeChart extends StatefulWidget {
     final List<double> pesos;
     final List<String> dataTreino;
     final List<String> tempos;

    const ExerciseTimeChart({
    Key? key,
    required this.pesos,
    required this.dataTreino,
    required this.tempos
  }) : super(key: key);

  @override
  State<ExerciseTimeChart> createState() => _ExerciseTimeChartState();
}

class _ExerciseTimeChartState extends State<ExerciseTimeChart> {


   bool showAvg = false;

   Future<List<double>> loadData() async {
    // Simular uma chamada assíncrona para carregar dados
    await Future.delayed(const Duration(seconds: 2));
    return widget.pesos;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<double>>(
      future: loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {

          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {

          return Center(child: Text('Erro ao carregar os dados.'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {

          return AspectRatio(
            aspectRatio: 1.30,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 30,
                left: 12,
                top: 0,
                bottom: 0,
              ),
              child: LineChart(mainData()),
            ),
          );
        } else {

          return const Center(
            child: Text(
              'Ainda não há dados suficientes.',
              style: TextStyle(fontSize: 16),
            ),
          );
        }
      },
    );
  }

Widget bottomTitleWidgetsSingle(double value, TitleMeta meta) {
  final style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 10,
  );

  final List<String> datas = widget.dataTreino;

  if (value >= 0 && value < datas.length) {
    final String dateValue = datas[value.toInt()];

    final DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(dateValue);

    final formattedDate = DateFormat('dd/MM', 'pt_BR').format(parsedDate);

    final text = Text(
      formattedDate,
      style: style,
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  } else {

    return SizedBox.shrink();
  }
}

Widget bottomTitleWidgetsGroup(double value, TitleMeta meta) {
  final style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 10,
  );

  final int index = value.toInt();
  final int startIndex = index * 6;
  final int endIndex = (index + 1) * 6;
  final int dataTreinoLength = widget.dataTreino.length;

  final List<String> groupDates = [];
  for (int i = startIndex; i < endIndex && i < dataTreinoLength; i++) {
    groupDates.add(widget.dataTreino[i]);
  }
print('Quantidade de grupos: ${groupDates.length}');
  // Contagem dos meses
  final Map<String, int> monthCount = {};
  for (final date in groupDates) {
    final DateTime parsedDate = DateFormat('dd/MM/yyyy', 'pt_BR').parse(date);
    final String monthKey = DateFormat.MMM('pt_BR').format(parsedDate);
    monthCount[monthKey] = (monthCount[monthKey] ?? 0) + 1;
  }

  // Encontrar o mês com maior contagem
  String mostCommonMonth = '';
  int maxCount = 0;
  monthCount.forEach((month, count) {
    if (count > maxCount) {
      maxCount = count;
      mostCommonMonth = month;
    }
  });

  final text = Text(mostCommonMonth, style: style);

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}

 LineChartData mainData() {

  if (widget.pesos.length >= 6) {

    final List<double> groupedPesos = [];
    final List<double> groupedXValues = [];
    final List<String> groupedDates = [];

    final int groupSize = 6;
    final int numGroups = widget.pesos.length ~/ groupSize;

     initializeDateFormatting();
    for (int i = 0; i < numGroups; i++) {
      final List<double> group = widget.pesos.sublist(i * groupSize, (i + 1) * groupSize);
      final double avgPeso = group.reduce((sum, peso) => sum + peso) / groupSize;

      final double dates = i.toDouble();
      groupedPesos.add(avgPeso);
      groupedXValues.add(dates);

      final DateTime startDate = DateFormat('dd/MM/yyyy').parse(widget.dataTreino[i * groupSize]);
      final DateTime endDate = DateFormat('dd/MM/yyyy').parse(widget.dataTreino[(i + 1) * groupSize - 1]);

       final DateFormat formattedDate = DateFormat("dd 'de' MMM", 'pt_BR');
      final String formattedStartDate = formattedDate.format(startDate);
      final String formattedEndDate = formattedDate.format(endDate);
      groupedDates.add('$formattedStartDate a $formattedEndDate');
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
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: bottomTitleWidgetsGroup
          ),
        )

      ),

      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color(0xff37434d)),
          left: BorderSide(color: Color(0xff37434d)),
          right: BorderSide(color: Color(0xff37434d)),
        ),
      ),

      minX: 1,
      maxX: numLinesX.toDouble(),
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
     initializeDateFormatting();
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
                bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: bottomTitleWidgetsSingle
          ),
        )
      ),

      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color(0xff37434d)),
          left: BorderSide(color: Color(0xff37434d)),
          right: BorderSide(color: Color(0xff37434d)),
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
