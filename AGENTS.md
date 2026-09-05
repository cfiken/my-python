# AGENTS.md - 開発ガイド

AI エージェント（Claude Code / Codex 等）向けの開発ガイドです。
CLAUDE.md は本ファイルへのシンボリックリンクなので、編集は AGENTS.md に対して行ってください。

## プロジェクト概要

<!-- プロジェクトの概要をここに記述 -->

## 技術スタック

- **言語**: Python 3.13
- **パッケージ管理**: uv
- **フレームワーク**: <!-- 使用するフレームワークを記述 -->
- **Lint**: ruff
- **型チェック**: ty
- **テスト**: pytest
- **コンテナ**: Docker + Docker Compose

## 開発環境

### セットアップ

```bash
# 開発コンテナをビルド・起動
make build
make up

# コンテナに入る
make shell

# 依存関係のインストール（コンテナ内）
uv sync --all-extras
```

### よく使うコマンド

```bash
make check      # lint + test（push 前に実行）
make lint       # ruff format + ruff check --fix + ty check
make test       # pytest 実行
make typecheck  # ty check のみ
make format     # ruff format のみ
```

### コンテナ内の Claude Code / Codex

- `~/.claude` / `~/.codex` はコンテナ専用の named volume（ホストと共有するとプラグインの絶対パスが衝突するため）。
  `make down` では消えず、`make clean` / `make prune` で消える（ログイン情報も消える）
- スキルとコマンドはホストの `~/.agents/skills`, `~/.claude/skills`, `~/.claude/commands` を 1:1 でマウントして共有する。
  リポジトリの `.claude/` に置くのはプロジェクト固有のものだけ
- `~/.claude.json` はホストの `~/.config/myapp-dev/claude.json` に bind mount（`make up` が冪等に作成）

## プロジェクト構成

```
src/myapp/          # メインソースコード
tests/              # テストコード（src/ のミラー構成）
scripts/            # アドホックスクリプト
docs/               # ドキュメント
```

## 開発フロー（TDD）

1. **Red**: 失敗するテストを書く
2. **Green**: テストを通す最小限の実装
3. **Refactor**: テストを変えずにコードを改善
4. **Feedback**: 設計ドキュメントを必要に応じて更新

## コーディング規約

- **行の長さ**: 120 文字
- **フォーマッタ**: ruff format（自動適用）
- **import 順**: ruff の isort ルールに従う
- **型アノテーション**: 公開 API には必須
- **docstring**: 公開 API には必須（Google スタイル）

## コミット規約

```
Red: [テスト名] - 失敗テスト追加
Green: [テスト名] - テスト通過
Refactor: [対象] - リファクタリング内容
Docs: [対象] - ドキュメント更新
Fix: [対象] - バグ修正
Feat: [対象] - 機能追加
```

## ファイル管理

| ファイル | 用途 | 更新タイミング |
|---------|------|--------------|
| DESIGN.md | アーキテクチャ設計 | 設計変更時 |
| TODO.md | 進捗管理 | 各フェーズ完了時 |
| AGENTS.md（CLAUDE.md は symlink） | エージェント指示 | プロセス変更時 |
| docs/ | 詳細ドキュメント | 機能追加時 |

## テスト

- テストファイルは `tests/` 以下に `src/` のミラー構成で配置
- `pytest-asyncio` で非同期テスト対応（`asyncio_mode = auto`）
- カバレッジレポート付き（`--cov=src/myapp`）

## Docker

- **開発**: `compose.yaml` + `Dockerfile.dev`（フルツール入り）
- **本番**: `compose.prod.yaml` + `Dockerfile`（マルチステージ、非 root）
