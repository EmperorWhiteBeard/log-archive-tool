#!/bin/bash

# ─────────────────────────────────────────
#           LOG ARCHIVE TOOL
# ─────────────────────────────────────────

# ── Colours for output ───────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ── Config ───────────────────────────────
ARCHIVE_BASE_DIR="$HOME/log_archives"
ACTIVITY_LOG="$ARCHIVE_BASE_DIR/archive_activity.log"

# ── Usage help ───────────────────────────
usage() {
    echo -e "${CYAN}"
    echo "  Usage: log-archive <log-directory>"
    echo ""
    echo "  Examples:"
    echo "    log-archive /var/log"
    echo "    log-archive /home/user/mylogs"
    echo -e "${NC}"
    exit 1
}

# ── Validate argument ────────────────────
if [ $# -ne 1 ]; then
    echo -e "${RED}  ✗ Error: Please provide exactly one log directory.${NC}"
    usage
fi

LOG_DIR="$1"

# ── Check directory exists ───────────────
if [ ! -d "$LOG_DIR" ]; then
    echo -e "${RED}  ✗ Error: Directory '$LOG_DIR' does not exist.${NC}"
    exit 1
fi

# ── Check directory is not empty ─────────
if [ -z "$(ls -A "$LOG_DIR")" ]; then
    echo -e "${YELLOW}  ⚠ Warning: Directory '$LOG_DIR' is empty. Nothing to archive.${NC}"
    exit 0
fi

# ── Create archive output directory ──────
mkdir -p "$ARCHIVE_BASE_DIR"

# ── Generate timestamped archive name ────
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
ARCHIVE_NAME="logs_archive_${TIMESTAMP}.tar.gz"
ARCHIVE_PATH="$ARCHIVE_BASE_DIR/$ARCHIVE_NAME"

# ── Compress logs ─────────────────────────
echo -e "${CYAN}  ► Archiving logs from: ${LOG_DIR}${NC}"
echo -e "${CYAN}  ► Output file        : ${ARCHIVE_PATH}${NC}"
echo ""

if tar -czf "$ARCHIVE_PATH" -C "$(dirname "$LOG_DIR")" "$(basename "$LOG_DIR")" 2>/dev/null; then

    # ── Get archive size ──────────────────
    ARCHIVE_SIZE=$(du -sh "$ARCHIVE_PATH" | cut -f1)

    echo -e "${GREEN}  ✔ Archive created successfully!${NC}"
    echo -e "${GREEN}  ✔ File : $ARCHIVE_NAME${NC}"
    echo -e "${GREEN}  ✔ Size : $ARCHIVE_SIZE${NC}"

    # ── Log the activity ──────────────────
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Archived '$LOG_DIR' → '$ARCHIVE_PATH' (Size: $ARCHIVE_SIZE)" >> "$ACTIVITY_LOG"

    echo ""
    echo -e "${CYAN}  ► Activity logged to: $ACTIVITY_LOG${NC}"

else
    echo -e "${RED}  ✗ Error: Failed to create archive. Try running with sudo.${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] FAILED to archive '$LOG_DIR'" >> "$ACTIVITY_LOG"
    exit 1
fi

# ── Summary ───────────────────────────────
echo ""
echo "  ─────────────────────────────────────────"
echo "  ✅  Done! Archive saved to:"
echo "      $ARCHIVE_PATH"
echo "  ─────────────────────────────────────────"
echo ""
