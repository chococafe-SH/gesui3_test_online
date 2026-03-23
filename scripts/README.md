# Firestore 一括インポートツール マニュアル

このディレクトリには、CSVまたはJSONファイルから Google Cloud Firestore にクイズ問題を一括投入するための Python スクリプトが含まれています。

## 構成ファイル
- `import_questions.py`: インポート実行用スクリプト
- `questions_template.csv`: インポート用データのテンプレート（CSV）

## 準備

### 1. Python のセットアップ
Python がインストールされている環境で、以下のコマンドを実行して必要なライブラリをインストールしてください。
```bash
pip install firebase-admin
```

### 2. Firebase サービスアカウント鍵の取得
スクリプトが Firestore にアクセスするために「サービスアカウント鍵」が必要です。
1. [Firebase Console](https://console.firebase.google.com/) にアクセスします。
2. 左上の「プロジェクトの設定 (歯車アイコン)」をクリックします。
3. 「サービスアカウント」タブを開きます。
4. 「新しい秘密鍵の生成」ボタンをクリックします。
5. ダウンロードされた JSON ファイルの名前を `service-account.json` に変更し、この `scripts` フォルダ内に配置してください。
   * **注意**: このファイルは機密情報です。絶対に Git 等で公開しないでください。

## 使い方

### CSV からインポートする場合
`questions_template.csv` をコピーして新しいデータを作成し、以下のコマンドを実行します。
```bash
python import_questions.py --file your_data.csv --key service-account.json
```
* **オプション設定**: `options` フィールドは各選択肢をセミコロン（`;`）で区切って入力してください。

### JSON からインポートする場合
アプリの `assets/questions.json` と同じ形式のファイルからインポートできます。
```bash
python import_questions.py --file your_data.json --key service-account.json
```

## 注意事項
- **IDの指定**: CSVの `id` 列を空にした場合、Firestore 側で自動的にランダムな ID が割り振られます。
- **上書き**: 同じ ID を持つドキュメントが既に存在する場合、内容は上書きされます。
