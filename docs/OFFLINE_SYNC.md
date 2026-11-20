# Offline-first storage and synchronization

Phase 1 makes no network requests and offers a local guest workspace. “Local mode” is an operating mode, not a measured network status. The Sync screen shows that no cloud connection exists. SQLite storage and a persistent queue are not implemented yet.

Phase 2 must make Drift/SQLite the source of truth with transactional writes, migrations and stable UUID sample ownership. Planned tables: `samples`, `sample_images`, `measurements`, `finishing_results`, `calibrations`, `sync_jobs`, `user_preferences`, `study_notes`, `model_metadata`. Store originals in app-private file storage with database paths, not photo blobs or public-gallery assumptions. Protect deletion with confirmation; keep images intact on retries and server failures. Migrate non-critical Phase 1 preferences deliberately if moving them to Drift.

Phase 7 will add the confirmed HTTPS/Dio/auth adapter and persisted queue. Manual sync is the default. Wi-Fi-only automatic sync is optional; any-network uploads require explicit consent. Never enable automatic uploads merely by signing in. Grading, history and review must remain independent of sync/auth.

Queue states are `pending`, `uploading`, `synced`, `failed`, `conflict`. Persist retry attempts, bounded backoff, sample revision and idempotency information. On restart, recover interrupted uploads safely. Check authentication and server reachability; connectivity alone does not prove server availability. Surface progress, failures and conflicts. Do not log tokens or sensitive credentials.

Follow the exact upload/verification order in [API_CONTRACT.md](API_CONTRACT.md). Only server confirmation of the complete record and both images for the correct revision permits `synced`. A local revision changing during upload must remain pending. Retain originals after success. Duplicate retries must converge on the same stable sample UUID. Server response and conflict semantics must be confirmed before production integration.
