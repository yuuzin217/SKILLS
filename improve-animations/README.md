# improve-animations

コードベース全体のアニメーションを監査し、実行可能な改善プランを生成するスキルです。

## 概要

シニアモーションアドバイザーとしてコードベースを調査し、優先度付きの監査結果と、他のエージェント（安価なモデル含む）が実行できる自己完結型の実装プランを `plans/` に出力します。**ソースコードは変更しません**（計画のみ）。

## いつ使うか

- 「アニメーションを改善して」とコードベース全体を見てほしい
- モーション監査と改善ロードマップが欲しい
- 単一 diff のレビューではなく、体系的な改善計画が必要

## 使い方

### 1. スキルの有効化

Cursor のスキル設定で `improve-animations/` ディレクトリをスキルとして登録します。

### 2. プロンプト例

```
このコードベースのアニメーションを改善して。
```

```
improve-animations quick
```

```
improve-animations performance
```

```
improve-animations plan add press feedback to all buttons
```

```
improve-animations execute plans/001-fix-dropdown-easing.md
```

### 3. ワークフロー

| フェーズ | 内容 |
|----------|------|
| Phase 1: Recon | モーションスタック・ライブラリ・規約を調査 |
| Phase 2: Audit | 8 カテゴリで監査（[AUDIT.md](./AUDIT.md) 参照） |
| Phase 3: Vet | 発見事項を検証・優先度付け、ユーザーに選択を確認 |
| Phase 4: Plans | 選択された項目ごとに [PLAN-TEMPLATE.md](./PLAN-TEMPLATE.md) 形式でプラン作成 |

### 4. 監査カテゴリ

1. Purpose & frequency（目的と頻度）
2. Easing & duration（イージングと時間）
3. Physicality & origin（物理性と起点）
4. Interruptibility（割り込み可能性）
5. Performance（パフォーマンス）
6. Accessibility（アクセシビリティ）
7. Cohesion & tokens（一貫性とトークン）
8. Missed opportunities（見逃した機会）

### 5. 実行レベル

| レベル | カバレッジ |
|--------|-----------|
| `quick` | 高トラフィックコンポーネントのみ |
| `standard`（デフォルト） | 全インタラクティブ UI |
| `deep` | マーケティングページ含む全体 |

### 6. 重要な制約

- **ソースコードは変更しない** — `plans/` 配下のファイルのみ作成・編集
- プランは自己完結型（正確な cubic-bezier、duration、ファイルパスをインライン記載）

## ファイル構成

| ファイル | 内容 |
|----------|------|
| `SKILL.md` | 監査・プラン生成ワークフロー |
| `AUDIT.md` | 監査ルールカタログ |
| `PLAN-TEMPLATE.md` | 実装プランのテンプレート |
| `LICENSE` | MIT License（Emil Kowalski 由来） |
| `README.md` | このファイル |

## 出典・ライセンス

[emilkowalski/skills](https://github.com/emilkowalski/skills) プロジェクトを基にしています（MIT License）。

## 関連スキル

- `review-animations` — 単一 diff のアニメーションレビュー（`execute` 時の検証にも使用）
- `emil-design-eng` — デザインエンジニアリング哲学
