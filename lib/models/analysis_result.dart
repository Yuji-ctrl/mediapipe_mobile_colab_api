import 'package:flutter/foundation.dart';

class AnalysisResult {
  const AnalysisResult({
    required this.similarityScore,
    required this.avgDistance,
    required this.level,
    required this.issues,
    required this.advice,
  });

  final double similarityScore;
  final double avgDistance;
  final String level;
  final List<String> issues;
  final String advice;

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    debugPrint('AnalysisResult.fromJson: raw json keys=${json.keys.toList()}');
    final issuesValue = json['issues'] ?? json['issue_list'] ?? json['issueList'];
    final similarityScoreValue = json['similarity_score'] ?? json['similarityScore'];
    final avgDistanceValue = json['avg_distance'] ?? json['avgDistance'];
    final levelValue = json['level'] ?? json['evaluation_level'] ?? json['evaluationLevel'];
    final adviceValue = json['advice'] ?? json['message'] ?? json['recommendation'];

    return AnalysisResult(
      similarityScore: (similarityScoreValue as num).toDouble(),
      avgDistance: (avgDistanceValue as num).toDouble(),
      level: levelValue as String? ?? '',
      issues: issuesValue is List ? List<String>.from(issuesValue.map((item) => item.toString())) : <String>[],
      advice: adviceValue as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'similarity_score': similarityScore,
      'avg_distance': avgDistance,
      'level': level,
      'issues': issues,
      'advice': advice,
    };
  }

  @override
  String toString() {
    return 'AnalysisResult(similarityScore=$similarityScore, avgDistance=$avgDistance, level=$level, issues=$issues, advice=$advice)';
  }
}
