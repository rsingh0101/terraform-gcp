#!/usr/bin/env bash

set -euo pipefail

echo "🔍 Running pre-push Terraform checks..."

# Colors (optional)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Track failures
FAILED=0

# Get changed files (staged + unstaged)
CHANGED_DIRS=$(git diff --name-only --diff-filter=ACM | grep -E '\.tf$' | xargs -r dirname | sort -u)

if [ -z "$CHANGED_DIRS" ]; then
  echo -e "${YELLOW}No Terraform changes detected. Skipping checks.${NC}"
  exit 0
fi

echo "📁 Changed Terraform directories:"
echo "$CHANGED_DIRS"

for dir in $CHANGED_DIRS; do
  if [ -f "$dir/main.tf" ]; then
    echo "--------------------------------------------------------"
    echo "📦 Checking: $dir"
    echo "--------------------------------------------------------"

    pushd "$dir" > /dev/null

    echo "➡️ terraform fmt"
    if ! terraform fmt -check -recursive; then
      echo -e "${RED}❌ Formatting failed in $dir${NC}"
      FAILED=1
    fi

    echo "➡️ terraform init (no backend)"
    if ! terraform init -backend=false -upgrade -input=false > /dev/null; then
      echo -e "${RED}❌ Init failed in $dir${NC}"
      FAILED=1
    fi

    echo "➡️ terraform validate"
    if ! terraform validate; then
      echo -e "${RED}❌ Validation failed in $dir${NC}"
      FAILED=1
    else
      echo -e "${GREEN}✅ $dir is valid${NC}"
    fi

    popd > /dev/null
  fi
done

# Final decision
if [ "$FAILED" -ne 0 ]; then
  echo -e "${RED}🚫 Terraform checks failed. Push blocked.${NC}"
  exit 1
fi

echo -e "${GREEN}🎉 All Terraform checks passed. Safe to push.${NC}"