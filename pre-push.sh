#!/usr/bin/env bash

echo "🔍 Running pre-push Terraform checks..."

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

FAILED=0

# Get staged Terraform files
CHANGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep '\.tf$' || true)

if [ -z "$CHANGED_FILES" ]; then
    echo -e "${YELLOW}⚠️ No Terraform changes detected. Skipping checks.${NC}"
    exit 0
fi

# Get unique directories containing .tf files
CHANGED_DIRS=$(echo "$CHANGED_FILES" | xargs -I {} dirname {} | sort -u)

for dir in $CHANGED_DIRS; do
    # Skip if it's just the root or doesn't exist
    if [ ! -d "$dir" ] || [ "$dir" == "." ]; then continue; fi

    echo -e "\n${YELLOW}--------------------------------------------------------${NC}"
    echo -e "📦 Checking: ${GREEN}$dir${NC}"
    echo -e "${YELLOW}--------------------------------------------------------${NC}"

    pushd "$dir" > /dev/null || continue

    # 1. Format Check
    if ! terraform fmt -check; then
        echo -e "${RED}❌ terraform fmt failed in $dir. Run 'terraform fmt' to fix.${NC}"
        FAILED=1
    fi

    # 2. Initialize (Required for validation to work with modules)
    # We use -backend=false for speed
    if ! terraform init -backend=false -input=false -upgrade > /dev/null 2>&1; then
        echo -e "${RED}❌ terraform init failed in $dir${NC}"
        FAILED=1
    fi

    # 3. Validate
    if ! terraform validate; then
        echo -e "${RED}❌ terraform validate failed in $dir${NC}"
        FAILED=1
    else
        echo -e "${GREEN}✅ $dir is valid${NC}"
    fi

    popd > /dev/null
done

if [ "$FAILED" -ne 0 ]; then
    echo -e "\n${RED}🚫 Terraform checks failed. Push blocked.${NC}"
    exit 1
fi

echo -e "\n${GREEN}🎉 All Terraform checks passed. Safe to push.${NC}"