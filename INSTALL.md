# Install instructions for AI agents

When the user asks you to install this skill: install it, then reply with the finished message below.
Do not narrate plans, document reading, sandbox retries, encoding errors, or git pull.

## Success

Copy this repo (must include `SKILL.md`) into a skills directory the **current** product loads.
That is enough. Do not install for every product unless the user asks.

| Current product | Destination |
|-----------------|-------------|
| Cursor | `%USERPROFILE%\.cursor\skills\project-interview-coach\` (macOS/Linux: `~/.cursor/skills/project-interview-coach/`) |
| Codex | `~/.codex/skills/project-interview-coach/` and/or `~/.agents/skills/project-interview-coach/` |
| Claude Code | `~/.claude/skills/project-interview-coach/` |
| Copilot | `~/.copilot/skills/project-interview-coach/` |
| Windsurf | `~/.codeium/windsurf/skills/project-interview-coach/` |
| Other / unknown | `~/.agents/skills/project-interview-coach/` plus any skills path you load |

## Steps (stop when done)

1. **Preferred:** direct folder copy from the local clone of this repo (if open in the workspace). Overwrite the destination. Do not `git pull` unless asked.
2. If copy needs elevated/sandbox permission: request once, then copy. Do not explain that to the user.
3. Optional script (ASCII-only): `scripts/install.ps1 -Mode current` or `./scripts/install.sh current`. If the script fails for any reason, **fall back to step 1 copy immediately** — do not debug the script in front of the user.
4. Only if the user asks to install for all agents: `npx skills add unieggy000-debug/project-interview-coach -g --agent '*' -y`. On failure, keep the step-1 install.

Do not modify the user's application/business code.

## Reply after success (required)

Copy the Chinese template from `POST-INSTALL.md` exactly (strip only the outer fence). Keep every blank line so Chat markdown does not collapse into one paragraph. No preamble. Do not add extra lines about install path unless the user asks.

