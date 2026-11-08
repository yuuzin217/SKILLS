# astryx

Meta のオープンソース・デザインシステム **Astryx** を、AI エージェントと一緒に使うためのラッパースキルです。

## 概要

Astryx は Meta 社内で 8 年使われ、13,000 以上のアプリを支えたデザインシステムをオープンソース化したものです（MIT License、2026 年 11 月時点で Beta）。

- React 19+ / StyleX ベース、150 以上のコンポーネント
- 7 種の既成テーマと、CSS カスタムプロパティによる独自テーマ
- エージェントがコンポーネント文書・トークン・テンプレートを引ける CLI（`@astryxdesign/cli`、JSON 出力対応）

上流には Agent Skills 形式の `SKILL.md` が存在しないため、本体をコピーするのではなく、導入と CLI の使い方をまとめたラッパーとしてこのフォルダに置いています（`design-md` と同じ方式）。

## いつ使うか

- Astryx を採用している／採用したい React プロジェクトで UI を実装・レビューするとき
- コンポーネントやページテンプレートを手書きせず Astryx の既成部品で組みたいとき
- コンポーネント API、デザイントークン、テーマの作り方を CLI で正確に引きたいとき

## 使い方

### 1. スキルの有効化

スキルの設定で `astryx/` ディレクトリをスキルとして登録します（`setup-global-skills.sh` でも一括登録できます）。

### 2. プロンプト例

```
この画面、Astryx のテンプレートを土台に作って。コンポーネントの props は CLI で確認してから使って。
```

```
Astryx のトークンに合わせて、このページの余白と色を整えて。
```

```
テーマを neutral から独自ブランドに寄せたい。テーマの上書きで作って。
```

### 3. 主要コマンド

```bash
# 導入（本体 + テーマ + CLI）
npm install @astryxdesign/core @astryxdesign/theme-neutral @stylexjs/stylex
npm install -D @astryxdesign/cli

# 初期化（AGENTS.md / CLAUDE.md にコンポーネント索引を書き込む）
npx @astryxdesign/cli init

# 横断検索 / コンポーネント文書 / テンプレート
npx @astryxdesign/cli search button
npx @astryxdesign/cli component Button
npx @astryxdesign/cli template --list

# トークン・テーマの参照
npx @astryxdesign/cli docs tokens
npx @astryxdesign/cli docs theme
```

注意: `npx` では必ずスコープ付き `@astryxdesign/cli` を使うこと（無印の `astryx` は無関係な別パッケージに解決される場合がある）。詳細は `SKILL.md` を参照。

## ファイル構成

| ファイル | 内容 |
|----------|------|
| `SKILL.md` | 導入手順、エージェントの作業手順、コマンド早見表、注意点 |
| `LICENSE` | MIT License（meta/astryx 由来） |
| `README.md` | このファイル |

## 出典・ライセンス

[meta/astryx](https://github.com/meta/astryx) プロジェクト（Meta Platforms, Inc.）を基にしています（MIT License）。

- ドキュメント: https://astryx.atmeta.com
- Storybook: https://astryx.atmeta.com/storybook/
- 紹介投稿（X、@awe0_io、2026-11-08）: https://x.com/awe0_io/status/2119354093458395284

## 関連スキル

- `design-md` — DESIGN.md 形式（Google）の仕様と CLI
- `awesome-design-md` — ブランド別の DESIGN.md コレクション
- `emil-design-eng` / `apple-design` — UI デザイン判断のスキル
- `pick-ui-library` — UI ライブラリ選定
