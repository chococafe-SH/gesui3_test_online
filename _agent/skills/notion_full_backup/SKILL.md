---
name: notion_full_backup
description: アーティファクト（task.md, implementation_plan.md, walkthrough.md等）の内容を要約せずにNotionへバックアップするSkill
---

# Notion フル・バックアップ Skill

このSkillは、現在のセッションで作成された成果物（アーティファクト）を、内容を損なうことなく完全にNotionへ同期するためのガイドラインです。

## バックアップ対象
- `brain/<conversation-id>/task.md`
- `brain/<conversation-id>/implementation_plan.md`
- `brain/<conversation-id>/walkthrough.md`
- その他、セッション中に作成された重要なドキュメント（例: `monetization_proposals.md`）

## Notion側の保存先
- データベース名: `成果物バックアップ`
- プロパティ:
    - `Title`: アプリ名やタスクのタイトル
    - `Status`: 完了/進行中など

## 実行フェーズ

### 1. 情報の収集
- `brain/` ディレクトリ配下にある全ての `.md` ファイルをリストアップします。
- 各ファイルの内容を `view_file` ツールで**全文**読み込みます。

### 2. Notionでのページ作成
- `mcp_notion-mcp-server_API-post-page` を使用して、新しいページを作成します。
- ページのタイトルは「[アプリ名] [タスク名]」の形式にします。

### 3. コンテンツの書き込み（重要: 要約禁止）
- Markdownの各要素（見出し、箇条書き、チェックリスト、太字、コールアウト、テーブル）を適切にNotionのブロック形式に変換します。
- **絶対に要約せず、全てのテキストを転記してください。**
- 箇条書きがネスト（入れ子）されている場合は、Notionの `children` プロパティを使用して正しく階層構造を再現してください。
- `patch-block-children` を使用して、初期ページ作成後に残りのコンテンツを追記します。一度のツール呼び出し制限に注意し、必要に応じて複数回に分けて実行してください。

## 注意事項
- NotionのAPI制限により、1回の呼び出しで送信可能なブロック数に上限がある場合があります。大量の文章を転記する際は、セクション（章）ごとに分割して `patch-block-children` を呼び出してください。
- 画像やリンクが含まれる場合は、可能な限りそのままの形で反映を試みます。
