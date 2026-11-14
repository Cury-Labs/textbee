#!/bin/bash
# Data retention of textbee for Cury Avisa (decided on 14/11/2026):
# - SMS text (including login codes) is wiped 24 hours after the message was created;
# - SMS, batches and webhook notifications are deleted after 3 months.
# Logs one JSON line with counters only (never texts or numbers).
set -euo pipefail

mongosh "$MONGO_URI" --quiet --eval '
const day = new Date(Date.now() - 24 * 60 * 60 * 1000);
const old = new Date(); old.setUTCMonth(old.getUTCMonth() - 3);
const hasText = { $or: [ { message: { $nin: [null, ""] } }, { encryptedMessage: { $nin: [null, ""] } } ] };
const wipe = { $set: { message: "", encryptedMessage: "" } };
const result = {
  smsWiped: db.sms.updateMany({ createdAt: { $lt: day }, ...hasText }, wipe).modifiedCount,
  batchesWiped: db.smsbatches.updateMany({ createdAt: { $lt: day }, ...hasText }, wipe).modifiedCount,
  webhooksWiped: db.webhooknotifications.updateMany(
    { createdAt: { $lt: day }, "payload.message": { $exists: true } },
    { $unset: { "payload.message": "", "sms.message": "", "sms.encryptedMessage": "" } }
  ).modifiedCount,
  smsDeleted: db.sms.deleteMany({ createdAt: { $lt: old } }).deletedCount,
  batchesDeleted: db.smsbatches.deleteMany({ createdAt: { $lt: old } }).deletedCount,
  webhooksDeleted: db.webhooknotifications.deleteMany({ createdAt: { $lt: old } }).deletedCount,
};
print(JSON.stringify({ context: "textbee-maintenance", message: "Retention applied", details: result }));
'
