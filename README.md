# Relay — Hotwire 教科書 完成版サンプルアプリ

[FBC Press「Hotwire 教科書」](https://github.com/fjordllc) で育てるチーム向けタスク管理アプリ **Relay** の完成版コードです。本書を読みながら、手元のコードと突き合わせるための参照実装です。

- プロジェクトの下にタスクがぶら下がり、タスクにステータス・担当者・タグ・コメントが付きます。
- Turbo Drive / Frames / Streams、Stimulus、Action Cable によるリアルタイム更新を、素の CRUD から段階的に Hotwire 化した形で実装しています。

## 前提

- Ruby 3.3 以上
- Rails 8.0 以上（本リポジトリは Rails 8.1 で動作確認）
- JavaScript は importmap（ビルド工程なし）

## セットアップと起動

```bash
bin/setup            # 依存関係のインストールと DB 準備
bin/rails db:seed    # サンプルデータ（ユーザー・3 プロジェクト・約 150 タスク）
bin/rails server
```

ブラウザで <http://localhost:3000> を開き、次のアカウントでログインします。

- メールアドレス: `alice@example.com`
- パスワード: `password`

（もう一人 `bob@example.com` / `password` も用意してあります。2 つのブラウザで開くと、リアルタイム更新を試せます。）

## テスト

```bash
bin/rails test                         # モデル・統合テスト
bin/rails test test/integration/smoke_test.rb  # 主要ページとフローのスモークテスト
```

## 本書の章との対応

主なファイルと、対応する章は次のとおりです（詳細は本書の付録G）。

| ファイル | 役割 | 章 |
| --- | --- | --- |
| `app/models/task.rb` | 中心リソース。`status` enum、`broadcasts_to` | 第4・5・18章 |
| `app/controllers/tasks_controller.rb` | 検索・ページネーション・Streams・422 | 第8・16・23・24章 |
| `app/views/tasks/_task.html.erb` | タスク1件の表示（frame） | 第12章 |
| `app/views/tasks/_tasks.html.erb` | 一覧領域（空状態分岐） | 第17章 |
| `app/views/tasks/_form.html.erb` | フォーム（a11y 属性） | 第25章 |
| `app/views/tasks/*.turbo_stream.erb` | 部分更新の命令 | 第16・17・24章 |
| `app/javascript/controllers/*` | Stimulus（counter / toast / dropdown / modal / search / infinite-scroll / autofocus） | 第6部・第7部 |
| `app/views/layouts/_flash.html.erb` ほか | フラッシュ・トースト | 第27章 |

## ライセンス

MIT License. Copyright (c) 2026 FjordBootCamp.
