# Native の最小構成の断片

このディレクトリは Xcode / Android Studio が生成したアプリへ組み込むファイルです。単独でビルドできるプロジェクト一式ではありません。依存導入、manifest / Info.plist、Simulator と実機の接続先は教科書の付録Hを参照してください。Native の実機ビルドは Web サンプルのテストに含みません。

- iOS: Swift / Storyboard の新規 App に HotwireNative を追加し SceneDelegate を置き換えます。
- Android: Empty Views Activity に core / navigation-fragments 1.3.1 を導入し、package 名をアプリへ合わせます。
- WebView 内でログインします。外部ブラウザの cookie は自動共有しません。
