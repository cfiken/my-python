#!/usr/bin/env bash
set -euo pipefail

# ============================================
# テンプレートリポジトリ初期化スクリプト
#
# 使い方:
#   ./scripts/init-project.sh <プロジェクト名>
#
# 例:
#   ./scripts/init-project.sh my_awesome_app
#   ./scripts/init-project.sh discord_bot
#
# 実行後:
#   - src/myapp/ → src/<プロジェクト名>/ にリネーム
#   - 全ファイル中の "myapp" を置換
#   - このスクリプト自身を削除
# ============================================

OLD_NAME="myapp"

if [ $# -eq 0 ]; then
  echo "使い方: $0 <プロジェクト名>"
  echo "例: $0 my_awesome_app"
  exit 1
fi

NEW_NAME="$1"

# バリデーション: Python パッケージ名として有効か
if [[ ! "$NEW_NAME" =~ ^[a-z][a-z0-9_]*$ ]]; then
  echo "エラー: プロジェクト名は Python パッケージ名の規約に従ってください"
  echo "  - 小文字英字で始まる"
  echo "  - 小文字英字、数字、アンダースコアのみ"
  echo "  例: my_app, discord_bot, web_api"
  exit 1
fi

if [ "$NEW_NAME" = "$OLD_NAME" ]; then
  echo "エラー: 'myapp' 以外の名前を指定してください"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_ROOT"

echo "=== プロジェクト初期化 ==="
echo "  $OLD_NAME → $NEW_NAME"
echo ""

# 1. ファイル内容の置換
echo "[1/4] ファイル内のテキストを置換中..."

# compose の名前部分はハイフン区切りに変換
NEW_NAME_HYPHEN="${NEW_NAME//_/-}"

FILES_TO_REPLACE=(
  pyproject.toml
  pytest.ini
  Dockerfile
  compose.yaml
  compose.prod.yaml
  Makefile
  README.md
  # CLAUDE.md は AGENTS.md への symlink なので対象外（sed -i すると実体ファイル化してしまう）
  AGENTS.md
  DESIGN.md
  .env.example
  "src/$OLD_NAME/__init__.py"
  "src/$OLD_NAME/__main__.py"
  "src/$OLD_NAME/utils/config.py"
  "src/$OLD_NAME/utils/logger.py"
  "tests/utils/test_config.py"
)

for file in "${FILES_TO_REPLACE[@]}"; do
  if [ -f "$file" ]; then
    # compose ファイルと Makefile はハイフン区切りの名前（myapp-dev 等）も置換
    if [[ "$file" == compose* || "$file" == Makefile ]]; then
      sed -i '' "s/${OLD_NAME}-/${NEW_NAME_HYPHEN}-/g" "$file"
      sed -i '' "s/container_name: ${OLD_NAME}/container_name: ${NEW_NAME_HYPHEN}/g" "$file"
    fi
    sed -i '' "s/${OLD_NAME}/${NEW_NAME}/g" "$file"
  fi
done

# 2. ディレクトリのリネーム
echo "[2/4] src/${OLD_NAME}/ → src/${NEW_NAME}/ にリネーム中..."
mv "src/$OLD_NAME" "src/$NEW_NAME"

# 3. uv.lock の再生成
echo "[3/4] uv.lock を再生成中..."
if command -v uv &> /dev/null; then
  uv lock --quiet 2>/dev/null || echo "  警告: uv lock に失敗しました。手動で 'uv sync' を実行してください"
else
  rm -f uv.lock
  echo "  uv が見つかりません。コンテナ内で 'uv sync' を実行してください"
fi

# 4. このスクリプト自身を削除
echo "[4/4] 初期化スクリプトを削除中..."
rm -f "$0"

echo ""
echo "=== 完了 ==="
echo ""
echo "次のステップ:"
echo "  1. README.md を編集してプロジェクトの説明を追加"
echo "  2. DESIGN.md にアーキテクチャを記述"
echo "  3. make build && make up && make shell で開発開始"
echo ""
