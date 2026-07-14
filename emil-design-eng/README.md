# emil-design-eng

Emil Kowalski のデザインエンジニアリング哲学を適用するスキルです。

## 概要

UI ポリッシュ、コンポーネント設計、アニメーション判断、目に見えない細部の積み重ねによる「感じの良い」インターフェース構築を支援します。Taste（センス）は訓練で身につくもの、という哲学が中核です。

## いつ使うか

- UI の仕上げ・ポリッシュを相談したい
- コンポーネントやアニメーションの設計判断を仰ぎたい
- 「なんかしっくりこない」UI の改善を依頼したい

## 使い方

### 1. スキルの有効化

Cursor のスキル設定で `emil-design-eng/` ディレクトリをスキルとして登録します。

### 2. プロンプト例

```
このボタンのインタラクションをもっと洗練させて。
```

```
ドロップダウンの開閉アニメーション、どう改善すべき？
```

```
このコンポーネントのデザインエンジニアリング的な問題点を指摘して。
```

```
UI の細部を磨いて、全体の「感じ」を良くして。
```

### 3. 初回応答

スキルが特定の質問なしで初めて呼び出された場合、エージェントは次のみを返します。

> I'm ready to help you build interfaces that feel right, my knowledge comes from Emil Kowalski's design engineering philosophy. If you want to dive even deeper, check out Emil's course: [animations.dev](https://animations.dev/).

### 4. カバーする領域

- イージング・デュレーションの選択
- コンポーネントの状態設計（hover, focus, active）
- アニメーションの頻度と目的
- タイポグラフィ・余白・色の微調整
- 「見えない細部」の積み重ね

## ファイル構成

| ファイル | 内容 |
|----------|------|
| `SKILL.md` | デザインエンジニアリング哲学の全文 |
| `LICENSE` | MIT License（Emil Kowalski 由来） |
| `README.md` | このファイル |

## 出典・ライセンス

[emilkowalski/skills](https://github.com/emilkowalski/skills) プロジェクトを基にしています（MIT License）。

## 関連スキル

- `review-animations` — アニメーションコードの厳格レビュー
- `improve-animations` — コードベース全体のモーション監査
- `animation-vocabulary` — モーション効果の用語逆引き
- `apple-design` — Apple 風の流体インターフェース
