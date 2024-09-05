import '../models/recipe.dart';

class ValidationResult {
  final bool isValid;
  final List<String> issues;

  ValidationResult({required this.isValid, required this.issues});
}

class RecipeValidator {
  static Future<ValidationResult> validate(Recipe recipe) async {
    List<String> issues = [];

    // Check if the recipe has a name
    if (recipe.name.isEmpty) {
      issues.add('Recipe must have a name');
    }

    // Check if the recipe has steps
    if (recipe.steps.isEmpty) {
      issues.add('Recipe must have at least one step');
    }

    // Validate individual steps
    _validateSteps(recipe.steps, issues);

    // Check total duration
    int totalDuration = _calculateTotalDuration(recipe.steps);
    if (totalDuration > 7200) { // 2 hours
      issues.add('Total recipe duration exceeds 2 hours');
    }

    // Check for consecutive purge steps
    _checkConsecutivePurges(recipe.steps, issues);

    return ValidationResult(
      isValid: issues.isEmpty,
      issues: issues,
    );
  }

  static void _validateSteps(List<RecipeStep> steps, List<String> issues) {
    for (var step in steps) {
      switch (step.type) {
        case 'Valve':
        case 'Purge':
          if (step.parameters['duration'] == null || step.parameters['duration'] <= 0) {
            issues.add('${step.type} step must have a positive duration');
          }
          break;
        case 'Loop':
          if (step.parameters['count'] == null || step.parameters['count'] <= 0) {
            issues.add('Loop must have a positive repeat count');
          }
          if (step.nestedSteps == null || step.nestedSteps!.isEmpty) {
            issues.add('Loop must contain at least one step');
          } else {
            _validateSteps(step.nestedSteps!, issues);
          }
          break;
        default:
          issues.add('Unknown step type: ${step.type}');
      }
    }
  }

  static int _calculateTotalDuration(List<RecipeStep> steps) {
    int totalDuration = 0;
    for (var step in steps) {
      switch (step.type) {
        case 'Valve':
        case 'Purge':
          totalDuration += step.parameters['duration'] as int? ?? 0;
          break;
        case 'Loop':
          int count = step.parameters['count'] as int? ?? 1;
          if (step.nestedSteps != null) {
            totalDuration += count * _calculateTotalDuration(step.nestedSteps!);
          }
          break;
      }
    }
    return totalDuration;
  }

  static void _checkConsecutivePurges(List<RecipeStep> steps, List<String> issues) {
    bool lastWasPurge = false;
    for (var step in steps) {
      if (step.type == 'Purge') {
        if (lastWasPurge) {
          issues.add('Consecutive purge steps detected. This may be inefficient.');
          break;
        }
        lastWasPurge = true;
      } else {
        lastWasPurge = false;
      }
      if (step.type == 'Loop' && step.nestedSteps != null) {
        _checkConsecutivePurges(step.nestedSteps!, issues);
      }
    }
  }
}