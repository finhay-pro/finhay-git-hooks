#!/bin/bash

# Test script for Finhay Git Hooks
# This script tests the hooks locally before pushing to production

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_DIR="/tmp/finhay-git-hooks-test-$$"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🧪 Testing Finhay Git Hooks"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Cleanup function
cleanup() {
    if [ -d "$TEST_DIR" ]; then
        echo "🧹 Cleaning up test directory..."
        rm -rf "$TEST_DIR"
    fi
}
trap cleanup EXIT

# Create test repository
echo "📁 Creating test repository..."
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"
git init -q
git config user.email "test@finhay.com.vn"
git config user.name "Test User"

# Create initial commit
echo "test" > README.md
git add README.md
git commit -q -m "chore: initial commit"
echo "✅ Test repository created"
echo ""

# Setup pre-commit with local hooks
echo "🔧 Installing pre-commit hooks from local directory..."
cat > .pre-commit-config.yaml << EOF
repos:
  - repo: $SCRIPT_DIR
    rev: HEAD
    hooks:
      - id: check-branch-name
      - id: check-commit-message
EOF

pre-commit install > /dev/null 2>&1
pre-commit install --hook-type commit-msg > /dev/null 2>&1
echo "✅ Pre-commit hooks installed"
echo ""

# Test counter
PASS=0
FAIL=0

# Helper function to test branch names
test_branch_name() {
    local branch_name=$1
    local should_pass=$2
    local description=$3
    
    echo "Testing: $description"
    echo "  Branch: $branch_name"
    
    git checkout -q -b "$branch_name" 2>/dev/null || git checkout -q "$branch_name"
    
    # Run the hook directly
    if bash "$SCRIPT_DIR/hooks/check-branch-name.sh" > /dev/null 2>&1; then
        if [ "$should_pass" = "pass" ]; then
            echo "  ✅ PASS (correctly accepted)"
            ((PASS++))
        else
            echo "  ❌ FAIL (should have been rejected)"
            ((FAIL++))
        fi
    else
        if [ "$should_pass" = "fail" ]; then
            echo "  ✅ PASS (correctly rejected)"
            ((PASS++))
        else
            echo "  ❌ FAIL (should have been accepted)"
            ((FAIL++))
        fi
    fi
    
    git checkout -q main 2>/dev/null || git checkout -q master
    echo ""
}

# Helper function to test commit messages
test_commit_message() {
    local message=$1
    local should_pass=$2
    local description=$3
    
    echo "Testing: $description"
    echo "  Message: $message"
    
    # Create temp commit message file
    echo "$message" > /tmp/test-commit-msg
    
    # Run the hook directly
    if bash "$SCRIPT_DIR/hooks/check-commit-msg.sh" /tmp/test-commit-msg > /dev/null 2>&1; then
        if [ "$should_pass" = "pass" ]; then
            echo "  ✅ PASS (correctly accepted)"
            ((PASS++))
        else
            echo "  ❌ FAIL (should have been rejected)"
            ((FAIL++))
        fi
    else
        if [ "$should_pass" = "fail" ]; then
            echo "  ✅ PASS (correctly rejected)"
            ((PASS++))
        else
            echo "  ❌ FAIL (should have been accepted)"
            ((FAIL++))
        fi
    fi
    
    rm -f /tmp/test-commit-msg
    echo ""
}

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Testing Branch Names"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Valid branch names (should pass)
test_branch_name "feature/add-login" "pass" "Simple feature branch"
test_branch_name "feature/FIN-123-add-login" "pass" "Feature with ticket number"
test_branch_name "bugfix/fix-crash" "pass" "Simple bugfix branch"
test_branch_name "bugfix/VNSC-456-fix-crash" "pass" "Bugfix with ticket number"
test_branch_name "hotfix/critical-fix" "pass" "Simple hotfix branch"
test_branch_name "hotfix/HI-789-critical-fix" "pass" "Hotfix with ticket number"
test_branch_name "chore/update-deps" "pass" "Simple chore branch"
test_branch_name "release/v1.2.0" "pass" "Release branch"
test_branch_name "main" "pass" "Protected branch: main"
test_branch_name "develop" "pass" "Protected branch: develop"

# Invalid branch names (should fail)
test_branch_name "my-feature" "fail" "Missing type prefix"
test_branch_name "feat/add-login" "fail" "Wrong type (feat instead of feature)"
test_branch_name "feature-add-login" "fail" "Missing slash separator"
test_branch_name "feature/" "fail" "Missing description after slash"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Testing Commit Messages"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Valid commit messages (should pass)
test_commit_message "feat(auth): add JWT authentication support" "pass" "Valid feature with scope"
test_commit_message "fix(trading): resolve timeout issue" "pass" "Valid fix with scope"
test_commit_message "docs: update API documentation" "pass" "Valid docs without scope"
test_commit_message "refactor(user): simplify profile logic" "pass" "Valid refactor"
test_commit_message "Merge branch 'feature/test' into main" "pass" "Merge commit"

# Invalid commit messages (should fail)
test_commit_message "fixed bug" "fail" "Wrong format"
test_commit_message "feat: test" "fail" "Subject too short"
test_commit_message "add login feature" "fail" "Missing type"
test_commit_message "feature(auth): add login" "fail" "Wrong type (feature instead of feat)"
test_commit_message "feat(auth) add login" "fail" "Missing colon"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test Results"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✅ Passed: $PASS"
echo "❌ Failed: $FAIL"
echo ""

if [ $FAIL -eq 0 ]; then
    echo "🎉 All tests passed!"
    echo ""
    echo "The hooks are working correctly and ready to be released."
    exit 0
else
    echo "⚠️  Some tests failed!"
    echo ""
    echo "Please fix the issues before releasing."
    exit 1
fi
