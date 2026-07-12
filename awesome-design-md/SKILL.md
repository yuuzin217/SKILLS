---
name: awesome-design-md
description: 実在サイトから抽出した73件以上のブランド別 DESIGN.md コレクションを参照し、指定のデザイン言語に沿った UI を生成・レビューする。ユーザーが「Linear っぽく」「Stripe 風に」「Apple のような UI」などブランドや雰囲気を指定したとき、または DESIGN.md を使った一貫したビジュアル実装を求めたときに使用する。
---

# Awesome DESIGN.md

> [!NOTE]
> このスキルは [VoltAgent/awesome-design-md](https://github.com/VoltAgent/awesome-design-md) プロジェクト（VoltAgent 作）を基にしています。MIT License の下で提供されています。
> ライセンスの全文は [LICENSE](./LICENSE) を参照してください。

実在の開発者向けサイトから抽出した、すぐ使える `DESIGN.md` コレクションです。プロジェクトルートに `DESIGN.md` を置く代わりに、このスキル内の参照ファイルを読み、同じデザイン言語で UI を実装します。

## 使い方

1. ユーザーが求めるブランド・雰囲気・カテゴリを特定する
2. `design-md/<brand>/DESIGN.md` を読み込む
3. トークン（色・タイポグラフィ・余白・コンポーネント）と Do's and Don'ts に従って UI を実装する
4. 必要なら `design-md/<brand>/README.md` で補足情報を確認する

### ブランドの探し方

`design-md/` 配下のディレクトリ名がブランド ID です。主要なもの:

| カテゴリ | ブランド ID の例 |
|----------|------------------|
| AI / LLM | `claude`, `cohere`, `elevenlabs`, `mistral.ai`, `ollama`, `x.ai`, `voltagent` |
| 開発ツール | `cursor`, `expo`, `lovable`, `raycast`, `vercel`, `warp` |
| バックエンド / DevOps | `clickhouse`, `mongodb`, `posthog`, `sentry`, `supabase` |
| 生産性 / SaaS | `cal`, `intercom`, `linear.app`, `notion`, `resend`, `zapier` |
| デザイン / クリエイティブ | `airtable`, `figma`, `framer`, `miro`, `webflow` |
| フィンテック | `binance`, `coinbase`, `kraken`, `revolut`, `stripe`, `wise` |
| Eコマース / 小売 | `airbnb`, `nike`, `shopify`, `starbucks` |
| メディア / コンシューマ | `apple`, `nvidia`, `spotify`, `uber`, `wired` |
| 自動車 | `bmw`, `ferrari`, `lamborghini`, `tesla` |
| レトロ Web | `dell-1996`, `nintendo-2001` |

ブランド名が曖昧な場合は `design-md/` を一覧し、説明文やトークンから最も近いものを選ぶ。

## 各 DESIGN.md の構成

各ファイルは [Stitch DESIGN.md 形式](https://stitch.withgoogle.com/docs/design-md/specification/) に沿っています。

| セクション | 内容 |
|-----------|------|
| Visual Theme & Atmosphere | ムード、密度、設計思想 |
| Color Palette & Roles | セマンティックな色と役割 |
| Typography Rules | フォントファミリーと階層 |
| Component Stylings | ボタン、カード、入力、ナビゲーション |
| Layout Principles | スペーシング、グリッド、余白 |
| Depth & Elevation | シャドウ、サーフェス階層 |
| Do's and Don'ts | 守るべきルールとアンチパターン |
| Responsive Behavior | ブレークポイント、タッチターゲット |
| Agent Prompt Guide | クイックリファレンスとプロンプト例 |

## 実装ガイドライン

1. **トークンを優先する** — ハードコードより `DESIGN.md` の色・フォント・余白トークンを使う
2. **Do's and Don'ts を守る** — アクセント色の乱用、トラッキングの誤用などを避ける
3. **雰囲気を再現する** — 色だけでなく、密度・角丸・タイポグラフィの組み合わせでブランド感を出す
4. **プロジェクトにコピーする場合** — ユーザーが明示的に求めたときのみ、選んだ `DESIGN.md` をプロジェクトルートへコピーする
5. **フォーマット検証** — `design-md` スキルと併用する場合、`npx @google/design.md lint` で構造を検証できる

## 関連スキル

- `design-md` — DESIGN.md フォーマット仕様と CLI（lint / diff / export）

## 注意事項

- 各 `DESIGN.md` は公開サイトから抽出したデザイントークンの分析であり、公式ブランドガイドの代替ではありません
- 商標・ロゴの使用はユーザーの責任で判断してください
