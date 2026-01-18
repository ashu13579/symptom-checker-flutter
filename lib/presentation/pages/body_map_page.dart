import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:symptom_checker/core/constants/body_regions.dart';
import 'package:symptom_checker/presentation/bloc/symptom_bloc.dart';
import 'package:symptom_checker/presentation/widgets/body_map_widget.dart';

class BodyMapPage extends StatelessWidget {
  const BodyMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Body Region'),
        centerTitle: true,
      ),
      body: BlocListener<SymptomBloc, SymptomState>(
        listener: (context, state) {
          if (state is SymptomDataCollecting) {
            Navigator.pushNamed(context, '/symptom-input');
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Instructions
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Tap on the body region where you feel discomfort',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Body Map
                const BodyMapWidget(),
                const SizedBox(height: 24),
                
                // Region List (Alternative to visual map)
                Text(
                  'Or select from list:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                ...BodyRegion.values.map((region) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: _RegionCard(region: region),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RegionCard extends StatelessWidget {
  final BodyRegion region;

  const _RegionCard({required this.region});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          context.read<SymptomBloc>().add(SelectBodyRegion(region));
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getIconForRegion(region),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      region.displayName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      region.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForRegion(BodyRegion region) {
    switch (region) {
      case BodyRegion.headFront:
      case BodyRegion.headBack:
      case BodyRegion.headLeft:
      case BodyRegion.headRight:
        return Icons.face;
      case BodyRegion.chest:
        return Icons.favorite;
      case BodyRegion.abdomenUpperLeft:
      case BodyRegion.abdomenUpperRight:
      case BodyRegion.abdomenLowerLeft:
      case BodyRegion.abdomenLowerRight:
        return Icons.accessibility_new;
    }
  }
}