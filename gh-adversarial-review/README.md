# gh-adversarial-review

GitHub PR の敵対的検証（adversarial verification）スキルです。PR 本文、実装、テスト、通常レビューの結論が前提とする claims / invariants を、現実的な counterexample で falsify できるか試します。

## 概要

通常レビュー（defect hunt）ではなく、**前提の破綻**を探します。デフォルトは **分析のみ**（ユーザーへの報告）で、GitHub への投稿は明示要求時のみです。

通常は **通常レビュー完了後の second-pass** として使います。adversarial-only 分析は、包括的 PR レビューではないことを明示した上で、ユーザーの明示要求がある場合のみ実行します。

## いつ使うか

**明示的に以下を求められた場合のみ:**

- adversarial review
- red-team review
- assumption falsification
- counterexample analysis
- 上記の明確な同義表現

**このスキルに属さない例**（`gh-review-pr` へ）:

- 初回 PR レビュー
- 修正後の通常再レビュー
- 「前の指摘は直った？」の検証
- 「もう一度レビューして」だけの依頼

## 使い方

### 1. スキルの有効化

Cursor のスキル設定で `gh-adversarial-review/` ディレクトリをスキルとして登録します。

### 2. 前提条件

- 通常レビュー（会話内または PR 履歴）が完了していることが望ましい
- 通常レビューがない場合は `gh-review-pr` の分析 workflow を prerequisite として実行
- PR 解決・diff 取得・`gh` 認証は `gh-review-pr` の手順に従う

### 3. プロンプト例

```
この PR を adversarial review して。PR の前提が counterexample で破れないか確認して。
```

```
red-team 的に、認可と idempotency の invariant を falsify できるか試して。
```

```
通常レビュー後の second-pass として、assumption falsification を実行して。
```

adversarial-only（通常レビューなし）:

```
adversarial-only で分析して。包括的 PR レビューではないことは承知しています。
```

### 4. エージェントの手順（要約）

1. claims / invariants を特定（prior review → PR/issue text → tests）
2. 各 claim が依存する path を trace
3. adversarial checklist から最大3 section を選択
4. 到達可能な counterexample を構築し、defeating guard を探索
5. 狭い検証を実行
6. `confirmed` / `strongly supported` のみ formal finding として報告
7. 残りは Unverified / Disproved / Residual risk に分類

## ファイル構成

| ファイル | 内容 |
|----------|------|
| `SKILL.md` | routing、workflow、finding gates、posting policy の全文 |
| `references/adversarial-checklist.md` | falsification prompt（必要時のみ staged 読み込み） |
| `README.md` | このファイル |

## 関連スキル

| スキル | 役割 |
|--------|------|
| `gh-review-pr` | 通常レビュー（initial / re-review / prior-feedback verification） |
| `gh-address-comments` | レビュー指摘のコード修正 |
| `gh-fix-ci` | CI 失敗の調査・修正 |
| `yeet` | commit / push / PR 公開 |

## gh-review-pr との境界

| 観点 | gh-review-pr | gh-adversarial-review |
|------|--------------|----------------------|
| 目的 | concrete defect / regression の発見 | claims / invariants の falsification |
| トリガー | 一般的なレビュー依頼 | 明示的な adversarial 依頼 |
| Finding 分類 | formal finding / unsupported hypothesis / residual risk | confirmed / strongly supported / plausible but unverified / disproved / out of scope |
| Checklist | defect 検出 prompt | counterexample 構築 prompt |
| 典型タイミング | 初回・再レビュー | 通常レビュー後の second-pass |

## 設計上の要点

- **Seek falsification, not confirmation** — PR 本文・green CI・テストも claim として扱う
- **Zero formal findings は正常な結果**
- **≤3 checklist sections** — 全文 mechanical scan はしない
- **GitHub 投稿は formal findings のみ** — `plausible but unverified` 等は投稿しない
