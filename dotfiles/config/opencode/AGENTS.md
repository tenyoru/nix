# OpenCode Global Rules

## Obsidian MCP Guardrail
- When a task uses the Obsidian MCP server or touches files under `/home/Tenyoru/notes`, read `/home/Tenyoru/notes/AGENTS.md` before any edit.
- Treat `/home/Tenyoru/notes/AGENTS.md` as mandatory instructions for vault structure, note style, and safety.
- If rules conflict, prefer `/home/Tenyoru/notes/AGENTS.md` for vault tasks.

## Execution Order For Vault Tasks
1. Read `/home/Tenyoru/notes/AGENTS.md`.
2. Read the target note(s).
3. Update note metadata field `last_opened` with current ISO timestamp when a note is edited, or when the user explicitly asks to read that note.
4. Apply minimal, precise edits.
5. Confirm changed file paths in the final response.

## Note Metadata Tracking
- For markdown notes in `/home/Tenyoru/notes`, maintain frontmatter field `last_opened`.
- Trigger: any AI edit of a note file, or an explicit user request to read a note file.
- Value format: `YYYY-MM-DD`, for example `2026-03-15`.
- If frontmatter does not exist, add it and include `last_opened`.
- Do not add this field to non-note config files (for example `AGENTS.md`, `README.md`, JSON, Lua).

# MCP Preferences

Always use Context7 MCP when:
- I need library or API documentation
- Code generation for a specific framework/library
- Setup or configuration steps
- Framework tutorials or best practices
- Troubleshooting library-specific issues

Use Context7 to research documentation before implementing code.

# Token Optimization

- Keep responses concise. Do not over-explain unless I ask.
- Do not read or explore files unless directly needed for the task.
- Do not add comments, docstrings, or type annotations to code I did not ask to change.
- Do not suggest refactors or improvements beyond what was asked.
- Ask clarifying questions before exploring the codebase - do not assume.
- If the conversation is getting long or token-heavy, proactively tell me to run `/compact` before continuing.
- When I start a new project, create a project-level CLAUDE.md with structure and key file paths so future sessions do not need to re-explore.

# Communication Preferences

Always correct my English and technical phrasing like a strict PhD in English and Computer Science would:
- Point out grammar, spelling, and punctuation errors
- Suggest better word choices and phrasing
- Correct awkward sentence structures
- Note issues with clarity, conciseness, and tone
- Be direct and thorough with corrections
