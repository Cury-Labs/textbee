# Daily MongoDB backup of textbee to a private Cloudflare R2 bucket (Cury Labs).
# The mongo image already ships mongodump; rclone uploads the archive to R2.
FROM mongo:8.0

RUN apt-get update \
  && apt-get install -y --no-install-recommends rclone ca-certificates \
  && rm -rf /var/lib/apt/lists/* \
  && touch /etc/rclone.conf

# rclone reads the R2 remote from RCLONE_CONFIG_R2_* variables; the empty file only avoids a warning.
ENV RCLONE_CONFIG=/etc/rclone.conf

COPY backup.sh /usr/local/bin/backup.sh
COPY backup-loop.sh /usr/local/bin/backup-loop.sh
RUN chmod +x /usr/local/bin/backup.sh /usr/local/bin/backup-loop.sh

ENTRYPOINT ["/usr/local/bin/backup-loop.sh"]
