# Offline storage and synchronization

Phase 2 uses Drift/SQLite as the local source of truth. The application has no HTTP client, backend adapter or upload worker. Offline guest access remains available. “Local mode” describes the operating mode; it does not claim to measure connectivity.

The database lives at `getApplicationSupportDirectory()/quillgrade/quillgrade.sqlite`. The nine tables are `samples`, `sample_images`, `measurements`, `finishing_results`, `calibrations`, `sync_jobs`, `user_preferences`, `study_notes` and `model_metadata`. UUIDs identify entities; foreign keys and unique constraints protect their relationships. Measurement and classifier values stay null until supplied by future validated engines. No length field or length calculation exists.

End/Side originals are copied byte for byte into `quillgrade/originals/<sample UUID>/<view>.original.<extension>`. SQLite holds relative references, allowing the app sandbox location to change. A staging directory is renamed only after both copies succeed. Failed database insertion rolls back all rows and removes only that newly created pair. Originals from the source are never moved or recompressed.

A sample insertion writes the sample, two image rows and one queue job in one transaction. Edits/results increment the local revision and reset its queue entry to pending in the same transaction. The idempotency key is `<sample UUID>:<revision>`; retrying the same revision keeps that key.

The local queue persists `pending`, `uploading`, `synced`, `failed` and `conflict`, with attempts, error text and next eligible attempt time. Claiming work creates a lease for the current revision and attempt. Late callbacks from superseded attempts/revisions are rejected. Failed retries use exponential delays starting at 30 seconds and capped at six hours; retry is explicit. Conflicts also require an explicit action. On database opening, interrupted uploading jobs return to pending; no upload starts automatically.

Only a matching acknowledgement confirming the complete record and both originals can mark a lease synced. The acknowledgement API is exercised with isolated test receipts; production has no caller that invents server confirmations. Manual sync and automatic uploads remain disabled. Home/Sync counters are real SQLite aggregates.

Confirmed removal creates a deletion tombstone and cancels the local queue transactionally. History, recent queries and statistics exclude removed samples. Original files and archived database records remain on-device. This is not a remote delete, permanent erasure or storage-reclamation feature. Deleted codes remain reserved. Future backend integration must define deletion semantics before adding remote deletes.

Phase 1 appearance/onboarding JSON is imported once into `user_preferences`; its legacy key is retained, and subsequent reads/writes use SQLite. No credentials are stored. The Study catalogue remains bundled and independent of SQLite; the new study-notes table is a persistence foundation, not a new notes editor.

Phase 7 will add the confirmed HTTPS/auth transport. Follow [API_CONTRACT.md](API_CONTRACT.md): validate server reachability, ownership, conflict semantics, payload and both-image confirmation before enabling production uploads. Any automatic upload policy needs explicit user consent. Retain originals after success.

See [PHASE_2_STORAGE.md](PHASE_2_STORAGE.md) for validation, schema history and remaining limitations.
