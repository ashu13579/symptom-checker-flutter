import 'package:dio/dio.dart';
import 'package:symptom_checker/data/models/symptom_data.dart';
import 'package:symptom_checker/data/models/analysis_result.dart';

class RemoteDataSource {
  final Dio _dio;
  
  // In production, replace with your actual backend URL
  static const String baseUrl = 'http://localhost:8000/api';
  
  RemoteDataSource() : _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
    },
  ));
  
  /// Analyze symptoms by calling backend API
  Future<AnalysisResult> analyzeSymptoms(SymptomData symptomData) async {
    try {
      final response = await _dio.post(
        '/analyze',
        data: symptomData.toJson(),
      );
      
      if (response.statusCode == 200) {
        return AnalysisResult.fromJson(response.data);
      } else {
        throw Exception('Failed to analyze symptoms: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Server took too long to respond.');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
  
  /// Health check endpoint
  Future<bool> checkHealth() async {
    try {
      final response = await _dio.get('/health');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}