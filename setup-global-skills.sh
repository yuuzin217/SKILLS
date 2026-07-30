#!/bin/bash

# このプロジェクト内の SKILL.md を含むすべてのディレクトリを
# ~/.gemini/config/skills/ にシンボリックリンクとして登録するスクリプトです。

# バックアップディレクトリの設定
BACKUP_DIR="${HOME}/.gemini/config/skills_backup_$(date +%Y%m%d%H%M%S)"
GLOBAL_SKILLS_DIR="${HOME}/.gemini/config/skills"
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Global skills directory: ${GLOBAL_SKILLS_DIR}"
echo "Project directory: ${PROJECT_DIR}"

mkdir -p "${GLOBAL_SKILLS_DIR}"
mkdir -p "${BACKUP_DIR}"
backed_up=0

# プロジェクト内の各ディレクトリを処理
for d in "${PROJECT_DIR}"/*/; do
  # パスの最後のスラッシュを取り除く
  dir_name=$(basename "${d}")
  
  # 特定のディレクトリはスキップ
  if [ "${dir_name}" = ".git" ] || [ "${dir_name}" = ".sessions" ]; then
    continue
  fi

  # SKILL.md または skill.md が存在する場合のみシンボリックリンクを作成
  if [ -f "${d}SKILL.md" ] || [ -f "${d}skill.md" ]; then
    target="${GLOBAL_SKILLS_DIR}/${dir_name}"
    
    if [ -e "${target}" ] || [ -L "${target}" ]; then
      if [ -L "${target}" ]; then
        echo "既存のシンボリックリンクを削除します: ${dir_name}"
        rm "${target}"
      else
        echo "既存のディレクトリをバックアップします: ${dir_name} -> ${BACKUP_DIR}/"
        mv "${target}" "${BACKUP_DIR}/"
        backed_up=1
      fi
    fi
    
    echo "シンボリックリンクを作成します: ${dir_name} -> ${d}"
    ln -s "${d}" "${target}"
  fi
done

# バックアップが空なら削除
if [ ${backed_up} -eq 0 ]; then
  rmdir "${BACKUP_DIR}"
else
  echo "既存のグローバルスキルのバックアップは次の場所に保存されました: ${BACKUP_DIR}"
fi

echo "すべてのスキルがグローバルにシンボリックリンクとして登録されました。"
