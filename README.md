# mediapipe_mobile_colab_api

動画をアップロードするとAI（MediaPipe、Gemini）が映像を解析してあなたの動きにフィードバックをくれます。骨格推定の上動きをお手本動画と比べることであなたの動きが何点か採点してくれます。現在はテニスのサーブのみですが、スマッシュやエアKなどほかの動作にも対応予定です。Google Colabolatory上で動作するMediaPipeのコードがNgrokのサーバーを通して分析結果を返してくれます。MediaPipeの分析後Gemini APIが文章でアドバイスを生成し、フロントエンド（Flutter）に表示します。

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
