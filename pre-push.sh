#!/usr/bin/env bash

# set -o pipefail
# set -x 
echo "🔍 Running pre-push Terraform checks..."

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

FAILED=0

CHANGED_FILES=$(git diff --name-only --diff-filter=ACM | grep -E '\.tf$' || true)
CHANGED_DIRS=$(echo "$CHANGED_FILES" | xargs -r dirname | sort -u)

if [ -z "$CHANGED_DIRS" ]; then
  echo "⚠️ No Terraform changes detected. Skipping checks."
  exit 0
fi 

if [ -z "$CHANGED_DIRS" ]; then
  echo -e "${YELLOW}No staged Terraform changes, checking all Terraform dirs...${NC}"
  CHANGED_DIRS=$(find environments modules -type f -name "*.tf" -exec dirname {} \; | sort -u)
fi

echo "📁 Checking directories:"
echo "$CHANGED_DIRS"

for dir in $CHANGED_DIRS; do
  if [ -f "$dir/main.tf" ]; then
    echo "--------------------------------------------------------"
    echo "📦 Checking: $dir"
    echo "--------------------------------------------------------"

    pushd "$dir" > /dev/null

    terraform fmt -recursive || FAILED=1
    terraform init -backend=false -upgrade -input=false > /dev/null || FAILED=1

    if ! terraform validate; then
      FAILED=1
    else
      echo -e "${GREEN}✅ $dir is valid${NC}"
    fi

    popd > /dev/null
  fi
done

if [ "$FAILED" -ne 0 ]; then
  echo -e "${RED}🚫 Terraform checks failed. Push blocked.${NC}"
  exit 1
fi

echo -e "${GREEN}🎉 All Terraform checks passed. Safe to push.${NC}"