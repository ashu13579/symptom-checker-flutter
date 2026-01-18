import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:symptom_checker/core/constants/body_regions.dart';
import 'package:symptom_checker/data/models/symptom_data.dart';
import 'package:symptom_checker/presentation/bloc/symptom_bloc.dart';

class BodySelectionPage extends StatefulWidget {
  const BodySelectionPage({super.key});

  @override
  State<BodySelectionPage> createState() => _BodySelectionPageState();
}

class _BodySelectionPageState extends State<BodySelectionPage> {
  bool _isFrontView = true;
  final Set<BodyRegion> _selectedRegions = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Where is your pain?'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Instructions
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tap one or more areas',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Front/Back Toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isFrontView = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _isFrontView
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: _isFrontView
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            'Front',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: _isFrontView
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: _isFrontView
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isFrontView = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !_isFrontView
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: !_isFrontView
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            'Back',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: !_isFrontView
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: !_isFrontView
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Body Illustration
            Expanded(
              child: Center(
                child: _buildBodyIllustration(),
              ),
            ),

            // Selected Regions Display
            if (_selectedRegions.isNotEmpty)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected areas:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _selectedRegions.map((region) {
                        return Chip(
                          label: Text(region.displayName),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: () {
                            setState(() {
                              _selectedRegions.remove(region);
                            });
                          },
                          backgroundColor: Colors.green.shade100,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

            // Continue Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedRegions.isEmpty ? null : _continue,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyIllustration() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Head
          _buildBodyPart(
            label: 'Head',
            regions: _isFrontView
                ? [BodyRegion.headFront]
                : [BodyRegion.headBack],
            icon: Icons.face,
          ),
          const SizedBox(height: 16),

          // Chest
          if (_isFrontView)
            _buildBodyPart(
              label: 'Chest',
              regions: [BodyRegion.chest],
              icon: Icons.favorite_border,
            ),
          const SizedBox(height: 16),

          // Abdomen
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBodyPart(
                label: 'Upper Left\nAbdomen',
                regions: [BodyRegion.abdomenUpperLeft],
                icon: Icons.crop_square,
                width: 140,
              ),
              const SizedBox(width: 16),
              _buildBodyPart(
                label: 'Upper Right\nAbdomen',
                regions: [BodyRegion.abdomenUpperRight],
                icon: Icons.crop_square,
                width: 140,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBodyPart(
                label: 'Lower Left\nAbdomen',
                regions: [BodyRegion.abdomenLowerLeft],
                icon: Icons.crop_square,
                width: 140,
              ),
              const SizedBox(width: 16),
              _buildBodyPart(
                label: 'Lower Right\nAbdomen',
                regions: [BodyRegion.abdomenLowerRight],
                icon: Icons.crop_square,
                width: 140,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBodyPart({
    required String label,
    required List<BodyRegion> regions,
    required IconData icon,
    double? width,
  }) {
    final isSelected = regions.any((r) => _selectedRegions.contains(r));

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedRegions.removeWhere((r) => regions.contains(r));
          } else {
            _selectedRegions.addAll(regions);
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width ?? 200,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue.shade50
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade300,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 48,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade600,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _continue() {
    if (_selectedRegions.isEmpty) return;

    // Use the first selected region as primary
    final primaryRegion = _selectedRegions.first;

    final symptomData = SymptomData(
      bodyRegion: primaryRegion,
      timestamp: DateTime.now(),
    );

    context.read<SymptomBloc>().add(SelectBodyRegion(symptomData));
    Navigator.pushNamed(context, '/symptom-input');
  }
}