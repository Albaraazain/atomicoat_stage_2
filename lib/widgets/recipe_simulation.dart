import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/recipe_validator.dart';

class RecipeSimulation extends StatefulWidget {
  final Recipe recipe;

  const RecipeSimulation({Key? key, required this.recipe}) : super(key: key);

  @override
  _RecipeSimulationState createState() => _RecipeSimulationState();
}

class _RecipeSimulationState extends State<RecipeSimulation> {
  late Future<Map<String, dynamic>> _simulationResults;

  @override
  void initState() {
    super.initState();
    _simulationResults = _runSimulation();
  }

  Future<Map<String, dynamic>> _runSimulation() async {
    // Simulate a delay for calculation
    await Future.delayed(const Duration(seconds: 2));

    int totalDuration = 0;
    double coatingThickness = 0;
    List<String> potentialIssues = [];

    void processStep(RecipeStep step) {
      switch (step.type) {
        case 'Valve':
        case 'Purge':
          int duration = step.parameters['duration'] as int? ?? 0;
          totalDuration += duration;
          // Simulate coating thickness increase (this is a simplified model)
          coatingThickness += duration * 0.1;
          break;
        case 'Loop':
          int count = step.parameters['count'] as int? ?? 1;
          for (int i = 0; i < count; i++) {
            step.nestedSteps?.forEach(processStep);
          }
          break;
      }
    }

    widget.recipe.steps.forEach(processStep);

    // Check for potential issues
    if (totalDuration > 3600) {
      potentialIssues.add('Recipe duration exceeds 1 hour');
    }
    if (coatingThickness > 1000) {
      potentialIssues.add('Coating thickness may be too high');
    }

    return {
      'estimatedTime': Duration(seconds: totalDuration),
      'predictedThickness': coatingThickness.toStringAsFixed(2),
      'potentialIssues': potentialIssues,
    };
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Recipe Simulation: ${widget.recipe.name}'),
      content: FutureBuilder<Map<String, dynamic>>(
        future: _simulationResults,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            final results = snapshot.data!;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Estimated process time: ${results['estimatedTime'].toString()}'),
                Text('Predicted coating thickness: ${results['predictedThickness']} nm'),
                const SizedBox(height: 10),
                const Text('Potential issues:', style: TextStyle(fontWeight: FontWeight.bold)),
                if (results['potentialIssues'].isEmpty)
                  const Text('None detected')
                else
                  ...results['potentialIssues'].map((issue) => Text('• $issue')),
              ],
            );
          } else {
            return const Text('No data');
          }
        },
      ),
      actions: [
        TextButton(
          child: const Text('Close'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text('Validate Recipe'),
          onPressed: () async {
            final validationResults = await RecipeValidator.validate(widget.recipe);
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Recipe Validation Results'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Validation Status: ${validationResults.isValid ? 'Valid' : 'Invalid'}'),
                    const SizedBox(height: 10),
                    const Text('Issues:', style: TextStyle(fontWeight: FontWeight.bold)),
                    if (validationResults.issues.isEmpty)
                      const Text('No issues found')
                    else
                      ...validationResults.issues.map((issue) => Text('• $issue')),
                  ],
                ),
                actions: [
                  TextButton(
                    child: const Text('Close'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}