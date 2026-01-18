import 'package:symptom_checker/data/models/symptom_data.dart';
import 'package:symptom_checker/data/models/analysis_result.dart';
import 'package:symptom_checker/data/datasources/remote_data_source.dart';
import 'package:symptom_checker/domain/usecases/analyze_symptoms.dart';

abstract class SymptomRepository {
  Future<AnalysisResult> analyzeSymptoms(SymptomData symptomData);
}

class SymptomRepositoryImpl implements SymptomRepository {
  final RemoteDataSource remoteDataSource;
  final AnalyzeSymptomsUseCase _analyzeSymptomsUseCase = AnalyzeSymptomsUseCase();
  
  SymptomRepositoryImpl({required this.remoteDataSource});
  
  @override
  Future<AnalysisResult> analyzeSymptoms(SymptomData symptomData) async {
    try {
      // In production, this would call the backend API
      // For now, we use the local use case
      return await _analyzeSymptomsUseCase.execute(symptomData);
      
      // Production code would look like:
      // return await remoteDataSource.analyzeSymptoms(symptomData);
    } catch (e) {
      throw Exception('Failed to analyze symptoms: $e');
    }
  }
}