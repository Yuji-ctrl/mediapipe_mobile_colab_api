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
    final issuesValue = json['issues'];
    return AnalysisResult(
      similarityScore: (json['similarity_score'] as num).toDouble(),
      avgDistance: (json['avg_distance'] as num).toDouble(),
      level: json['level'] as String? ?? '',
      issues: issuesValue is List ? List<String>.from(issuesValue.map((item) => item.toString())) : <String>[],
      advice: json['advice'] as String? ?? '',
    );
  }
}
