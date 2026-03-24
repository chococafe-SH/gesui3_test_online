---
description: ソースコードのGitHub PushとアーティファクトのNotionバックアップを一度に実行する
---

# /push ワークフロー

このワークフローは、ユーザーからの「push」指示に基づき、開発した最新コードのGitHubへの反映と、全ドキュメント（アーティファクト）のNotionへの完全同期を並行して実行します。

## 実行手順

1. **GitHub Push (Code Sync)**:
    - 変更された全てのファイルを `git add .` でステージングします。
    - 実施した変更を要約したコミットメッセージ（例: `feat: [タスク名] の実装完了`）を自動生成し、`git commit` します。
    - `origin main` (または現在のブランチ) に対して `git push` を実行します。

2. **Notion Full Backup (Document Sync)**:
    - `brain/<conversation-id>/` 内にある全ての `.md` ファイルを確認します。
    - `view_file` で内容を全文取得します。
    - `dual_push_sync` (旧 notion_full_backup) Skillに従い、Notionの「成果物バックアップ」へ**要約せずに**全件書き出します。

3. **完了報告**:
    - GitHubへのPush成功と、NotionページのURLを合わせてユーザーに報告します。
