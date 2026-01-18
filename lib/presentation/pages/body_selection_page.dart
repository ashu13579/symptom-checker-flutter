import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:symptom_checker/core/constants/body_regions.dart';
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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Body Map'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Disclaimer Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.blue.shade50,
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue.shade700,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'For informational purposes only',
                      style: TextStyle(
                        color: Colors.blue.shade800,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Instructions
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'Where do you feel discomfort?',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap one or more areas on the body',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Front/Back Toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
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
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: _isFrontView
                                ? Colors.teal.shade400
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person,
                                color: _isFrontView
                                    ? Colors.white
                                    : Colors.grey.shade600,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Front',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: _isFrontView
                                      ? Colors.white
                                      : Colors.grey.shade600,
                                ),
                              ),
                            ],
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
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: !_isFrontView
                                ? Colors.teal.shade400
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person_outline,
                                color: !_isFrontView
                                    ? Colors.white
                                    : Colors.grey.shade600,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Back',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: !_isFrontView
                                      ? Colors.white
                                      : Colors.grey.shade600,
                                ),
                              ),
                            ],
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
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: _buildInteractiveBodyMap(),
                  ),
                ),
              ),
            ),

            // Selected Regions Chips
            if (_selectedRegions.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.teal.shade400,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Selected areas (${_selectedRegions.length})',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _selectedRegions.map((region) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.teal.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.teal.shade200,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                region.displayName,
                                style: TextStyle(
                                  color: Colors.teal.shade700,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedRegions.remove(region);
                                  });
                                },
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.teal.shade700,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

            // Continue Button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedRegions.isEmpty ? null : _continue,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.teal.shade400,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
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

  Widget _buildInteractiveBodyMap() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: AspectRatio(
        aspectRatio: 0.5,
        child: Stack(
          children: [
            // Body outline
            CustomPaint(
              size: Size.infinite,
              painter: BodyOutlinePainter(isFront: _isFrontView),
            ),
            
            // Interactive regions
            if (_isFrontView) ..._buildFrontRegions() else ..._buildBackRegions(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFrontRegions() {
    return [
      // Head
      _buildRegion(
        region: BodyRegion.headFront,
        top: 0.02,
        left: 0.38,
        width: 0.24,
        height: 0.12,
      ),
      // Neck
      _buildRegion(
        region: BodyRegion.neck,
        top: 0.13,
        left: 0.42,
        width: 0.16,
        height: 0.06,
      ),
      // Left Shoulder
      _buildRegion(
        region: BodyRegion.leftShoulder,
        top: 0.18,
        left: 0.25,
        width: 0.18,
        height: 0.10,
      ),
      // Right Shoulder
      _buildRegion(
        region: BodyRegion.rightShoulder,
        top: 0.18,
        left: 0.57,
        width: 0.18,
        height: 0.10,
      ),
      // Chest
      _buildRegion(
        region: BodyRegion.chest,
        top: 0.20,
        left: 0.35,
        width: 0.30,
        height: 0.15,
      ),
      // Abdomen
      _buildRegion(
        region: BodyRegion.abdomen,
        top: 0.36,
        left: 0.35,
        width: 0.30,
        height: 0.18,
      ),
      // Left Arm Upper
      _buildRegion(
        region: BodyRegion.leftArmUpper,
        top: 0.28,
        left: 0.15,
        width: 0.12,
        height: 0.20,
      ),
      // Right Arm Upper
      _buildRegion(
        region: BodyRegion.rightArmUpper,
        top: 0.28,
        left: 0.73,
        width: 0.12,
        height: 0.20,
      ),
      // Left Arm Lower
      _buildRegion(
        region: BodyRegion.leftArmLower,
        top: 0.48,
        left: 0.12,
        width: 0.12,
        height: 0.18,
      ),
      // Right Arm Lower
      _buildRegion(
        region: BodyRegion.rightArmLower,
        top: 0.48,
        left: 0.76,
        width: 0.12,
        height: 0.18,
      ),
      // Left Leg Upper
      _buildRegion(
        region: BodyRegion.leftLegUpper,
        top: 0.54,
        left: 0.35,
        width: 0.14,
        height: 0.22,
      ),
      // Right Leg Upper
      _buildRegion(
        region: BodyRegion.rightLegUpper,
        top: 0.54,
        left: 0.51,
        width: 0.14,
        height: 0.22,
      ),
      // Left Leg Lower
      _buildRegion(
        region: BodyRegion.leftLegLower,
        top: 0.76,
        left: 0.35,
        width: 0.14,
        height: 0.20,
      ),
      // Right Leg Lower
      _buildRegion(
        region: BodyRegion.rightLegLower,
        top: 0.76,
        left: 0.51,
        width: 0.14,
        height: 0.20,
      ),
    ];
  }

  List<Widget> _buildBackRegions() {
    return [
      // Head Back
      _buildRegion(
        region: BodyRegion.headBack,
        top: 0.02,
        left: 0.38,
        width: 0.24,
        height: 0.12,
      ),
      // Neck Back
      _buildRegion(
        region: BodyRegion.neck,
        top: 0.13,
        left: 0.42,
        width: 0.16,
        height: 0.06,
      ),
      // Upper Back
      _buildRegion(
        region: BodyRegion.upperBack,
        top: 0.20,
        left: 0.35,
        width: 0.30,
        height: 0.18,
      ),
      // Lower Back
      _buildRegion(
        region: BodyRegion.lowerBack,
        top: 0.38,
        left: 0.35,
        width: 0.30,
        height: 0.16,
      ),
      // Left Shoulder Back
      _buildRegion(
        region: BodyRegion.leftShoulder,
        top: 0.18,
        left: 0.25,
        width: 0.18,
        height: 0.10,
      ),
      // Right Shoulder Back
      _buildRegion(
        region: BodyRegion.rightShoulder,
        top: 0.18,
        left: 0.57,
        width: 0.18,
        height: 0.10,
      ),
      // Left Arm Upper Back
      _buildRegion(
        region: BodyRegion.leftArmUpper,
        top: 0.28,
        left: 0.15,
        width: 0.12,
        height: 0.20,
      ),
      // Right Arm Upper Back
      _buildRegion(
        region: BodyRegion.rightArmUpper,
        top: 0.28,
        left: 0.73,
        width: 0.12,
        height: 0.20,
      ),
      // Left Arm Lower Back
      _buildRegion(
        region: BodyRegion.leftArmLower,
        top: 0.48,
        left: 0.12,
        width: 0.12,
        height: 0.18,
      ),
      // Right Arm Lower Back
      _buildRegion(
        region: BodyRegion.rightArmLower,
        top: 0.48,
        left: 0.76,
        width: 0.12,
        height: 0.18,
      ),
      // Left Leg Upper Back
      _buildRegion(
        region: BodyRegion.leftLegUpper,
        top: 0.54,
        left: 0.35,
        width: 0.14,
        height: 0.22,
      ),
      // Right Leg Upper Back
      _buildRegion(
        region: BodyRegion.rightLegUpper,
        top: 0.54,
        left: 0.51,
        width: 0.14,
        height: 0.22,
      ),
      // Left Leg Lower Back
      _buildRegion(
        region: BodyRegion.leftLegLower,
        top: 0.76,
        left: 0.35,
        width: 0.14,
        height: 0.20,
      ),
      // Right Leg Lower Back
      _buildRegion(
        region: BodyRegion.rightLegLower,
        top: 0.76,
        left: 0.51,
        width: 0.14,
        height: 0.20,
      ),
    ];
  }

  Widget _buildRegion({
    required BodyRegion region,
    required double top,
    required double left,
    required double width,
    required double height,
  }) {
    final isSelected = _selectedRegions.contains(region);

    return Positioned(
      top: top,
      left: left,
      child: FractionallySizedBox(
        widthFactor: width,
        heightFactor: height,
        child: GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedRegions.remove(region);
              } else {
                _selectedRegions.add(region);
              }
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.teal.shade300.withOpacity(0.6)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? Colors.teal.shade600
                    : Colors.grey.shade300.withOpacity(0.3),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Center(
              child: isSelected
                  ? Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 20,
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  void _continue() {
    if (_selectedRegions.isEmpty) return;

    // For now, just use the first selected region
    // In a real app, you might want to handle multiple regions differently
    final primaryRegion = _selectedRegions.first;

    context.read<SymptomBloc>().add(SelectBodyRegion(primaryRegion));
    Navigator.pushNamed(context, '/symptom-input');
  }
}

// Custom painter for body outline
class BodyOutlinePainter extends CustomPainter {
  final bool isFront;

  BodyOutlinePainter({required this.isFront});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();

    // Simple body outline
    final centerX = size.width / 2;
    final headRadius = size.width * 0.12;

    // Head
    canvas.drawCircle(
      Offset(centerX, size.height * 0.08),
      headRadius,
      paint,
    );

    // Neck
    path.moveTo(centerX - headRadius * 0.5, size.height * 0.14);
    path.lineTo(centerX - headRadius * 0.5, size.height * 0.19);
    path.moveTo(centerX + headRadius * 0.5, size.height * 0.14);
    path.lineTo(centerX + headRadius * 0.5, size.height * 0.19);

    // Torso
    path.moveTo(centerX - size.width * 0.15, size.height * 0.19);
    path.lineTo(centerX - size.width * 0.15, size.height * 0.54);
    path.moveTo(centerX + size.width * 0.15, size.height * 0.19);
    path.lineTo(centerX + size.width * 0.15, size.height * 0.54);

    // Shoulders
    path.moveTo(centerX - size.width * 0.15, size.height * 0.19);
    path.lineTo(centerX - size.width * 0.25, size.height * 0.23);
    path.moveTo(centerX + size.width * 0.15, size.height * 0.19);
    path.lineTo(centerX + size.width * 0.25, size.height * 0.23);

    // Arms
    path.moveTo(centerX - size.width * 0.25, size.height * 0.23);
    path.lineTo(centerX - size.width * 0.28, size.height * 0.48);
    path.lineTo(centerX - size.width * 0.30, size.height * 0.66);
    
    path.moveTo(centerX + size.width * 0.25, size.height * 0.23);
    path.lineTo(centerX + size.width * 0.28, size.height * 0.48);
    path.lineTo(centerX + size.width * 0.30, size.height * 0.66);

    // Legs
    path.moveTo(centerX - size.width * 0.07, size.height * 0.54);
    path.lineTo(centerX - size.width * 0.07, size.height * 0.76);
    path.lineTo(centerX - size.width * 0.07, size.height * 0.96);
    
    path.moveTo(centerX + size.width * 0.07, size.height * 0.54);
    path.lineTo(centerX + size.width * 0.07, size.height * 0.76);
    path.lineTo(centerX + size.width * 0.07, size.height * 0.96);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}