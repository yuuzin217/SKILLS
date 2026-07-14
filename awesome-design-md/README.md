# awesome-design-md

実在サイト由来のブランド別 DESIGN.md コレクション（74 ブランド）を参照するスキルです。

## 概要

Linear、Stripe、Vercel、Notion、Apple など、開発者向けサイトから抽出したデザインシステムを `DESIGN.md` 形式で収録しています。ブランドの雰囲気に沿った UI を生成・レビューする際に参照します。

## いつ使うか

- 「Linear っぽい UI」「Stripe 風に」などブランド指定がある
- 一貫したビジュアル言語で UI を実装したい
- 既存のデザインシステムを参考にしたい

## 使い方

### 1. スキルの有効化

Cursor のスキル設定で `awesome-design-md/` ディレクトリをスキルとして登録します。

### 2. プロンプト例

```
Linear っぽいダッシュボードを作って。
```

```
Stripe のデザイン言語に沿ったランディングページを実装して。
```

```
design-md/vercel/DESIGN.md を参照して、このコンポーネントを Vercel 風にリデザインして。
```

```
Notion 風の UI に合わせて、色とタイポグラフィを調整して。
```

### 3. ブランドファイルの参照方法

1. ブランド ID を特定（例: `linear.app`, `stripe`, `vercel`）
2. `design-md/<brand>/DESIGN.md` を読み込む
3. トークン（色・タイポグラフィ・余白）と Do's and Don'ts に従って実装

### 4. 主要ブランド一覧

| カテゴリ | ブランド ID |
|----------|-------------|
| AI / LLM | `claude`, `mistral.ai`, `ollama`, `x.ai` |
| 開発ツール | `cursor`, `vercel`, `raycast`, `warp` |
| SaaS | `linear.app`, `notion`, `intercom`, `zapier` |
| フィンテック | `stripe`, `coinbase`, `revolut`, `wise` |
| 自動車 | `tesla`, `bmw`, `ferrari` |
| レトロ Web | `dell-1996`, `nintendo-2001` |

全 74 ブランドは `design-md/` ディレクトリを一覧してください。

### 5. プロジェクトへのコピー

ユーザーが明示的に求めた場合のみ、選んだ `DESIGN.md` をプロジェクトルートへコピーします。

## ファイル構成

| ファイル / ディレクトリ | 内容 |
|-------------------------|------|
| `SKILL.md` | 利用ガイド |
| `design-md/<brand>/DESIGN.md` | 各ブランドのデザインシステム |
| `design-md/<brand>/README.md` | ブランドの補足情報 |
| `LICENSE` | MIT License（VoltAgent 由来） |
| `README.md` | このファイル |

## 出典・ライセンス

[VoltAgent/awesome-design-md](https://github.com/VoltAgent/awesome-design-md) プロジェクトを基にしています（MIT License）。

## 関連スキル

- `design-md` — DESIGN.md フォーマット仕様と CLI

## 注意事項

- 各 `DESIGN.md` は公開サイトの分析であり、公式ブランドガイドの代替ではありません
- 商標・ロゴの使用はユーザーの責任で判断してください
