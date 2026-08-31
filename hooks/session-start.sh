#!/usr/bin/env bash
# Kythene SessionStart adapter (kythene#39): prime a Claude Code session with the
# workspace brief, so a session in a Kythene-connected repo opens already caught
# up instead of starting from a blank slate.
#
# It is an OPTIMISATION over the baseline, never a dependency: a user without the
# kythe CLI or without credentials still gets the behaviour through the MCP
# server's initialize instructions (kythene/app#403), just later in the session.
# So this must be SILENT and INSTANT when it has nothing to say - no token, no
# binary, no network - or it taxes every unrelated session and gets uninstalled.
# It reads only what the server already knows; it holds no local state.

# No kythe CLI, or no credentials -> nothing to do. Quietly yield to the baseline.
command -v kythe >/dev/null 2>&1 || exit 0
[ -n "${KYTHENE_TOKEN:-}" ] || exit 0

# Best-effort and bounded: a slow or unreachable server yields no priming rather
# than a delay or an error at session start. brief scopes to the workspace the
# token belongs to; it consumes the catchup delta like catchup does.
brief=$(timeout 5 kythe brief 2>/dev/null) || exit 0
[ -n "$brief" ] || exit 0

# Claude Code adds a SessionStart command hook's stdout to the session context.
printf 'Kythene workspace brief (call `brief` again any time to refresh):\n\n%s\n' "$brief"
exit 0
