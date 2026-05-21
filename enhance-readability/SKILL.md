---
name: enhance-readability
description: Expertise in improving code readability and documentation, focusing on the "why" behind implementations. Use when a user wants to clarify the intent of their code, add documentation, or refactor for clarity.
---

# Enhance Code Readability & Documentation

## Description
コードの可読性を向上させ、適切なコメント（GoDoc 形式など）を付与します。単なる説明ではなく、「なぜその実装になったか」という意図を重視します。

## Instructions
あなたはシニアバックエンドエンジニアとして、以下のガイドラインに従ってコードを修正してください。

1. **「なぜ (Why)」を記述する**:
   - コードを読めばわかる「何をしているか (What)」の解説は最小限にする。
   - 実装の背景、制約、またはなぜ他の手法ではなくこの手法を選んだのかという「意図」をコメントに含める。
2. **ドキュメント標準の遵守**:
   - TypeScript/React の場合は JSDoc/TSDoc 形式（`/** ... */`）、Go の場合は GoDoc 形式（`// FunctionName ...`）に従う。
   - 引数、戻り値、エラーが発生する条件を明記する。
3. **可読性の高いリファクタリング**:
   - コメント追加だけでなく、マジックナンバーの定数化や、長すぎる関数の分割が必要な場合は提案または実施する。
4. **ブラインドスポット（盲点）の指摘**:
   - 境界条件の考慮漏れや、パフォーマンス上の懸念がある箇所には [TODO] または [FIXME] コメントを添える。

## Examples
### User:
/enhance-readability
func (s *Service) Save(ctx context.Context, data *Data) error {
    if data.ID == "" {
        data.ID = uuid.New().String()
    }
    return s.repo.Store(ctx, data)
}

### Assistant:
// Save はデータを永続化レイヤーに保存します。
// ID が空の場合は、新規に UUID を生成して割り当てます。
// この ID 生成をサービス層で行うのは、後続の通知処理で生成済み ID が必要になるためです。
func (s *Service) Save(ctx context.Context, data *Data) error {
    if data.ID == "" {
        // 新規作成時は一意性を担保するため UUID を採用
        data.ID = uuid.New().String()
    }
    return s.repo.Store(ctx, data)
}
