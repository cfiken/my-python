# myapp

<!-- プロジェクトの説明を記述 -->

## セットアップ

### 開発環境（Docker）

```bash
# 開発コンテナをビルド・起動
make build
make up

# コンテナに入って開発
make shell

# コンテナ内で依存関係をインストール
uv sync --all-extras
```

### ローカル環境

```bash
# uv で依存関係をインストール
uv sync --all-extras

# アプリケーション実行
uv run python -m myapp
```

## 開発コマンド

```bash
make check      # lint + test（push 前に実行）
make lint       # ruff format + ruff check + ty check
make test       # テスト実行
make typecheck  # 型チェックのみ
make format     # フォーマットのみ
```

## 本番デプロイ

```bash
make prod-build   # 本番イメージビルド
make prod-up      # 本番コンテナ起動
```

## プロジェクト構成

```
src/myapp/       # メインソースコード
tests/           # テスト
scripts/         # アドホックスクリプト
docs/            # ドキュメント
```
