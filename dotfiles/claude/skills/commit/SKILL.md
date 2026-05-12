---
name: commit
description: Generate clear, conventional commit messages from git diffs. Use when the user asks to commit, make a commit, git commit, save changes to git, write a commit message, or any similar phrasing. Never adds Co-Authored-By or any Anthropic/Claude attribution.
---

# Commit Message Skill

Generate consistent, informative commit messages following the Conventional Commits specification.

## Process

1. **Gather context** — run these in parallel:
   - `git status` (no `-uall` flag)
   - `git diff` (staged and unstaged)
   - `git log --oneline -5` (to match the repo's commit style)

2. **Identify the type**: Determine the primary change category
3. **Find the scope**: Identify the main area affected
4. **Write the message**: Follow the format below

## Commit Message Format

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### Types

| Type | Description | Example |
|------|-------------|---------|
| `feat` | New feature | `feat(auth): add OAuth2 login` |
| `fix` | Bug fix | `fix(api): handle null response` |
| `docs` | Documentation only | `docs(readme): add setup instructions` |
| `style` | Formatting, no code change | `style: fix indentation` |
| `refactor` | Code change, no new feature/fix | `refactor(db): extract query builder` |
| `perf` | Performance improvement | `perf(search): add result caching` |
| `test` | Adding/fixing tests | `test(auth): add login unit tests` |
| `build` | Build system changes | `build: update webpack config` |
| `ci` | CI configuration | `ci: add GitHub Actions workflow` |
| `chore` | Maintenance tasks | `chore(deps): update dependencies` |
| `revert` | Revert previous commit | `revert: feat(auth): add OAuth2` |

### Scope

The scope should be a noun describing the section of the codebase:
- `auth`, `api`, `db`, `ui`, `config`
- Feature names: `search`, `checkout`, `dashboard`
- Or omit if the change is broad

### Subject Line Rules

- Use imperative mood: "add" not "added" or "adds"
- Don't capitalize the first letter after the colon
- No period at the end
- Max 72 characters total

### Body (when needed)

- Separate from subject with a blank line
- Explain *what* and *why*, not *how*
- Wrap at 72 characters
- Use bullet points for multiple changes

### Footer (when needed)

- `BREAKING CHANGE:` for breaking changes
- `Fixes #123` to close issues
- `Refs #456` to reference without closing

## Examples

### Simple feature
```
feat(search): add fuzzy matching support
```

### Bug fix with issue reference
```
fix(cart): prevent duplicate items on rapid clicks

Add debounce to add-to-cart button and check for existing
items before insertion.

Fixes #234
```

### Breaking change
```
feat(api)!: change response format to JSON:API

BREAKING CHANGE: API responses now follow JSON:API spec.
All clients need to update their parsers.
```

### Multiple related changes
```
refactor(auth): consolidate authentication logic

- Extract JWT handling to dedicated service
- Move session management from controller to middleware
- Add refresh token rotation
```

## Stage and Commit

Prefer staging specific files by name over `git add -A`. Use a HEREDOC to pass the message:

```bash
git commit -m "$(cat <<'EOF'
Your commit message here
EOF
)"
```

Run `git status` after the commit to confirm it succeeded.

## Hard Rules

- **Never** add `Co-Authored-By:` lines.
- **Never** mention Claude, Anthropic, or Claude Code anywhere in the message.
- Never use `--no-verify` or skip hooks unless the user explicitly asks.
- Never amend a previous commit unless the user explicitly asks — always create a new commit.
- Never force-push or use destructive git commands without explicit user instruction.
- Never commit files that likely contain secrets (`.env`, credential files, etc.) — warn the user first.

## Output

1. Show the staged changes summary
2. Propose the commit message
3. Explain the type/scope choice if non-obvious
4. Ask if the user wants to proceed or modify
