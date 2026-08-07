# gh-review-pr

GitHub PR の通常レビューを担当する中核スキルです。初回レビュー、修正後の再レビュー、過去指摘の検証を evidence-backed な finding として報告します。

## 概要

PR によって導入または materially affected された、具体的で到達可能な defect / regression を発見することを目的とします。デフォルトは **分析のみ**（ユーザーへの報告）で、GitHub への投稿は行いません。

## いつ使うか

- PR の初回レビュー
- 修正後の再レビュー（re-review after code changes）
- 過去のレビュー指摘が解消されたかの検証
- 前回レビュー後に追加された変更のレビュー
- 一般的な PR コードレビュー

**このスキルに属さない例**（`gh-adversarial-review` へ）:

- adversarial review / red-team review
- assumption falsification / counterexample analysis
- 上記の明確な同義表現

「もう一度レビューして」「修正したので確認して」だけでは adversarial には routing しません。

## 使い方

### 1. スキルの有効化

Cursor のスキル設定で `gh-review-pr/` ディレクトリをスキルとして登録します。

### 2. 前提条件

- GitHub CLI (`gh`) がインストール・ログイン済みであること（ローカル検証や thread 取得が必要な場合）
- 対象 PR のリポジトリへのアクセス権

### 3. プロンプト例

```
この PR をレビューして。
```

```
修正したので再レビューして。前回の指摘が直っているかも確認して。
```

```
PR #123 の変更をレビューして。セキュリティとデータ整合性を重点的に。
```

GitHub へ投稿する場合は **明示的に** 指示します:

```
レビュー結果を GitHub にコメントして。
```

```
P1 の指摘を PR に投稿して、REQUEST_CHANGES で submit して。
```

### 4. エージェントの手順（要約）

1. PR を特定（URL / 番号 / 現在ブランチ）
2. 要件・complete merge-base diff を取得
3. staged に context を広げながら defect を分析（formal finding gate 適用）
4. 必要なら checklist section を最大3つまで参照
5. 狭い範囲の検証（テスト・型チェック等）を実行
6. ユーザーへ報告（明示要求時のみ GitHub 投稿）

再レビュー時は、前回 finding の状態検証と新規変更の確認を **両方** 行います。

## ファイル構成

| ファイル | 内容 |
|----------|------|
| `SKILL.md` | routing、workflow、finding gate、posting policy の全文 |
| `references/review-checklist.md` | ドメイン別レビュー prompt（必要時のみ staged 読み込み） |
| `README.md` | このファイル |

## 関連スキル

| スキル | 役割 |
|--------|------|
| `gh-adversarial-review` | claims / invariants の敵対的 falsification（明示要求時のみ） |
| `gh-address-comments` | レビュー指摘のコード修正 |
| `gh-fix-ci` | CI 失敗の調査・修正 |
| `yeet` | commit / push / PR 公開 |

## 設計上の要点

- **Zero findings は正常な結果** — speculative finding を量産しない
- **Severity（P0–P3）は impact/urgency** — confidence の代替ではない
- **Narrow first, widen on evidence** — リポジトリ全体や checklist 全文は読まない
- **分析と GitHub write は別ステップ** — レビュー依頼だけでは投稿しない
