import 'package:flutter/material.dart';
import 'package:musclemate/widgets/charts/exercise_time_chart.dart';
import 'package:musclemate/widgets/charts/exercise_volume_chart.dart';
import 'package:musclemate/widgets/charts/weight_progress_chart.dart';

class PerfilProgress extends StatelessWidget {
  const PerfilProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0,),
      child: Container(
        width: double.infinity,
        height: 600,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Progressão de peso',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 1,
                    height: 18,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Carga máxima atingida: 42kg',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const WeightProgressChart(),
              const SizedBox(height: 20),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Duração do treino',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 1,
                        height: 18,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Tempo total de treino no ano: 23h',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const ExerciseTimeChart(),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Vol. de treino',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 1,
                        height: 18,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Volume máximo atingido: 230kg',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Padding(
                     padding: EdgeInsets.only(bottom: 50.0),
                    child: ExerciseVolumeChart(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
