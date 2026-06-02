import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/analysis_result.dart';
const api = ColabApiService(
  apiUrl: 'https://shorthand-elective-certainly.ngrok-free.dev/',
);

class ColabApiService {
  const ColabApiService({this.apiUrl});

  /// APIのURLが未設定の場合には、ダミー結果を返します。
  final String? apiUrl;

  Future<AnalysisResult> sendVideoForAnalysis(File videoFile, {required String mode}) async {
    if (apiUrl == null || apiUrl!.isEmpty) {
      await Future<void>.delayed(const Duration(milliseconds: 600));
      return _sampleResponse();
    }

    final uri = Uri.parse(apiUrl!);
    final request = http.MultipartRequest('POST', uri);
    request.fields['mode'] = mode;
    request.files.add(await http.MultipartFile.fromPath('video', videoFile.path));

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      throw HttpException('Colab API error: ${response.statusCode}');
    }

    final decoded = jsonDecode(body) as Map<String, dynamic>;
    return AnalysisResult.fromJson(decoded);
  }

  AnalysisResult _sampleResponse() {
    return const AnalysisResult(
      similarityScore: 78.4,
      avgDistance: 0.243,
      level: 'おおむね近い',
      issues: ['上体の姿勢が少し不安定', '肩の開くタイミングがやや早い'],
      advice: '全体としてサーブフォームは安定してきています。上体の軸をもう少し意識して、肩の動きはタイミングを揃えるとさらに良くなります。小さな調整でスイングが自然になりますから、次の練習でもリラックスして続けてみましょう。',
    );
  }
}
