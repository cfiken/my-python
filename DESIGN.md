# DESIGN.md - アーキテクチャ設計

## 概要

<!-- プロジェクトのアーキテクチャ概要を記述 -->

## ディレクトリ構成

```
src/myapp/
├── __init__.py          # パッケージ初期化
├── __main__.py          # エントリポイント
├── domain/              # ドメイン層（エンティティ、プロトコル）
├── application/         # アプリケーション層（ビジネスロジック）
├── infrastructure/      # インフラ層（外部サービス連携）
└── utils/               # ユーティリティ（設定、ロガー等）
```

## レイヤー設計

```
Presentation ← Application ← Domain → Infrastructure
```

### Domain 層
- エンティティ、値オブジェクト
- Protocol / ABC による抽象インターフェース
- 外部依存なし

### Application 層
- ビジネスロジック
- Domain 層のインターフェースを利用

### Infrastructure 層
- 外部 API、DB 等の具体実装
- Domain 層のインターフェースを実装

### Presentation 層（必要に応じて）
- CLI、Web API 等のユーザーインターフェース

## 設計方針

- **Protocol ベース**: 構造的部分型で依存性逆転
- **Frozen Dataclass**: 不変データモデルで状態汚染を防止
- **依存性注入**: コンストラクタインジェクション
- **グローバル状態の排除**: シングルトンは設定キャッシュのみ

## 技術的決定

<!-- 重要な技術的決定をここに記録 -->

| 決定事項 | 選択 | 理由 |
|---------|------|------|
| パッケージ管理 | uv | 高速、lockfile 対応 |
| Lint | ruff | 高速、統合ツール |
| 型チェック | ty | Rust 製、高速 |
| テスト | pytest | デファクトスタンダード |
| 設定管理 | pydantic-settings | 型安全な設定バリデーション |
