#!/bin/bash

CONFIG_FILE="backup.conf"
BACKUP_DIR="/home/soroush/backups"
LOG_FILE="backup.log"
KEEP_DAYS=7
IS_DRY_RUN=false

log() {
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1" | tee -a "$LOG_FILE"
}


