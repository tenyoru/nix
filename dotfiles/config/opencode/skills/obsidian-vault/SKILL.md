---
name: obsidian-vault
description: Work safely in the Obsidian vault and always read AGENTS.md first
---

## Purpose
- Use this skill for any task that reads, writes, organizes, or links notes in `/home/Tenyoru/notes`.

## Mandatory first step
- Always read `/home/Tenyoru/notes/AGENTS.md` before making any Obsidian changes.
- Treat `AGENTS.md` as the source of truth for vault structure and writing rules.
- If instructions conflict, follow `/home/Tenyoru/notes/AGENTS.md` and its referenced rules file.

## Obsidian workflow
1. Read `/home/Tenyoru/notes/AGENTS.md`.
2. Read the target note(s) fully before editing.
3. Update frontmatter `last_opened` to current UTC ISO datetime when a note is edited, or when the user explicitly asks to read that note.
4. Keep existing note style and frontmatter conventions.
5. Prefer incremental edits over full rewrites.
6. Preserve language used by the user unless asked to translate.

## Media Notes Rule (Video/Lecture/Podcast)
- When creating or updating notes from a video, lecture, or podcast, always extract and emphasize entities.
- Always add a structured section for entities, for example:
  - `## Mentioned People and Works`
  - `### People / Thinkers`
  - `### Books / Texts / Works`
  - `### Concepts / Terms`
- Convert entities into links whenever possible:
  - Prefer Obsidian wikilinks (`[[...]]`) if the note exists in the vault.
  - If no local note exists, add an external reference link.
- Keep names normalized (consistent spelling/transliteration) and avoid duplicate entries.
- For quotes, keep wording close to source and add a short context line.

## Safety checks
- Do not move or rename files unless requested.
- Do not delete sections unless requested.
- Keep links valid and prefer existing note names for wikilinks.
- For uncertain content (quotes, names, terms), mark clearly or ask one precise question.
- Do not add `last_opened` to non-note files like `AGENTS.md`, `README.md`, JSON, or Lua files.

## Output expectations
- Confirm updated file paths.
- Summarize exactly what changed.
- Keep notes clean, readable, and consistent with the vault rules.
