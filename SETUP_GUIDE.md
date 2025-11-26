# Setup Guide for Finhay Git Hooks Repository

This guide will walk you through setting up the centralized git hooks repository for Finhay.

## 📋 Prerequisites

- Git installed
- Access to GitHub organization `finhay-pro`
- Python and pip installed (for pre-commit)

## 🚀 Step 1: Push to GitHub

### 1.1 Navigate to the repository directory

```bash
cd /Users/tuantm/Documents/finhay-git-hooks
```

### 1.2 Make scripts executable

```bash
chmod +x hooks/*.sh
chmod +x rollout-hooks.sh
chmod +x test-hooks.sh
```

### 1.3 Test the hooks locally (optional but recommended)

```bash
./test-hooks.sh
```

This will run automated tests to ensure the hooks work correctly.

### 1.4 Initialize Git repository

```bash
git init
git add .
git commit -m "feat: initial setup of Finhay centralized git hooks"
```

### 1.5 Create repository on GitHub

Go to: https://github.com/organizations/finhay-pro/repositories/new

- **Repository name:** `finhay-git-hooks`
- **Description:** Centralized pre-commit hooks for all Finhay/VNSC projects
- **Visibility:** Private (since it's internal)
- **Do NOT** initialize with README (we already have one)

### 1.6 Push to GitHub

```bash
git remote add origin git@github.com:finhay-pro/finhay-git-hooks.git
git branch -M main
git push -u origin main
```

### 1.7 Create version tag

```bash
git tag -a v1.0.0 -m "Release v1.0.0: Initial release with branch naming and commit message hooks"
git push origin v1.0.0
```

✅ Your centralized hooks repository is now live!

## 🔧 Step 2: Setup in a New Project

### 2.1 Install pre-commit (if not already installed)

```bash
pip install pre-commit
```

### 2.2 Create `.pre-commit-config.yaml` in your project

```bash
cd /path/to/your/project
```

Create `.pre-commit-config.yaml`:

```yaml
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
```

### 2.3 Install hooks

```bash
pre-commit install
pre-commit install --hook-type commit-msg
```

### 2.4 Test (optional)

```bash
pre-commit run --all-files
```

### 2.5 Commit the configuration

```bash
git add .pre-commit-config.yaml
git commit -m "chore: add pre-commit hooks configuration"
git push
```

## 📦 Step 3: Rollout to Existing Projects

### Option A: Automatic Rollout (Recommended)

If all your microservices are in a parent directory:

```bash
cd /Users/tuantm/Documents/finhay-git-hooks
./rollout-hooks.sh /path/to/your/microservices-parent-directory
```

### Option B: Manual Rollout

Edit `rollout-hooks.sh` and add your repository paths:

```bash
REPOSITORIES=(
    "/Users/tuantm/workspace/trading-service"
    "/Users/tuantm/workspace/user-service"
    "/Users/tuantm/workspace/order-service"
    # ... add all your services
)
```

Then run:

```bash
./rollout-hooks.sh
```

### Step 3.1: Review and commit in each repository

For each repository, review the generated `.pre-commit-config.yaml` and commit:

```bash
cd /path/to/service
git add .pre-commit-config.yaml
git commit -m "chore: add pre-commit hooks from finhay-git-hooks"
git push
```

## 👥 Step 4: Team Onboarding

### 4.1 Update team documentation

Add to your team wiki or Confluence:

**Title:** Setting up Git Hooks

**Content:**
```markdown
All Finhay projects now use standardized git hooks to enforce:
- Branch naming conventions
- Commit message format

## Setup (One-time)

1. Install pre-commit:
   ```
   pip install pre-commit
   ```

2. In any Finhay project, the hooks are already configured.
   Just run:
   ```
   pre-commit install
   pre-commit install --hook-type commit-msg
   ```

3. That's it! The hooks will now run automatically.

## Conventions

**Branch names:** `feature/FIN-123-description`
**Commit messages:** `feat(scope): description`

See: https://github.com/finhay-pro/finhay-git-hooks
```

### 4.2 Slack announcement

Post in your engineering channel:

```
📢 New: Standardized Git Hooks! 

We've set up centralized git hooks for all projects to ensure consistent:
✅ Branch naming (feature/WOLF-123-description)
✅ Commit messages (feat(scope): description)

Setup (one-time):
1. pip install pre-commit
2. In each project: pre-commit install && pre-commit install --hook-type commit-msg

Full guide: https://github.com/finhay-pro/finhay-git-hooks

Questions? Ask in #engineering-team
```

### 4.3 Onboarding checklist

Add to your developer onboarding:

- [ ] Install pre-commit: `pip install pre-commit`
- [ ] Read conventions: https://github.com/finhay-pro/finhay-git-hooks
- [ ] Setup hooks in projects you work on

## 🔄 Step 5: Updating Hooks

When you need to update the hooks:

### 5.1 Make changes in the repository

```bash
cd /Users/tuantm/Documents/finhay-git-hooks
# Edit hooks or add new ones
git add .
git commit -m "feat: add new validation rule"
git push
```

### 5.2 Create new version tag

```bash
git tag -a v1.1.0 -m "Release v1.1.0: Add new validation"
git push origin v1.1.0
```

### 5.3 Update version in projects

Teams can update by running:

```bash
pre-commit autoupdate
```

Or manually update the `rev` in `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: https://github.com/finhay-pro/finhay-git-hooks
    rev: v1.1.0  # Update this
```

## 🧪 Testing

### Test hooks before releasing

Always run the test suite before creating a new release:

```bash
cd /Users/tuantm/Documents/finhay-git-hooks
./test-hooks.sh
```

This will validate that:
- Valid branch names pass
- Invalid branch names fail
- Valid commit messages pass
- Invalid commit messages fail

### Test in a sample project

Create a test project to verify:

```bash
mkdir /tmp/test-project
cd /tmp/test-project
git init
git config user.email "test@finhay.com.vn"
git config user.name "Test User"

# Create .pre-commit-config.yaml with your hooks
# Then test various scenarios
```

## 📞 Troubleshooting

### Issue: "pre-commit command not found"

**Solution:**
```bash
pip install pre-commit
# Or
brew install pre-commit
```

### Issue: Hooks not running

**Solution:**
```bash
pre-commit install
pre-commit install --hook-type commit-msg
```

### Issue: Need to bypass hooks temporarily

**Solution:**
```bash
git commit --no-verify -m "emergency fix"
```

### Issue: Want to update to latest hooks version

**Solution:**
```bash
pre-commit autoupdate
```

## 📚 Additional Resources

- Pre-commit documentation: https://pre-commit.com/
- Conventional Commits: https://www.conventionalcommits.org/
- Finhay Git Hooks repo: https://github.com/finhay-pro/finhay-git-hooks

## ✅ Checklist

Complete setup checklist:

- [ ] Repository created and pushed to GitHub
- [ ] Version tag v1.0.0 created
- [ ] Tested hooks with test-hooks.sh
- [ ] Rolled out to at least one test project
- [ ] Team documentation updated
- [ ] Slack announcement posted
- [ ] Onboarding checklist updated
- [ ] Rollout plan created for remaining projects

## 🎯 Next Steps

After initial setup:

1. **Week 1:** Roll out to 5-10 pilot projects
2. **Week 2:** Gather feedback, make adjustments if needed
3. **Week 3-4:** Roll out to all remaining projects
4. **Ongoing:** Monitor adoption, provide support

---

**Questions or issues?**
- Create an issue: https://github.com/finhay-pro/finhay-git-hooks/issues
- Contact: Tuan (CTO)
- Slack: #engineering-team
