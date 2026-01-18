import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:symptom_checker/data/models/symptom_data.dart';
import 'package:symptom_checker/data/models/analysis_result.dart';
import 'package:symptom_checker/data/repositories/symptom_repository_impl.dart';
import 'package:symptom_checker/core/constants/body_regions.dart';

// Events
abstract class SymptomEvent extends Equatable {
  const SymptomEvent();
  
  @override
  List<Object?> get props => [];
}

class SelectBodyRegion extends SymptomEvent {
  final BodyRegion region;
  
  const SelectBodyRegion(this.region);
  
  @override
  List<Object?> get props => [region];
}

class UpdateSymptomData extends SymptomEvent {
  final SymptomData symptomData;
  
  const UpdateSymptomData(this.symptomData);
  
  @override
  List<Object?> get props => [symptomData];
}

class AnalyzeSymptoms extends SymptomEvent {
  const AnalyzeSymptoms();
}

class ResetSymptoms extends SymptomEvent {
  const ResetSymptoms();
}

// States
abstract class SymptomState extends Equatable {
  const SymptomState();
  
  @override
  List<Object?> get props => [];
}

class SymptomInitial extends SymptomState {}

class BodyRegionSelected extends SymptomState {
  final BodyRegion region;
  
  const BodyRegionSelected(this.region);
  
  @override
  List<Object?> get props => [region];
}

class SymptomDataCollecting extends SymptomState {
  final SymptomData symptomData;
  
  const SymptomDataCollecting(this.symptomData);
  
  @override
  List<Object?> get props => [symptomData];
}

class SymptomAnalyzing extends SymptomState {
  final SymptomData symptomData;
  
  const SymptomAnalyzing(this.symptomData);
  
  @override
  List<Object?> get props => [symptomData];
}

class SymptomAnalyzed extends SymptomState {
  final SymptomData symptomData;
  final AnalysisResult result;
  
  const SymptomAnalyzed(this.symptomData, this.result);
  
  @override
  List<Object?> get props => [symptomData, result];
}

class SymptomError extends SymptomState {
  final String message;
  
  const SymptomError(this.message);
  
  @override
  List<Object?> get props => [message];
}

// BLoC
class SymptomBloc extends Bloc<SymptomEvent, SymptomState> {
  final SymptomRepositoryImpl repository;
  
  SymptomBloc({required this.repository}) : super(SymptomInitial()) {
    on<SelectBodyRegion>(_onSelectBodyRegion);
    on<UpdateSymptomData>(_onUpdateSymptomData);
    on<AnalyzeSymptoms>(_onAnalyzeSymptoms);
    on<ResetSymptoms>(_onResetSymptoms);
  }
  
  void _onSelectBodyRegion(
    SelectBodyRegion event,
    Emitter<SymptomState> emit,
  ) {
    emit(BodyRegionSelected(event.region));
    
    // Initialize symptom data with selected region
    final symptomData = SymptomData(
      bodyRegion: event.region,
      timestamp: DateTime.now(),
    );
    
    emit(SymptomDataCollecting(symptomData));
  }
  
  void _onUpdateSymptomData(
    UpdateSymptomData event,
    Emitter<SymptomState> emit,
  ) {
    emit(SymptomDataCollecting(event.symptomData));
  }
  
  Future<void> _onAnalyzeSymptoms(
    AnalyzeSymptoms event,
    Emitter<SymptomState> emit,
  ) async {
    if (state is! SymptomDataCollecting) return;
    
    final symptomData = (state as SymptomDataCollecting).symptomData;
    
    emit(SymptomAnalyzing(symptomData));
    
    try {
      final result = await repository.analyzeSymptoms(symptomData);
      emit(SymptomAnalyzed(symptomData, result));
    } catch (e) {
      emit(SymptomError('Failed to analyze symptoms: ${e.toString()}'));
    }
  }
  
  void _onResetSymptoms(
    ResetSymptoms event,
    Emitter<SymptomState> emit,
  ) {
    emit(SymptomInitial());
  }
}