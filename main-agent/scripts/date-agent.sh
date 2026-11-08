#!/usr/bin/env bash
# ---
# name: date_agent
# description: >-
#   Ask the date and time sub-agent. ALWAYS use this tool whenever the user asks
#   for a date or a time in any form, such as the current date or time, the
#   weekday, a time in another time zone, a time zone conversion, a Unix
#   timestamp, or date arithmetic ("what day is it in 3 weeks"). Never answer
#   such questions from memory. Pass the user's question in full; the answer
#   comes back as plain text and can be relayed to the user.
# parameters:
#   question:
#     type: string
#     description: The user's date or time question, in full and with any context it needs (time zones, formats, reference dates)
#     required: true
# ---
set -euo pipefail

# Paths are relative to this script (<config repo>/main-agent/scripts/), and the
# config repo sits next to the plain-harness repo, whatever its folder is named.
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
harness="$here/../../../plain-harness/bin/plain-harness"
config="$here/../../sub-agent/plain-harness.yml"

if [[ -z "${PARAM_QUESTION// /}" ]]; then
  echo "question must not be empty" >&2
  exit 2
fi

# Stateless run: every call is a fresh sub-agent. Its answer goes to stdout,
# its logs to stderr, which scripts-mcp returns only if the run fails.
exec "$harness" --config "$config" "$PARAM_QUESTION"
