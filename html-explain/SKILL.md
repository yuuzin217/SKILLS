---
name: html-explain
description: >-
  Explains code, architecture, and design decisions as self-contained HTML
  documents instead of Markdown. Use when the user asks for HTML explanations,
  HTML docs, browser-viewable design notes, architecture write-ups as .html,
  or prefers HTML over Markdown for technical explanations.
---

# HTML Explain

コード・設計・アーキテクチャの説明を **Markdown ではなく HTML ファイル** として出力する。

## When to use

- 「HTML で説明して」「md じゃなくて html で」
- コード解説・設計メモ・アーキテクチャ説明をブラウザで読みたいとき
- レビューや引き継ぎ用の単体ドキュメントを作りたいとき

## Hard rules

1. **主成果物は `.html` ファイル**。チャットに Markdown の本文説明を長々と書かない。
2. **自己完結**にする（外部 CSS/JS への必須依存を避ける。CDN を使う場合はオフラインでも本文が読めること）。
3. チャット返信は短く、**ファイルパス・開き方・要約 1〜3 行**に留める。
4. 既存の `.html` を更新する依頼なら上書き／追記方針を明示してから書く。
5. 機密（`.env` の値、トークン、個人情報）を HTML に埋め込まない。
6. **ソース由来・ユーザー由来のテキストはすべてエスケープ**する（コードブロックに限らない）。詳細は「Escaping」。

## Output location

優先順:

1. ユーザー指定のパス
2. ワークスペース内の説明用ディレクトリ（例: `docs/`, `explanations/`）があればそこ
3. なければワークスペース直下、または対象コードに近い `docs/` を新規作成

ファイル名:

- `explain-<topic>-<YYYY-MM-DD>.html`、または内容が明確なら `<topic>.html`
- topic は英小文字・ハイフン（例: `auth-flow`, `payment-retry`）

## Workflow

1. **対象を特定** — ファイル／モジュール／設計テーマと、読者（自分／チーム／新人）を把握する。
2. **構成を決める** — 下記「Document structure」に沿う。不要な節は省く。
3. **[template.html](template.html) を土台に** HTML を書く（見た目を崩さず中身だけ差し替える）。
4. **コードは実在箇所に基づく** — 推測で偽の API／パスを書かない。引用は短く、ファイルパスを添える。
5. **書き出し後** — パスを伝え、必要なら `file://` またはローカルサーバでの開き方を一言添える。

## Document structure

必須:

| 節 | 役割 |
|----|------|
| タイトル＋要約 | 何の説明か、1〜2 文 |
| 前提 / スコープ | 対象外も短く |
| 本体 | フロー・責務・設計判断 |
| 参照 | 関連ファイルパス |

状況に応じて追加:

- シーケンス / データフロー（図または番号付き手順）
- 主要型・API・境界
- トレードオフと却下案
- 注意点・落とし穴
- 次のアクション

## Escaping

解析対象・ユーザー入力・パス・型名・表セルなど、**HTML に埋め込むすべてのテキスト**をエスケープする。コードブロックだけのエスケープでは不十分（例: タイトルや表の `Foo<Bar>` がタグとして解釈される）。

テキストノード（`<title>`、見出し、段落、`<code>`、表、参照パスなど）:

| 文字 | エスケープ |
|------|------------|
| `&` | `&amp;` |
| `<` | `&lt;` |
| `>` | `&gt;` |

属性値（`href`, `title`, `aria-*` など）では上記に加え `"` → `&quot;`（必要なら `'` → `&#39;`）。生のユーザー／ソース文字列を属性に入れない。ソース由来テキストを HTML として解釈・挿入しない。

## HTML / CSS conventions

- 言語: `lang="ja"`（英語ドキュメント明示時のみ `en`）
- セマンティクス: `header`, `main`, `section`, `nav`（目次）、`article`
- 見出し階層を飛ばさない（`h1` → `h2` → `h3`）
- コードは `<pre><code class="language-xxx">`。内容も「Escaping」に従う
- インラインコードは `<code>`（中身もエスケープ）
- 図は ASCII / 表 / シンプルな SVG。複雑な図が必要なら短い説明＋箇条書きを優先
- 印刷・長文閲覧を想定し、行長はおおよそ 65–85 文字相当の max-width
- 色・余白は template の CSS 変数を使う。勝手に紫グラデや過剰なグローを足さない
- 目次の `position: sticky` はデスクトップ幅のみ（template の `min-width: 960px` 内）。モバイルでは固定しない
- 参照パスなど長いインラインコードは折り返し可能にする（`nowrap` 禁止）

## Writing style (content)

- 「何をしているか」より **なぜそうなっているか** を厚くする
- 曖昧語（適切に、など）を避け、制約・失敗モード・代替案を具体的に書く
- チャット用の口調ルールがあっても、**HTML 本文は標準的な技術日本語**（丁寧語可、方言は使わない）
- コードコメントを HTML 内に載せる場合も日本語で、意図（Why）を書く

## Anti-patterns

- Markdown を書いて「HTML に変換してください」で終わる
- チャットに全文を貼り、ファイルを作らない
- 巨大なソースを丸ごと貼る
- フレームワークの教示だけで、対象リポジトリ固有の話がない
- 外部ビルド（React アプリ化など）を勝手に要求する — 単体 HTML が既定

## Quality checklist

- [ ] `.html` が保存され、単体でブラウザ表示できる
- [ ] タイトル・要約・スコープ・参照パスがある
- [ ] ソース由来テキスト（タイトル・表・インラインコード・属性値含む）がエスケープされている
- [ ] チャットは短く、パスが明示されている
- [ ] 機密情報が含まれていない
- [ ] 狭い画面で目次が本文を遮蔽せず、長いパスが横スクロールを起こさない

## Additional resources

- 見た目と骨組みの共通土台: [template.html](template.html)
