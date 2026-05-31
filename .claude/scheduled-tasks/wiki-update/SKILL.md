---
name: wiki-update
description: Review the week's changes to Hiveplotlib and update the wiki accordingly
schedule: "7 3 * * 6"
notifyOnCompletion: true
---
Update the Karpathy style wiki stored in the hiveplotlib repo as a sub module based on changes that have been made to the tool over the last week. You could also do a quick web search to see if anything interesting with hive plots has come out in the last week. Do not commit any changes.

Give me a nice summary of the changes. Also write that summary to BOTH `~/.claude/reflections/latest-wiki.md` (overwrite) and `~/.claude/reflections/<YYYY-MM-DD>-wiki.md` (run `date` for the stamp; create the `reflections` dir if missing), so it sits alongside the other weekly digest. End your run by stating the summary path. Match the repo's writing-voice conventions (see CLAUDE.md): no em-dashes, no AI filler.
