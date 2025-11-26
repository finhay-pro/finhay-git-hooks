# Finhay Git Hooks

Centralized pre-commit hooks for all Finhay/VNSC projects to enforce consistent code quality and conventions.

## 🎯 Purpose

This repository provides shared Git hooks that enforce:
- ✅ Branch naming conventions
- ✅ Commit message format (Conventional Commits)

## 📋 Conventions

### Branch Naming

**Format:** `<type>/<description>`

**Examples:**
```
feature/add-trading-feature
feature/HIGH-123-add-login
bugfix/fix-login-issue
bugfix/SIX-456-fix-crash
hotfix/critical-data-fix
chore/update-dependencies
release/v1.2.0
```

**Types:**
- `feature` - New feature development
- `bugfix` - Bug fixes
- `hotfix` - Urgent production fixes
- `release` - Release preparation
- `chore` - Maintenance tasks

**Rules:**
- Must start with one of the types above
- Followed by a forward slash `/`
- Then any description (can include ticket numbers if you want)

**Protected branches** (no pattern required): `main`, `master`, `develop`, `release`

### Commit Message Format

**Format:** `<type>(<scope>): <subject>`

**Examples:**
```
feat(auth): add two-factor authentication support
fix(trading): resolve order execution timeout issue
docs(api): update trading API documentation
refactor(user): simplify user profile update logic
```

**Types:**
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation changes
- `style` - Code style/formatting (no logic change)
- `refactor` - Code refactoring (no feature/fix)
- `perf` - Performance improvements
- `test` - Adding or updating tests
- `chore` - Maintenance tasks, dependencies
- `build` - Build system changes
- `ci` - CI/CD configuration changes

**Rules:**
- Subject must be at least 10 characters
- Use imperative mood (add, not added/adds)
- Start with lowercase letter
- No period at the end

## 🚀 Usage in Your Project

### 1. Install pre-commit

```bash
# Using pip
pip install pre-commit

# Or using Homebrew (macOS)
brew install pre-commit

# Verify installation
pre-commit --version
```

### 2. Create `.pre-commit-config.yaml` in your project

```yaml
repos:
  # Finhay shared hooks
  - repo: https://github.com/finhay-pro/finhay-git-hooks
    rev: v1.0.0  # Use the latest version tag
    hooks:
      - id: check-branch-name
      - id: check-commit-message

  # Optional: Add standard pre-commit hooks
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-json
      - id: check-merge-conflict
      - id: detect-private-key
      - id: check-added-large-files
        args: ['--maxkb=500']
```

### 3. Install hooks in your project

```bash
# Install pre-commit hooks
pre-commit install

# Install commit-msg hook (required for commit message check)
pre-commit install --hook-type commit-msg

# Test on all files
pre-commit run --all-files
```

## 🔧 Quick Setup Script

Save this as `setup-hooks.sh` in your project:

```bash
#!/bin/bash

echo "🔧 Setting up Finhay Git Hooks..."

# Check if pre-commit is installed
if ! command -v pre-commit &> /dev/null; then
    echo "Installing pre-commit..."
    pip install pre-commit
fi

# Create .pre-commit-config.yaml if it doesn't exist
if [ ! -f .pre-commit-config.yaml ]; then
    cat > .pre-commit-config.yaml << 'EOF'
repos:
  - repo: https://github.com/finhay-pro/finhay-git-hooks
    rev: v1.0.0
    hooks:
      - id: check-branch-name
      - id: check-commit-message

  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-merge-conflict
EOF
    echo "✅ Created .pre-commit-config.yaml"
fi

# Install hooks
pre-commit install
pre-commit install --hook-type commit-msg

echo "✅ Git hooks installed successfully!"
echo ""
echo "Test your setup:"
echo "  pre-commit run --all-files"
```

Then run:
```bash
chmod +x setup-hooks.sh
./setup-hooks.sh
```

## 🧪 Testing

Test branch naming:
```bash
# Good branch names (will pass)
git checkout -b feature/add-login
git checkout -b feature/WOLF-123-add-feature
git checkout -b bugfix/fix-crash
git checkout -b hotfix/urgent-fix

# Bad branch names (will fail)
git checkout -b my-feature          # ❌ Missing type prefix
git checkout -b feat/add-feature    # ❌ Wrong type (use 'feature' not 'feat')
git checkout -b feature-add-login   # ❌ Missing slash separator
```

Test commit messages:
```bash
# Good commits (will pass)
git commit -m "feat(auth): add JWT authentication"
git commit -m "fix(trading): resolve timeout issue"

# Bad commits (will fail)
git commit -m "fixed bug"           # ❌ Wrong format
git commit -m "feat: test"          # ❌ Subject too short
```

## 🔄 Updating Hooks

When we release new versions:

```bash
# Update to latest version
pre-commit autoupdate

# Or manually update the rev in .pre-commit-config.yaml
# Then run:
pre-commit install --install-hooks
```

## 🛠️ Bypass Hooks (Emergency Only)

If you absolutely need to bypass hooks (use sparingly!):

```bash
# Skip all hooks
git commit --no-verify -m "emergency hotfix"

# Skip specific hook
SKIP=check-branch-name git commit -m "test commit"
```

## 📦 For Repository Maintainers

### Releasing New Versions

1. Make changes to hooks
2. Update version in this README
3. Create and push a tag:

```bash
git tag -a v1.0.0 -m "Release v1.0.0: Initial release"
git push origin v1.0.0
```

### Testing Changes Locally

Test your changes before releasing:

```yaml
# In a test project's .pre-commit-config.yaml
repos:
  - repo: /Users/tuantm/Documents/Projects/finhay-git-hooks  # Local path
    rev: HEAD
    hooks:
      - id: check-branch-name
      - id: check-commit-message
```

## 🤝 Contributing

To add new hooks or modify existing ones:

1. Create a new branch following our convention
2. Add/modify hook scripts in `hooks/` directory
3. Update `.pre-commit-hooks.yaml`
4. Update this README
5. Test thoroughly
6. Create a Pull Request

## 📞 Support

For issues or questions:
- Create an issue in this repository
- Contact: TuanTM
## 📜 License

Internal use only - Finhay Vietnam / VNSC

---

**Version:** 1.0.0  
**Last Updated:** November 2024  
**Maintained by:** Finhay Engineering Team
