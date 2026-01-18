import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:symptom_checker/data/models/symptom_data.dart';
import 'package:symptom_checker/presentation/bloc/symptom_bloc.dart';
import 'package:symptom_checker/core/constants/body_regions.dart';

class SymptomInputPage extends StatefulWidget {
  const SymptomInputPage({super.key});

  @override
  State<SymptomInputPage> createState() => _SymptomInputPageState();
}

class _SymptomInputPageState extends State<SymptomInputPage> {
  int _currentStep = 0;
  
  // Step 1: Pain Type & Intensity
  PainType? _painType;
  int _intensity = 5;
  
  // Step 2: Duration
  SymptomDuration? _duration;
  int _durationValue = 1;
  Onset? _onset;
  
  // Step 3: Triggers & Associated Symptoms
  final Set<Trigger> _triggers = {};
  final Set<AssociatedSymptom> _associatedSymptoms = {};
  
  // Optional Demographics
  String? _ageRange;
  String? _biologicalSex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Symptom Details'),
        centerTitle: true,
      ),
      body: BlocBuilder<SymptomBloc, SymptomState>(
        builder: (context, state) {
          if (state is! SymptomDataCollecting) {
            return const Center(child: Text('Error: Invalid state'));
          }

          return Column(
            children: [
              // Progress Indicator
              _buildProgressIndicator(),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: _buildCurrentStep(state),
                ),
              ),
              
              // Navigation Buttons
              _buildNavigationButtons(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: List.generate(3, (index) {
              final isCompleted = index < _currentStep;
              final isCurrent = index == _currentStep;
              
              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: isCompleted || isCurrent
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    if (index < 2) const SizedBox(width: 4),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
            'Step ${_currentStep + 1} of 3',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep(SymptomDataCollecting state) {
    switch (_currentStep) {
      case 0:
        return _buildPainDetailsStep(state);
      case 1:
        return _buildDurationStep();
      case 2:
        return _buildAssociatedSymptomsStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildPainDetailsStep(SymptomDataCollecting state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Selected Region Display
        Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected Area',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        state.symptomData.bodyRegion.displayName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Pain Type
        _SectionTitle(
          title: 'What type of sensation?',
          icon: Icons.touch_app,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: PainType.values.map((type) {
            return ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getPainTypeIcon(type),
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(_getPainTypeLabel(type)),
                ],
              ),
              selected: _painType == type,
              onSelected: (selected) {
                setState(() {
                  _painType = selected ? type : null;
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 32),

        // Pain Intensity
        _SectionTitle(
          title: 'How intense is it? (1-10)',
          icon: Icons.speed,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 8,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 12,
                  ),
                ),
                child: Slider(
                  value: _intensity.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: _intensity.toString(),
                  onChanged: (value) {
                    setState(() {
                      _intensity = value.toInt();
                    });
                  },
                ),
              ),
            ),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _getIntensityColor(_intensity),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  _intensity.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Mild',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
            Text(
              'Moderate',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
            Text(
              'Severe',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDurationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle(
          title: 'When did it start?',
          icon: Icons.access_time,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: Onset.values.map((onset) {
            return ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    onset == Onset.sudden
                        ? Icons.flash_on
                        : Icons.trending_up,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(_getOnsetLabel(onset)),
                ],
              ),
              selected: _onset == onset,
              onSelected: (selected) {
                setState(() {
                  _onset = selected ? onset : null;
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 32),

        _SectionTitle(
          title: 'How long have you had this?',
          icon: Icons.calendar_today,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: SymptomDuration.values.map((duration) {
            return ChoiceChip(
              label: Text(_getDurationLabel(duration)),
              selected: _duration == duration,
              onSelected: (selected) {
                setState(() {
                  _duration = selected ? duration : null;
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 32),

        _SectionTitle(
          title: 'What makes it worse?',
          icon: Icons.warning_amber,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: Trigger.values.map((trigger) {
            return FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getTriggerIcon(trigger),
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(_getTriggerLabel(trigger)),
                ],
              ),
              selected: _triggers.contains(trigger),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _triggers.add(trigger);
                  } else {
                    _triggers.remove(trigger);
                  }
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            setState(() {
              _triggers.clear();
            });
          },
          child: const Text('Skip this question'),
        ),
      ],
    );
  }

  Widget _buildAssociatedSymptomsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle(
          title: 'Any other symptoms?',
          icon: Icons.health_and_safety,
        ),
        const SizedBox(height: 12),
        Text(
          'Select all that apply',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AssociatedSymptom.values.map((symptom) {
            return FilterChip(
              label: Text(symptom.displayName),
              selected: _associatedSymptoms.contains(symptom),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _associatedSymptoms.add(symptom);
                  } else {
                    _associatedSymptoms.remove(symptom);
                  }
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            setState(() {
              _associatedSymptoms.clear();
            });
          },
          child: const Text('Skip this question'),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _currentStep--;
                  });
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Back'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _canProceed() ? _handleNext : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _currentStep < 2 ? 'Next' : 'Get Insights',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _painType != null;
      case 1:
        return _onset != null && _duration != null;
      case 2:
        return true; // Associated symptoms are optional
      default:
        return false;
    }
  }

  void _handleNext() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
    } else {
      _analyzeSymptoms();
    }
  }

  void _analyzeSymptoms() {
    final state = context.read<SymptomBloc>().state;
    if (state is! SymptomDataCollecting) return;

    final updatedData = state.symptomData.copyWith(
      painType: _painType,
      intensity: _intensity,
      duration: _duration,
      durationValue: _durationValue,
      onset: _onset,
      triggers: _triggers.toList(),
      associatedSymptoms: _associatedSymptoms.toList(),
      ageRange: _ageRange,
      biologicalSex: _biologicalSex,
    );

    context.read<SymptomBloc>().add(UpdateSymptomData(updatedData));
    context.read<SymptomBloc>().add(const AnalyzeSymptoms());
    Navigator.pushNamed(context, '/results');
  }

  Color _getIntensityColor(int intensity) {
    if (intensity <= 3) return Colors.green;
    if (intensity <= 6) return Colors.orange;
    return Colors.red.shade400;
  }

  IconData _getPainTypeIcon(PainType type) {
    switch (type) {
      case PainType.sharp:
        return Icons.flash_on;
      case PainType.dull:
        return Icons.circle;
      case PainType.burning:
        return Icons.local_fire_department;
      case PainType.pressure:
        return Icons.compress;
      case PainType.stabbing:
        return Icons.arrow_upward;
      case PainType.throbbing:
        return Icons.favorite;
      case PainType.cramping:
        return Icons.waves;
    }
  }

  IconData _getTriggerIcon(Trigger trigger) {
    switch (trigger) {
      case Trigger.movement:
        return Icons.directions_run;
      case Trigger.breathing:
        return Icons.air;
      case Trigger.eating:
        return Icons.restaurant;
      case Trigger.stress:
        return Icons.psychology;
      case Trigger.touch:
        return Icons.touch_app;
      case Trigger.rest:
        return Icons.bed;
      case Trigger.none:
        return Icons.block;
    }
  }

  String _getPainTypeLabel(PainType type) {
    return type.name[0].toUpperCase() + type.name.substring(1);
  }

  String _getDurationLabel(SymptomDuration duration) {
    return duration.name[0].toUpperCase() + duration.name.substring(1);
  }

  String _getOnsetLabel(Onset onset) {
    return onset.name[0].toUpperCase() + onset.name.substring(1);
  }

  String _getTriggerLabel(Trigger trigger) {
    return trigger.name[0].toUpperCase() + trigger.name.substring(1);
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}