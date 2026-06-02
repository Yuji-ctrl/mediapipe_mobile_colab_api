import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
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

    final baseUri = Uri.parse(apiUrl!);
    final analyzePath = baseUri.path.endsWith('/')
        ? '${baseUri.path}analyze'
        : '${baseUri.path}/analyze';
    final uri = baseUri.replace(path: analyzePath);

    debugPrint('ColabApiService: sending request to $uri');
    debugPrint('ColabApiService: request fields={"mode": "$mode"}');
    debugPrint('ColabApiService: video path=${videoFile.path}');

    final request = http.MultipartRequest('POST', uri);
    request.fields['mode'] = mode;

    try {
      request.files.add(await http.MultipartFile.fromPath('video', videoFile.path));
      debugPrint('ColabApiService: attached video file size=${await File(videoFile.path).length()} bytes');
    } catch (error) {
      throw FileSystemException('動画ファイルの読み込みに失敗しました: ${error.toString()}', videoFile.path);
    }

    http.StreamedResponse response;
    try {
      response = await request.send();
    } catch (error) {
      throw HttpException('ネットワーク接続に失敗しました: ${error.toString()}');
    }

    final body = await response.stream.bytesToString();
    debugPrint('ColabApiService: response status=${response.statusCode}');
    debugPrint('ColabApiService: response headers=${response.headers}');
    debugPrint('ColabApiService: response body=$body');

    if (response.statusCode != 200) {
      throw HttpException('Colab API error: ${response.statusCode}, body=$body');
    }

    try {
      final decoded = jsonDecode(body) as Map<String, dynamic>;
      debugPrint('ColabApiService: decoded JSON keys=${decoded.keys.toList()}');
      return AnalysisResult.fromJson(decoded);
    } catch (error) {
      throw FormatException('レスポンスのJSON解析に失敗しました: ${error.toString()}, body=$body');
    }
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
