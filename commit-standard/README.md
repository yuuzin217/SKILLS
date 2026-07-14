# commit-standard

Google スタイルの Conventional Commits を適用するコミットメッセージスキルです。

## 概要

コミットメッセージの作成・レビュー時に、`<type>(<scope>): <subject>` 形式と命令形の要約を厳格に適用します。

## いつ使うか

- コミットメッセージを生成してほしい
- 既存のコミットメッセージをレビューしてほしい
- プロジェクトのコミット規約を統一したい

## 使い方

### 1. スキルの有効化

Cursor のスキル設定で `commit-standard/` ディレクトリをスキルとして登録します。

### 2. プロンプト例

```
今の変更内容に合ったコミットメッセージを作って。
```

```
このコミットメッセージは規約に沿っている？レビューして。
```

```
feat と fix のどちらが適切か判断して、コミットメッセージを提案して。
```

### 3. メッセージ形式

```
<type>(<scope>): <subject>

<body>
```

| type | 用途 |
|------|------|
| `feat` | 新機能 |
| `fix` | バグ修正 |
| `docs` | ドキュメントのみ |
| `refactor` | リファクタリング |
| `test` | テスト |
| `chore` | ビルド・依存関係など |

**subject のルール:** 英語の命令形（`add`, `fix`）、小文字始まり、末尾にピリオドなし。

### 4. 良い例

```
feat(auth): add google oauth login
fix(api): resolve null pointer exception in user retrieval
refactor(utils): simplify date formatting logic
```

## ファイル構成

| ファイル | 内容 |
|----------|------|
| `SKILL.md` | コミット規約の全文 |
| `README.md` | このファイル |

## 関連スキル

- `git-workflow` — コミットから PR 作成までの一連の Git 操作
