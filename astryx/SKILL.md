---
name: astryx
description: Build and review UIs with Meta's Astryx design system (React 19+, 150+ components, themes, design tokens). Use when a project uses or should adopt Astryx, when choosing Astryx components or page templates instead of hand-rolling UI, or when looking up component APIs, tokens, and theming through the Astryx CLI.
---

# Astryx

> [!NOTE]
> このスキルは [meta/astryx](https://github.com/meta/astryx) プロジェクト（Meta Platforms, Inc.）を基にしたラッパーです。MIT License の下で提供されています。
> ライセンスの全文は [LICENSE](./LICENSE) を参照してください。
> Astryx 本体はこのリポジトリには含めていません。利用時は npm パッケージとして導入します。

Astryx は Meta 社内で 8 年使われ、13,000 以上のアプリを支えたデザインシステムをオープンソース化したものです（2026 年 11 月時点で Beta）。

- 150 以上のアクセシブルな React コンポーネント
- ブランドテーマ（CSS カスタムプロパティの上書きで作る）とダークモード
- ページ／ブロックのテンプレート集
- 人間と AI エージェントが同じ手順で使える CLI（コンポーネント文書・トークン・テンプレート・コードモッドを JSON でも取得可能）

推測でコンポーネント名や props を書かず、必ず CLI で実物のドキュメントを引いてから実装するのがこのスキルの要点です。

## 前提

- **React 19 以降**が必須（`react` / `react-dom` が `@astryxdesign/core` の peer dependency）
- スタイルは StyleX で書かれているが、利用側は意識しなくてよい。`className` の上書きは Tailwind / CSS Modules / 素の CSS のどれでも可
- ビルドプラグインや PostCSS / Babel 設定は不要（ビルド済み CSS と JS が同梱される）

## 導入

```bash
# 本体 + テーマ + peer dependency
npm install @astryxdesign/core @astryxdesign/theme-neutral @stylexjs/stylex
# CLI（開発用）
npm install -D @astryxdesign/cli

# pnpm の場合
pnpm add @astryxdesign/core @astryxdesign/theme-neutral @stylexjs/stylex
pnpm add -D @astryxdesign/cli
```

> [!WARNING]
> `npx` で呼ぶときは必ずスコープ付きの `@astryxdesign/cli` を使うこと。CLI がプロジェクト依存に入っていない状態で無印の `astryx` を引くと、無関係な別 npm パッケージが解決されてしまう。導入後は `pnpm exec astryx ...` のようなランナー経由の短い名前でよい。
> CLI をマシン全体に入れる方法もある（`npm i -g @astryxdesign/cli`）。プロジェクト内ではそのプロジェクト自身のバージョンが優先される。使い分けは `astryx docs global/project-global-or-both` を参照。

プロジェクトへの初期化（エージェント向けに重要）:

```bash
npx @astryxdesign/cli init
```

`init` はコンポーネント索引をプロジェクトの `AGENTS.md` / `CLAUDE.md` に書き込み、エージェントがコンポーネント・テンプレート・トークンを推測ではなく索引から探せるようにします。

`package.json` にスクリプトを足しておくと、エージェントや新規参加者がパスで迷いません:

```json
"scripts": {
  "astryx": "node node_modules/@astryxdesign/cli/clients/cli/bin/astryx.mjs"
}
```

### 最小セットアップ（Next.js の例）

CSS の import 順がカスケードレイヤーに対応するため、順序を守ること:

```css
/* globals.css */
@import '@astryxdesign/core/reset.css';
@import '@astryxdesign/core/astryx.css';
@import '@astryxdesign/theme-neutral/theme.css';
```

アプリをテーマプロバイダで包む:

```tsx
'use client';

import Link from 'next/link';
import {Theme} from '@astryxdesign/core/theme';
import {LinkProvider} from '@astryxdesign/core/Link';
import {neutralTheme} from '@astryxdesign/theme-neutral/built';

export function Providers({children}: {children: React.ReactNode}) {
  return (
    <Theme theme={neutralTheme}>
      <LinkProvider component={Link}>{children}</LinkProvider>
    </Theme>
  );
}
```

Vite / Tailwind 併用など他の構成は公式ドキュメント（`astryx docs` 配下と core の README）を確認すること。

## エージェントの作業手順

1. **まず探す** — 欲しいものがコンポーネントか hook かテンプレートか分からない段階では、横断検索する
   ```bash
   astryx search button
   astryx search <キーワード> --type component --json
   ```
2. **コンポーネントは実ドキュメントを読む** — API（props、variant、使用例、ベストプラクティス、テーマ方法）は記憶で書かない
   ```bash
   astryx component --list      # 全コンポーネント一覧
   astryx component Button      # 個別の完全なドキュメント
   astryx hook <名前>           # hook のドキュメント
   ```
3. **ページ単位ならテンプレートから始める** — ゼロから組まず、既成のページパターン（ダッシュボード、設定、フォーム、詳細ページ等）を土台にする。テンプレートは中身のみで、全体のナビゲーション（AppShell、TopNav、SideNav）は自前で包む
   ```bash
   astryx template --list
   astryx template dashboard
   astryx template settings --skeleton   # 空間注釈付きの骨組み
   ```
4. **トークンとテーマは docs で引く**
   ```bash
   astryx docs            # トピック一覧（原則、トークン、テーマ、レイアウト等）
   astryx docs tokens     # 余白・色・角丸・タイポグラフィのトークン参照
   astryx docs theme      # テーマの作り方（Theme、defineTheme、ライト/ダーク）
   ```
5. **カスタマイズはテーマ → swizzle の順** — まず CSS カスタムプロパティの上書き（テーマ）で済ませ、足りない場合だけコンポーネントのソースを取り込む
   ```bash
   astryx theme build       # 本番用テーマ CSS のビルド
   astryx swizzle Button    # コンポーネントのソースを自プロジェクトへ展開（プロジェクト内でのみ実行可）
   ```
6. **バージョンアップ時はコードモッドを使う**
   ```bash
   astryx upgrade --apply   # アップグレード用コードモッドの適用
   astryx doctor            # プロジェクト／連携パッケージの診断
   ```

CLI の仕様そのものも CLI で引けます。Beta の間はバージョン差があり得るので、手元のバージョンの出力が正です:

```bash
astryx manifest --json     # 全コマンド・オプション・応答型の JSON 定義
astryx docs cli            # CLI 自身のドキュメントツリー
astryx <コマンド> --help
```

ほぼ全コマンドが `--json` に対応し、型付きエンベロープ（`{apiVersion, type, data}`、エラー時は `{apiVersion, error, code, suggestions?}`）で返ります。エージェントが機械処理するときは `--json` を優先すること。

## コマンド早見表

| コマンド | 用途 |
|---|---|
| `search` | コンポーネント / hook / docs / テンプレート / テーマの横断検索 |
| `component` | コンポーネント一覧と個別ドキュメント |
| `hook` | hook 一覧と個別ドキュメント |
| `template` | ページ／ブロックテンプレートの一覧・表示・生成 |
| `docs` | 原則・トークン・テーマなどのリファレンス文書 |
| `build` | ページ構築の開始点（テンプレート）やワークフロー手順の提示 |
| `init` | プロジェクトへの初期化（`AGENTS.md` / `CLAUDE.md` へ索引を書く） |
| `theme` | テーマの追加・切替・ビルド・作成 |
| `swizzle` | カスタマイズ用にコンポーネントソースを取り込む |
| `upgrade` | バージョンアップ時のコードモッド適用 |
| `doctor` | プロジェクトの診断 |
| `discover` | 外部の Astryx 連携パッケージの探索 |
| `gap-report` | 不足しているコンポーネント／機能の報告 |
| `manifest` | CLI 全体の定義を JSON で出力 |

## テーマ

- 既成テーマは 7 種: neutral、butter、chocolate、matcha、stone、gothic、y2k（パッケージ名は `@astryxdesign/theme-*`）
- テーマの実体は CSS カスタムプロパティの上書き集合。コンポーネントを fork したりラップしたりせずにブランドに寄せられる
- 独自テーマの作り方は `astryx docs theme` と `astryx theme` コマンド群を参照

## 注意点

- **Beta である**: API や CLI が変わり得る。前提を置く前に `astryx manifest --json` / `astryx docs` で手元のバージョンの仕様を確認する
- **実験的パッケージに注意**: `@astryxdesign/lab` は npm 未公開。`@astryxdesign/vega`（チャート連携）と `@astryxdesign/charts` は `@canary` タグのみで安定版はまだない
- **命名・props の規約が全コンポーネントで統一**されている。数個覚えれば残りも予測できる設計なので、既存コンポーネントの使い方を踏襲すること
- コンポーネントは「強制より案内」の方針で、渡した値はそのまま描画される。見た目の正しさはドキュメントと使用例側で担保する

## 出典

- リポジトリ: https://github.com/meta/astryx
- ドキュメント: https://astryx.atmeta.com
- Storybook: https://astryx.atmeta.com/storybook/
- 紹介投稿（X）: https://x.com/awe0_io/status/2119354093458395284
