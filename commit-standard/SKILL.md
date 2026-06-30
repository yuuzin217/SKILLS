---
name: commit-standard
description: Enforce Google-style Conventional Commits. Message must start with a type (feat, fix, etc.) and a summary in the imperative mood (e.g., 'add', 'fix').
---

# Commit Standard Skill (Google-style Conventional Commits)

あなたはコミットメッセージの作成において、GoogleのエンジニアリングプラクティスとConventional Commitsを融合させた**GoogleスタイルのConventional Commits**を厳格に適用するスペシャリストです。

コミットメッセージを生成またはレビューする際は、以下のルールに従ってください。

---

## 1. コミットメッセージの構造

メッセージは以下の構造に従います。1行目の要約（Subject）と本文（Body）の間には必ず1行の空行を挟んでください。

```
<type>(<scope>): <subject>

<body>
```

---

## 2. 各要素のルール

### ① `<type>` (必須)
変更の種類を表す以下のいずれかのタグを使用します。

| Type | 意味 |
| :--- | :--- |
| `feat` | 新機能の追加 |
| `fix` | バグ修正 |
| `docs` | ドキュメントのみの変更・更新 |
| `style` | コードの意味に影響を与えない変更（フォーマット、空白、セミコロンの追加など） |
| `refactor` | リファクタリング（機能追加やバグ修正を行わないコード変更） |
| `perf` | パフォーマンス向上を目的としたコード変更 |
| `test` | テストの追加や既存テストの修正 |
| `chore` | ビルドプロセス、補助ツール、ライブラリ依存関係の更新など |

### ② `<scope>` (任意)
変更の影響範囲（モジュール名、機能名、ファイル名など）を括弧内に小文字で記述します。
* 例: `feat(auth): ...`, `fix(parser): ...`

### ③ `<subject>` (必須 - 1行目の要約)
* **必ず英語の「命令形（Imperative mood）」の動詞の原形で始める**。
  * 「このコミットを適用すると、コードベースにどのような命令を実行するか」という形で書きます。
  * ❌ 過去形 (`added`, `fixed`) や三人称単数現在形 (`adds`, `fixes`) は**絶対に使用しない**。
  * ⭕ 良い例: `add`, `fix`, `update`, `remove`, `refactor`
* **最初の文字は小文字**で始める（Conventional Commitsの標準的な推奨）。
* **末尾にピリオド（`.`）を付けない**。
* 全体で50文字程度に収まるよう簡潔に書く。

### ④ `<body>` (任意ですが、重要な変更では強く推奨)
* **「何をしたか（What）」ではなく、「なぜしたか（Why）」とその背景・理由**を記述します。
* 言語は**日本語または英語**とします（プロジェクトの主要開発者に合わせる）。
* 変更の動機、移行の背景、未解決の課題（TODO）などを簡潔に説明します。

---

## 3. 具体的なコミットメッセージの例

### ⭕ 良い例（Good）
* `feat(auth): add google oauth login`
* `fix(api): resolve null pointer exception in user retrieval`
* `docs: update installation instructions in readme`
* `refactor(utils): simplify date formatting logic`
* ```
  fix(database): increase connection pool timeout
  
  The application frequently timed out under high traffic. This change
  increases the timeout from 5s to 15s to prevent connection drops.
  ```

### ❌ 避けるべき例（Bad）
* `feat: added google login` (過去形 `added` を使用しているためNG。正しくは `add`)
* `Fix bugs` (プレフィックスがない、かつ大文字開始・命令形ではあるが具体性がないためNG)
* `docs: Updated README.` (過去形 `Updated` の使用、大文字開始、末尾のピリオドがあるためNG。正しくは `update README`)
