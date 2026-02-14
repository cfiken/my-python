# ============================================
# Stage 1: Build dependencies
# ============================================
FROM python:3.13-slim AS builder

ENV PYTHONUNBUFFERED=1
ENV UV_COMPILE_BYTECODE=1

COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

WORKDIR /app

# 依存関係のインストール（キャッシュ効率のためソースより先にコピー）
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-dev --no-install-project

# アプリケーションコードのコピーとインストール
COPY src/ src/
RUN uv sync --frozen --no-dev


# ============================================
# Stage 2: Production runtime
# ============================================
FROM python:3.13-slim AS runtime

ENV PYTHONUNBUFFERED=1

# セキュリティ: 非 root ユーザーで実行
RUN groupadd -r appuser && useradd -r -g appuser -d /app -s /usr/sbin/nologin appuser

WORKDIR /app

# builder から仮想環境とソースコードをコピー
COPY --from=builder --chown=appuser:appuser /app/.venv /app/.venv
COPY --from=builder --chown=appuser:appuser /app/src /app/src

ENV PATH="/app/.venv/bin:$PATH"

USER appuser

CMD ["python", "-m", "myapp"]
