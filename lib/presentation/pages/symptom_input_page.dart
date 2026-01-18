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
  PainType? _painType;
  int _intensity = 5;
  SymptomDuration? _duration;
  int _durationValue = 1;
  Onset? _onset;
  final Set<Trigger> _triggers = {};
  final Set<AssociatedSymptom> _associatedSymptoms = {};
  String? _ageRange;
  String? _biologicalSex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Describe Your Symptoms'),
      ),
      body: BlocBuilder<SymptomBloc, SymptomState>(
        builder: (context, state) {
          if (state is! SymptomDataCollecting) {
            return const Center(child: Text('Error: Invalid state'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Selected Region Display
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Selected Region',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.symptomData.bodyRegion.displayName,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Pain Type
                _SectionTitle(title: 'Pain Type'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: PainType.values.map((type) {
                    return ChoiceChip(
                      label: Text(_getPainTypeLabel(type)),
                      selected: _painType == type,
                      onSelected: (selected) {
                        setState(() {
                          _painType = selected ? type : null;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Pain Intensity
                _SectionTitle(title: 'Pain Intensity (1-10)'),
                Row(
                  children: [
                    Expanded(
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
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: _getIntensityColor(_intensity),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          _intensity.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Duration
                _SectionTitle(title: 'How long have you had this?'),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Value',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _durationValue = int.tryParse(value) ?? 1;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: DropdownButtonFormField<SymptomDuration>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Unit',
                        ),
                        value: _duration,
                        items: SymptomDuration.values.map((duration) {
                          return DropdownMenuItem(
                            value: duration,
                            child: Text(_getDurationLabel(duration)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _duration = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Onset
                _SectionTitle(title: 'How did it start?'),
                Wrap(
                  spacing: 8,
                  children: Onset.values.map((onset) {
                    return ChoiceChip(
                      label: Text(_getOnsetLabel(onset)),
                      selected: _onset == onset,
                      onSelected: (selected) {
                        setState(() {
                          _onset = selected ? onset : null;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Triggers
                _SectionTitle(title: 'What makes it worse?'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: Trigger.values.map((trigger) {
                    return FilterChip(
                      label: Text(_getTriggerLabel(trigger)),
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
                const SizedBox(height: 24),

                // Associated Symptoms
                _SectionTitle(title: 'Other symptoms you\'re experiencing'),
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
                const SizedBox(height: 24),

                // Optional Demographics
                _SectionTitle(title: 'Optional Information'),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Age Range (Optional)',
                  ),
                  value: _ageRange,
                  items: const [
                    DropdownMenuItem(value: '0-17', child: Text('0-17')),
                    DropdownMenuItem(value: '18-30', child: Text('18-30')),
                    DropdownMenuItem(value: '31-50', child: Text('31-50')),
                    DropdownMenuItem(value: '51-70', child: Text('51-70')),
                    DropdownMenuItem(value: '70+', child: Text('70+')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _ageRange = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Biological Sex (Optional)',
                  ),
                  value: _biologicalSex,
                  items: const [
                    DropdownMenuItem(value: 'male', child: Text('Male')),
                    DropdownMenuItem(value: 'female', child: Text('Female')),
                    DropdownMenuItem(value: 'other', child: Text('Other')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _biologicalSex = value;
                    });
                  },
                ),
                const SizedBox(height: 32),

                // Analyze Button
                ElevatedButton(
                  onPressed: _canAnalyze() ? _analyzeSymptoms : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Analyze Symptoms',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool _canAnalyze() {
    return _painType != null && _duration != null && _onset != null;
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
    return Colors.red;
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

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}