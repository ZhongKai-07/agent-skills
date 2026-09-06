#!/usr/bin/env sh
set -eu

if [ "$#" -ne 2 ]; then
  printf '%s\n' "Usage: $0 <skill-name> <codex|claude|agents>" >&2
  exit 2
fi

SKILL_NAME=$1
TARGET_NAME=$2
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SOURCE_DIR="$SCRIPT_DIR/skills/$SKILL_NAME"

if [ ! -f "$SOURCE_DIR/SKILL.md" ]; then
  printf '%s\n' "Skill '$SKILL_NAME' was not found under $SOURCE_DIR" >&2
  exit 1
fi

case "$TARGET_NAME" in
  codex) TARGET_ROOT=${CODEX_HOME:-"$HOME/.codex"} ;;
  claude) TARGET_ROOT=${CLAUDE_CONFIG_DIR:-"$HOME/.claude"} ;;
  agents) TARGET_ROOT=${AGENTS_HOME:-"$HOME/.agents"} ;;
  *)
    printf '%s\n' "Target must be codex, claude, or agents" >&2
    exit 2
    ;;
esac

SKILLS_ROOT="$TARGET_ROOT/skills"
DESTINATION="$SKILLS_ROOT/$SKILL_NAME"
mkdir -p "$SKILLS_ROOT"

if [ -e "$DESTINATION" ]; then
  TIMESTAMP=$(date '+%Y%m%d-%H%M%S')
  BACKUP="$DESTINATION.backup-$TIMESTAMP"
  mv "$DESTINATION" "$BACKUP"
  printf '%s\n' "Backed up existing Skill to $BACKUP"
fi

cp -R "$SOURCE_DIR" "$DESTINATION"
printf '%s\n' "Installed $SKILL_NAME for $TARGET_NAME to $DESTINATION"
