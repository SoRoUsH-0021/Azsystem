#!/bin/bash

CONFIG_FILE="backup.conf"
BACKUP_DIR="/home/soroush/backups"
LOG_FILE="backup.log"
KEEP_DAYS=7
IS_DRY_RUN=false

log() {
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1" | tee -a "$LOG_FILE"
}



[[ "$1" == "--dry-run" ]] && IS_DRY_RUN=true && log "Dry-run mode enabled"


if [[ ! -f "$CONFIG_FILE" ]]; then
  log "Config file not found: $CONFIG_FILE"
  exit 1
fi


mkdir -p "$BACKUP_DIR"


backup_path() {
  local path="$1"
  local ext="$2"
  local base=$(basename "$path")
  local timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
  local archive_name="${base}_${timestamp}.tar.gz"
  local dest="$BACKUP_DIR/$archive_name"

  log "Processing $path for extension .$ext"

  if [[ "$ext" == "*" ]]; then
    files=$(find "$path" -type f)
  else
    files=$(find "$path" -type f -name "*.${ext}")
  fi

  if [[ -z "$files" ]]; then
    log "No files found in $path with extension .$ext"
    return
  fi

  if $IS_DRY_RUN; then
    log "[Dry-run] Would archive files from $path to $dest"
  else
    tar -czf "$dest" $files 2>>"$LOG_FILE"
    if [[ $? -eq 0 ]]; then
      log "Backup created: $dest"
    else
      log "Backup failed for $path"
      echo "Backup failed for $path" | mail -s "Backup Error" user@example.com
    fi
  fi
}

