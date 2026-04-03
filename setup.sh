#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "$0")" && pwd)"

# Go 子仓：需要加入 go work
GO_REPOS=(
  "ito:git@github.com:orimono/ito.git"
  "loom:git@github.com:orimono/loom.git"
  "shutter:git@github.com:orimono/shutter.git"
  "osa:git@github.com:orimono/osa.git"
)

# 非 Go 子仓：只需 clone
OTHER_REPOS=(
  "tsumu:git@github.com:orimono/tsumu.git"
  "nuno:git@github.com:orimono/nuno.git"
)

clone_or_pull() {
  local dir="$1"
  local url="$2"
  local path="$ROOT/$dir"

  if [ -d "$path/.git" ]; then
    echo "  → $dir: already exists, pulling..."
    git -C "$path" pull --ff-only
  else
    echo "  → $dir: cloning..."
    git clone "$url" "$path"
  fi
}

echo "==> Cloning Go repos..."
for entry in "${GO_REPOS[@]}"; do
  dir="${entry%%:*}"
  url="${entry#*:}"
  clone_or_pull "$dir" "$url"
done

echo "==> Cloning other repos..."
for entry in "${OTHER_REPOS[@]}"; do
  dir="${entry%%:*}"
  url="${entry#*:}"
  clone_or_pull "$dir" "$url"
done

echo "==> Configuring go work..."
cd "$ROOT"

if [ ! -f "go.work" ]; then
  go work init
fi

for entry in "${GO_REPOS[@]}"; do
  dir="${entry%%:*}"
  # 检查是否已在 go.work 里，没有则加入
  if ! grep -q "\./$dir" go.work 2>/dev/null; then
    go work use "./$dir"
    echo "  → added ./$dir to go.work"
  else
    echo "  → ./$dir already in go.work"
  fi
done

echo "==> Done."
