# Daily MongoDB backup of textbee to a private Cloudflare R2 bucket (Cury Labs).
# The mongo image already ships mongodump; rclone (pinned, from its official image) uploads to R2.
# The Ubuntu rclone package (1.60) gets "501 NotImplemented" from R2, so it is not used.
FROM rclone/rclone:1.68.2 AS rclone

FROM mongo:8.0

COPY --from=rclone /usr/local/bin/rclone /usr/local/bin/rclone
RUN touch /etc/rclone.conf

# rclone reads the R2 remote from RCLONE_CONFIG_R2_* variables; the empty file only avoids a warning.
ENV RCLONE_CONFIG=/etc/rclone.conf

COPY backup.sh /usr/local/bin/backup.sh
COPY backup-loop.sh /usr/local/bin/backup-loop.sh
RUN chmod +x /usr/local/bin/backup.sh /usr/local/bin/backup-loop.sh

ENTRYPOINT ["/usr/local/bin/backup-loop.sh"]
