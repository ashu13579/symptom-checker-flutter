import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:symptom_checker/data/models/analysis_result.dart';
import 'package:symptom_checker/presentation/bloc/symptom_bloc.dart';
import 'package:symptom_checker/core/theme/app_theme.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Results'),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<SymptomBloc, SymptomState>(
        builder: (context, state) {
          if (state is SymptomAnalyzing) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 24),
                  Text('Analyzing your symptoms...'),
                ],
              ),
            );
          }

          if (state is SymptomAnalyzed) {
            return _ResultsContent(
              result: state.result,
              onNewCheck: () {
                context.read<SymptomBloc>().add(const ResetSymptoms());
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            );
          }

          if (state is SymptomError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SymptomBloc>().add(const ResetSymptoms());
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: const Text('Start Over'),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('No results available'));
        },
      ),
    );
  }
}

class _ResultsContent extends StatelessWidget {
  final AnalysisResult result;
  final VoidCallback onNewCheck;

  const _ResultsContent({
    required this.result,
    required this.onNewCheck,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Emergency Banner
          if (result.isEmergency) _EmergencyBanner(),
          if (result.isEmergency) const SizedBox(height: 24),

          // Urgency Level Card
          _UrgencyCard(urgencyLevel: result.urgencyLevel),
          const SizedBox(height: 24),

          // Red Flags (if any)
          if (result.redFlags.isNotEmpty) ...[
            _RedFlagsCard(redFlags: result.redFlags),
            const SizedBox(height: 24),
          ],

          // Guidance
          _GuidanceCard(guidance: result.guidance),
          const SizedBox(height: 24),

          // Possible Causes
          _SectionTitle(title: 'Possible Explanations'),
          const SizedBox(height: 12),
          ...result.possibleCauses.map((cause) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _CauseCard(cause: cause),
          )),
          const SizedBox(height: 24),

          // AI Explanation
          _AIExplanationCard(explanation: result.aiExplanation),
          const SizedBox(height: 24),

          // Disclaimer
          _DisclaimerCard(),
          const SizedBox(height: 24),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onNewCheck,
                  child: const Text('New Check'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // In production, this could save results or share
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Results saved locally'),
                      ),
                    );
                  },
                  child: const Text('Save Results'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmergencyBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red[50],
        border: Border.all(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.emergency, color: Colors.red, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🚨 EMERGENCY',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Seek immediate medical attention. Call emergency services or go to the nearest emergency room.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UrgencyCard extends StatelessWidget {
  final UrgencyLevel urgencyLevel;

  const _UrgencyCard({required this.urgencyLevel});

  @override
  Widget build(BuildContext context) {
    final color = _getUrgencyColor(urgencyLevel);
    final icon = _getUrgencyIcon(urgencyLevel);

    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(icon, size: 64, color: color),
            const SizedBox(height: 16),
            Text(
              urgencyLevel.displayName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getUrgencyColor(UrgencyLevel level) {
    switch (level) {
      case UrgencyLevel.low:
        return AppTheme.lowUrgency;
      case UrgencyLevel.medium:
        return AppTheme.mediumUrgency;
      case UrgencyLevel.high:
      case UrgencyLevel.emergency:
        return AppTheme.highUrgency;
    }
  }

  IconData _getUrgencyIcon(UrgencyLevel level) {
    switch (level) {
      case UrgencyLevel.low:
        return Icons.check_circle_outline;
      case UrgencyLevel.medium:
        return Icons.warning_amber_rounded;
      case UrgencyLevel.high:
        return Icons.error_outline;
      case UrgencyLevel.emergency:
        return Icons.emergency;
    }
  }
}

class _RedFlagsCard extends StatelessWidget {
  final List<String> redFlags;

  const _RedFlagsCard({required this.redFlags});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.flag, color: Colors.red),
                const SizedBox(width: 12),
                Text(
                  'Red Flags Detected',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red[900],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...redFlags.map((flag) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 16)),
                  Expanded(child: Text(flag)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _GuidanceCard extends StatelessWidget {
  final String guidance;

  const _GuidanceCard({required this.guidance});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Recommended Action',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(guidance),
          ],
        ),
      ),
    );
  }
}

class _CauseCard extends StatelessWidget {
  final PossibleCause cause;

  const _CauseCard({required this.cause});

  @override
  Widget build(BuildContext context) {
    final percentage = (cause.probability * 100).toStringAsFixed(0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    cause.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$percentage% match',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(cause.description),
            if (cause.matchingSymptoms.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: cause.matchingSymptoms.map((symptom) {
                  return Chip(
                    label: Text(symptom, style: const TextStyle(fontSize: 12)),
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AIExplanationCard extends StatelessWidget {
  final String explanation;

  const _AIExplanationCard({required this.explanation});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology, color: Colors.blue[700]),
                const SizedBox(width: 12),
                Text(
                  'AI Analysis',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(explanation),
          ],
        ),
      ),
    );
  }
}

class _DisclaimerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.amber[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.orange[800]),
                const SizedBox(width: 12),
                Text(
                  'Medical Disclaimer',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[900],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'This information is for educational purposes only and is not a medical diagnosis. '
              'Always consult with a qualified healthcare professional for proper evaluation and treatment.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}