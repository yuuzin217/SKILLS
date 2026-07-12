# design-md

Google の DESIGN.md フォーマット仕様と CLI を扱うスキルです。

## 概要

デザインシステムを YAML フロントマター + Markdown で表現する `DESIGN.md` 形式の作成・検証・変換を支援します。`@google/design.md` CLI を使った lint / diff / export が可能です。

## いつ使うか

- `DESIGN.md` ファイルを新規作成・編集したい
- デザイントークンの構造を検証したい
- Tailwind や W3C DTCG 形式へエクスポートしたい

## 使い方

### 1. スキルの有効化

Cursor のスキル設定で `design-md/` ディレクトリをスキルとして登録します。

### 2. プロンプト例

```
このプロジェクト用の DESIGN.md を作成して。
```

```
DESIGN.md の構造を lint して、WCAG コントラストも確認して。
```

```
DESIGN.md から Tailwind v4 のテーマ CSS をエクスポートして。
```

### 3. CLI コマンド

```bash
# 構造・コントラスト検証
npx @google/design.md lint DESIGN.md

# 2つの DESIGN.md を比較
npx @google/design.md diff DESIGN.md DESIGN-v2.md

# Tailwind v4 テーマ CSS へエクスポート
npx @google/design.md export --format css-tailwind DESIGN.md > theme.css
```

Windows / PowerShell では `.md` サフィックスの衝突を避けるため:

```powershell
npx -p @google/design.md designmd lint DESIGN.md
```

### 4. ファイル形式

```markdown
---
name: MyDesign
colors:
  primary: "#1A1C1E"
typography:
  body-md:
    fontFamily: Public Sans
    fontSize: 1rem
---

## Overview
...
```

## ファイル構成

| ファイル | 内容 |
|----------|------|
| `SKILL.md` | フォーマット仕様と CLI リファレンス |
| `references/spec.md` | 詳細なフォーマット仕様 |
| `LICENSE` | Apache License 2.0（Google design.md 由来） |
| `README.md` | このファイル |

## 出典・ライセンス

[google/design.md](https://github.com/google/design.md) プロジェクトを基にしています（Apache License 2.0）。

## 関連スキル

- `awesome-design-md` — ブランド別の既成 DESIGN.md コレクション
