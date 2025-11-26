# Finhay Git Hooks - Quick Reference

## 🎯 Branch Naming

### Format
```
<type>/<description>
```

### Examples
```bash
✅ feature/add-trading-feature
✅ feature/FIN-123-add-login
✅ bugfix/fix-login-issue
✅ bugfix/VNSC-456-fix-crash
✅ hotfix/critical-data-fix
✅ chore/update-dependencies
✅ release/v1.2.0
```

### Types
| Type | Usage |
|------|-------|
| `feature` | New feature development |
| `bugfix` | Bug fixes |
| `hotfix` | Urgent production fixes |
| `release` | Release preparation |
| `chore` | Maintenance, dependencies |

### Rules
- ✅ Must start with: feature, bugfix, hotfix, release, or chore
- ✅ Followed by a slash `/`
- ✅ Then any description (can include ticket numbers if you want)

### Protected Branches
No naming pattern required: `main`, `master`, `develop`, `staging`, `production`

---

## 💬 Commit Messages

### Format
```
<type>(<scope>): <subject>
```

### Examples
```bash
✅ feat(auth): add JWT token refresh mechanism
✅ fix(trading): resolve order execution timeout
✅ docs(api): update authentication endpoints
✅ refactor(user): simplify profile update logic
✅ perf(database): optimize bond query performance
✅ test(order): add validation unit tests
```

### Types
| Type | Usage | Example |
|------|-------|---------|
| `feat` | New feature | `feat(auth): add OAuth2` |
| `fix` | Bug fix | `fix(order): resolve timeout` |
| `docs` | Documentation | `docs: update README` |
| `style` | Code style/format | `style: fix indentation` |
| `refactor` | Code refactoring | `refactor(api): simplify logic` |
| `perf` | Performance | `perf(db): optimize query` |
| `test` | Tests | `test(user): add unit tests` |
| `chore` | Maintenance | `chore: update dependencies` |
| `build` | Build system | `build: update webpack config` |
| `ci` | CI/CD | `ci: add deployment step` |

### Rules
- ✅ Subject must be at least 10 characters
- ✅ Use imperative mood: "add" not "added" or "adds"
- ✅ Start with lowercase: "add feature" not "Add feature"
- ✅ No period at end
- ✅ Scope is optional but recommended

---

## 🚀 Setup (One-time)

```bash
# Install pre-commit
pip install pre-commit

# In your project
pre-commit install
pre-commit install --hook-type commit-msg

# Test
pre-commit run --all-files
```

---

## 🔧 Common Commands

```bash
# Run hooks on all files
pre-commit run --all-files

# Run hooks on staged files
pre-commit run

# Update hooks to latest version
pre-commit autoupdate

# Skip hooks (emergency only!)
git commit --no-verify -m "emergency fix"

# Skip specific hook
SKIP=check-branch-name git commit -m "test"
```

---

## ❌ Common Mistakes

### Branch Names
```bash
❌ my-feature                      # Missing type prefix
❌ feat/add-login                 # Wrong type (use 'feature' not 'feat')
❌ feature-add-login              # Missing slash separator
❌ feature/                       # Missing description
```

### Commit Messages
```bash
❌ "fixed bug"                    # Wrong format
❌ "feat: test"                   # Too short (< 10 chars)
❌ "add feature"                  # Missing type
❌ "feature(auth): add"           # Wrong type (use 'feat' not 'feature')
❌ "feat(auth) add login"         # Missing colon
❌ "Feat(auth): add login"        # Capitalized
❌ "feat(auth): Add login"        # Capitalized subject
❌ "feat(auth): add login."       # Period at end
```

---

## 🆘 Emergency Bypass

**Only use in genuine emergencies (production down, critical hotfix):**

```bash
# Skip all hooks
git commit --no-verify -m "emergency: fix production issue"

# After emergency is resolved, create proper branch/commit
```

---

## 📚 More Info

- Full docs: https://github.com/finhay-pro/finhay-git-hooks
- Conventional Commits: https://www.conventionalcommits.org/
- Pre-commit: https://pre-commit.com/

---

## 💡 Tips

1. **Branch first, then code**
   ```bash
   git checkout -b feature/your-feature-name
   # or with ticket number
   git checkout -b feature/FIN-123-your-feature
   ```

2. **Commit often with good messages**
   ```bash
   git commit -m "feat(auth): add password validation"
   git commit -m "test(auth): add validation tests"
   ```

3. **Use scope to clarify changes**
   - `feat(auth)` - Authentication changes
   - `feat(trading)` - Trading system changes
   - `feat(user)` - User management changes

4. **Write descriptive subjects**
   - ✅ "add JWT token refresh with 7-day expiry"
   - ❌ "update auth"

---

**Questions?** Ask in #engineering-team or check the repo!
