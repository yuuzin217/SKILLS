# SKILLS

ChatGPT と Codex で再利用できる Agent Skills のコレクションです。

## `gh-review-pr`

GitHub Pull Request の初回レビューと再レビューを行い、根拠のあるインラインコメントと総評を準備します。レビューの投稿、Approve、Request changes は、対象と内容を提示したうえでユーザーが明示的に確認した場合だけ実行します。

Skill の実体は次の場所にあります。

```text
plugins/gh-review-pr/skills/gh-review-pr/
├── SKILL.md
└── agents/
    └── openai.yaml
```

`gh-address-comments`、`gh-fix-ci`、`yeet` など、特定の別 Skill は必須ではありません。利用可能な場合だけ関連作業へ引き継ぎ、存在しない環境では利用可能な GitHub Connector または `gh` CLI を使います。

### Codex に Skill 単体でインストール

Codex で `$skill-installer` を呼び出し、次の GitHub パスを指定します。

```text
https://github.com/yuuzin217/SKILLS/tree/main/plugins/gh-review-pr/skills/gh-review-pr
```

手動で配置する場合は、`gh-review-pr` ディレクトリをユーザー Skill の場所へコピーします。

```text
~/.agents/skills/gh-review-pr/
```

Codex は変更を自動検出します。表示されない場合は Codex を再起動してください。呼び出すときは `$gh-review-pr` を指定できます。

### Plugin としてインストール

このリポジトリは Codex Marketplace として追加できる構成です。

```bash
codex plugin marketplace add yuuzin217/SKILLS
codex plugin add gh-review-pr@yuuzin217-skills
```

Plugin は Skill の配布パッケージです。GitHub へのアクセス手段そのものは同梱していないため、GitHub Connector を接続するか、ローカル Codex で認証済みの `gh` CLI を利用してください。

### ChatGPT で使う

- **ChatGPT デスクトップ**: 上記の Skill 単体またはローカル Plugin を利用できます。Skill は `@gh-review-pr` で明示的に選択できます。
- **ChatGPT Work の Web**: Web では公開またはワークスペース配布された Plugin が必要です。このリポジトリの `plugins/gh-review-pr/` は Plugin 用の標準構成ですが、GitHub URL を貼るだけで Web 版へ直接インストールできるわけではありません。利用するワークスペースへの配布または Plugin の公開手続きが別途必要です。

### 必要な GitHub アクセス

次のいずれかを用意してください。

1. ChatGPT／Codex で利用可能な GitHub Connector
2. ローカル Codex で認証済みの GitHub CLI

GitHub CLI を使う場合は、事前に状態を確認できます。

```bash
gh auth status
```

未認証の場合は `gh auth login` を実行してください。

## 開発時の検証

Skill と Plugin の両方を検証してから変更を公開してください。

```text
quick_validate.py plugins/gh-review-pr/skills/gh-review-pr
validate_plugin.py plugins/gh-review-pr
```

検証スクリプトは Codex の組み込み `skill-creator` と `plugin-creator` に含まれます。
