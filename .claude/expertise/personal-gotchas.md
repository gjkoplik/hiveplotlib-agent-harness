# Expertise: Cross-Cutting & Personal Gotchas

Curated gotchas that **are not owned by any single agent role**: things spanning multiple roles, plus the user's machine, shell, and working-style quirks. Environment notes (WSL/Windows/PowerShell, path/shell boundaries) are the common case but not the only one; anything genuinely cross-cutting belongs here. **Not a log.**

**This file is a fallback, not a catch-all.** Prefer the most specific home for any gotcha: if it belongs to a single role's work (a code/test/docs/viz/qa mistake), it goes in that role's expertise file, even if the user happened to hit it. An entry earns a place here only when it has no better per-role home: either it spans multiple roles, or it is environment/working-style flavored (WSL/Windows/PowerShell quirks, path/shell boundaries, repeated personal working-style corrections). When in doubt, route to the role file. Edit existing entries when a new observation refines or supersedes them; add new entries only when truly new ground is covered; remove entries that no longer earn their place. Every entry comes from a real, observed incident (cite the date or transcript when known), follows the lead + body shape, and stays lean (soft target ~60-90 words) per mental-model rule 11.

Every agent (and the dispatching session) reads this file at task start in addition to any per-role expertise file, per mental-model rule 11. Like the other expertise files, it is read directly from the harness submodule path and is deliberately **not** copied into the consumer's `.claude/` by `sync.sh`. It is maintained partly by the weekly `harness-reflection` scheduled task, which mines recent hiveplotlib session transcripts for recurring friction and proposes additions here.

## Environment

- **WSL symlinks are invisible to Windows-side tools reaching in over UNC paths.** The repo lives in WSL (`\\wsl.localhost\Ubuntu\...`) but is often accessed by Windows-side Claude Code. Symlinks created inside WSL are not followed by Windows tools over the UNC path, which is why `sync.sh` distributes the harness via file copies rather than symlinks. Anything that would otherwise be a symlink across the WSL/Windows boundary must be a real copy.
- **Default shell is Windows PowerShell 5.1, not bash.** Path separators, `$env:VAR` vs `$VAR`, `2>$null` vs `/dev/null`, and the lack of `&&`/`||` chaining all bite scripts written with a POSIX mental model. The Bash tool is available for genuinely POSIX work, but one-off commands default to PowerShell semantics. Prefer the dedicated file/search tools over shelling out, which sidesteps the quirk entirely.

## Working style

_Patterns in how the user likes work done, surfaced from repeated corrections. Empty until earned. (Durable preferences belong in the memory dir as `feedback_*` files; this section is for setup-flavored working-style gotchas that recur in practice.)_

## Recurring mistakes

_Specific mistakes that have come up more than once in hiveplotlib sessions, each tied to a real incident. Empty until earned by the weekly reflection or a noted-in-the-moment failure._
