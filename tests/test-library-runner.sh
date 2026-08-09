#!/usr/bin/env bash
set -e

TEST_ROOT="$(mktemp -d)"
trap 'rm -rf "$TEST_ROOT"' EXIT

mkdir -p "$TEST_ROOT/lib1" "$TEST_ROOT/lib2"

cat > "$TEST_ROOT/library.conf" <<EOF
LibraryOne="$TEST_ROOT/lib1"
LibraryTwo="$TEST_ROOT/lib2"
EOF

source lib/library_loader.sh
source lib/library_runner.sh

export PTK_TEST_CONFIG="$TEST_ROOT/library.conf"

ptk_load_libraries() {
    local cfg="$PTK_TEST_CONFIG"
    while IFS='=' read -r name path; do
        [[ -z "$name" || "$name" =~ ^# ]] && continue
        path="${path#\"}"
        path="${path%\"}"
        printf '%s|%s\n' "$name" "$path"
    done < "$cfg"
}

seen=0
test_callback() {
    local name="$1"
    local path="$2"
    [[ -n "$name" ]]
    [[ -d "$path" ]]
    seen=$((seen + 1))
}

ptk_run_libraries test_callback
test "$seen" -eq 2

echo OK
