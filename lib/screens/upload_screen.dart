import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/colab_api.dart';
import 'result_screen.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key, required this.mode});

  final String mode;

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final ImagePicker _picker = ImagePicker();
  // final ColabApiService _apiService = const ColabApiService();
  final ColabApiService _apiService = api;

  XFile? _selectedVideo;
  bool _isSending = false;
  String? _errorMessage;

  Future<void> _pickVideo(ImageSource source) async {
    try {
      final picked = await _picker.pickVideo(source: source, maxDuration: const Duration(seconds: 60));
      if (picked == null) {
        return;
      }

      setState(() {
        _selectedVideo = picked;
        _errorMessage = null;
      });
    } catch (error) {
      setState(() {
        _errorMessage = '動画の読み込みに失敗しました。もう一度お試しください。';
      });
    }
  }

  Future<void> _sendVideo() async {
    if (_selectedVideo == null) {
      setState(() {
        _errorMessage = 'まずは動画をアップロードまたは撮影してください。';
      });
      return;
    }

    setState(() {
      _isSending = true;
      _errorMessage = null;
    });

    try {
      final result = await _apiService.sendVideoForAnalysis(File(_selectedVideo!.path), mode: widget.mode);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(result: result),
        ),
      );
    } catch (error) {
      setState(() {
        _errorMessage = '送信に失敗しました。ネットワーク環境やAPI設定を確認してください。';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('動画送信'),
      ),
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '分析モード: ${widget.mode}',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.photo_library),
                label: const Text('ギャラリーから動画を選択'),
                onPressed: _isSending ? null : () => _pickVideo(ImageSource.gallery),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.videocam),
                label: const Text('その場で動画を撮影'),
                onPressed: _isSending ? null : () => _pickVideo(ImageSource.camera),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
              const SizedBox(height: 24),
              if (_selectedVideo != null) ...[
                Text(
                  '選択中の動画',
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  _selectedVideo!.name,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 16),
              ],
              if (_errorMessage != null) ...[
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
              ],
              const Spacer(),
              FilledButton.icon(
                icon: _isSending ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.send),
                label: Text(_isSending ? '送信中...' : '動画をAPIへ送信する'),
                onPressed: _isSending ? null : _sendVideo,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '送信後、Colab と Gemini の解析結果が返ってきます。',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
