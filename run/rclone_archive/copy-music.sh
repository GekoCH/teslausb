#!/bin/bash -eu

log "Copying music through rclone..."

source /root/.teslaCamRcloneConfig

before=$(find $MUSIC_MOUNT -type f | wc -l)
#echo "$before"

#rclone --config /root/.config/rclone/rclone.conf sync "$drive:$music" $MUSIC_MOUNT --create-empty-src-dirs
rclone --config /root/.config/rclone/rclone.conf sync "$drive:$music" $MUSIC_MOUNT --size-only --stats-one-line -P --stats 2s >> "$LOG_FILE" 2>&1 || echo ""

after=$(find $MUSIC_MOUNT -type f | wc -l)
#echo "$after"

diff=$((before-after))
diff=${diff#-}

#echo "$diff"

if (("$diff" > 0))
then
  log "Successfully synced music through rclone."
  /root/bin/send-push-message "TeslaUSB:" "Moved "$diff" music file(s)"
else
  log "No music to copy through rclone."
fi

