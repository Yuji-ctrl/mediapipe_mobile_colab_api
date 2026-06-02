import 'package:flutter/material.dart';
import 'upload_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('フォーム分析デモ'),
        centerTitle: true,
      ),
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '分析モード',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'テニスサーブの映像をアップロードまたは撮影し、\nColab + Gemini の分析結果を受け取ります。',
                        style: TextStyle(fontSize: 15, height: 1.4),
                      ),
                      SizedBox(height: 16),
                      Chip(
                        label: Text('現在: テニスサーブのみ'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.video_library),
                label: const Text('動画送信を開始する'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const UploadScreen(mode: 'テニスサーブ'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'デモ版のため現状はテニスサーブのみ対応しています。\n次画面で動画を選択・撮影できます。',
                style: TextStyle(color: Colors.grey[700], height: 1.4),
              ),
              const Spacer(),
              const Text(
                '下部のナビゲーション領域を避けるため、余白を確保しています。',
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
