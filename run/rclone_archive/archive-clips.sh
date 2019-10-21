#!/bin/bash -eu

log "Moving clips to rclone archive..."

source /root/.teslaCamRcloneConfig

FILE_COUNT=$(cd "$CAM_MOUNT"/TeslaCam && find . -maxdepth 3 -path './SavedClips/*' -o -path './SentryClips/*' -type f | wc -l)

if [ -d "$CAM_MOUNT"/TeslaCam/SavedClips ]
then
	rclone --config /root/.config/rclone/rclone.conf move "$CAM_MOUNT"/TeslaCam/SavedClips "$drive:$path" --stats-one-line -P --stats 2s --create-empty-src-dirs --delete-empty-src-dirs >> "$LOG_FILE" 2>&1 || echo ""
fi

if [ -d "$CAM_MOUNT"/TeslaCam/SentryClips ]
then
	rclone --config /root/.config/rclone/rclone.conf move "$CAM_MOUNT"/TeslaCam/SentryClips "$drive:$path" --stats-one-line -P --stats 2s --create-empty-src-dirs --delete-empty-src-dirs >> "$LOG_FILE" 2>&1 || echo ""
fi

# rclone --config /root/.config/rclone/rclone.conf move "$CAM_MOUNT"/TeslaCam/SavedClips "$drive:$path" -P --log-file=/mutable/archiveloop.log --create-empty-src-dirs --delete-empty-src-dirs

rclone --config /root/.config/rclone/rclone.conf copy /root/bin/afterTransfer "$drive:$path" -P --log-file=/mutable/archiveloop.log

FILES_REMAINING=$(cd "$CAM_MOUNT"/TeslaCam && find . -maxdepth 3 -path './SavedClips/*' -o -path './SentryClips/*' -type f | wc -l)
NUM_FILES_MOVED=$((FILE_COUNT-FILES_REMAINING))

log "Moved $NUM_FILES_MOVED file(s)."
/root/bin/send-push-message "TeslaUSB:" "Moved $NUM_FILES_MOVED dashcam file(s)."


log "Finished moving clips to rclone archive"
