# Proposed mobile grading API contract

Status: **proposed, not confirmed against a server**. Phase 1 implements no HTTP adapter, authentication endpoint or upload. The web dashboard/backend remains an independent project.

API prefix: `/api/mobile-grading/v1`. Configure the HTTPS server origin with `--dart-define=QUILLGRADE_API_BASE_URL=https://your-server.example`; no default server is assumed. The future adapter must validate the origin and append the prefix once. A physical phone's `localhost` is the phone itself. Android emulator host access normally uses `10.0.2.2`; physical devices need a reachable development host/LAN address or tunnel. Do not disable TLS verification for production.

| Method | Full path | Purpose |
| --- | --- | --- |
| GET | `/api/mobile-grading/v1/health` | Reachability/server health |
| PUT | `/api/mobile-grading/v1/samples/:sampleId` | Idempotent metadata upsert |
| PUT | `/api/mobile-grading/v1/samples/:sampleId/images/end` | End image, multipart/form-data |
| PUT | `/api/mobile-grading/v1/samples/:sampleId/images/side` | Side image, multipart/form-data |
| GET | `/api/mobile-grading/v1/samples` | List samples |
| GET | `/api/mobile-grading/v1/samples/:sampleId` | Retrieve record and verify completion |

All cloud operations require authenticated server access. No login/registration/refresh paths are specified. Confirm authentication, token format/expiry/refresh, ownership, pagination, multipart field names, error schemas, upload limits, idempotency header semantics and revision preconditions before implementing the adapter. Tokens will use secure storage, never preferences; passwords must never be stored locally.

Canonical sample metadata (schema illustration, **not an actual sample**):

```json
{
  "sampleId": "UUID string",
  "revision": 1,
  "capturedAtUtc": "UTC ISO-8601 timestamp",
  "updatedAtUtc": "UTC ISO-8601 timestamp",
  "batchId": null,
  "notes": null,
  "measurement": {
    "maxWidthMm": null,
    "minWidthMm": null,
    "equivalentDiameterMm": null,
    "outerPerimeterMm": null,
    "areaMm2": null,
    "arucoMarkerId": null,
    "arucoSizeMm": null,
    "calibrationStatus": null,
    "algorithmVersion": null
  },
  "finishing": {
    "label": null,
    "confidence": null,
    "modelVersion": null,
    "reviewStatus": null
  },
  "validation": {
    "endViewStatus": null,
    "sideViewStatus": null,
    "detectorVersion": null
  }
}
```

The field names above are the proposed canonical fields. Optional values and unavailable measurements/predictions are honest JSON nulls; never manufacture a value to satisfy a non-null API expectation. Sample UUID is stable across retries and devices. Timestamps are UTC ISO-8601; revision is an integer. No length field is permitted. Images are uploaded separately as END and SIDE, not embedded in JSON or as device-local paths.

Upload order:

1. `PUT` metadata using stable sample UUID and idempotency key or equivalent server logic.
2. `PUT` End View image.
3. `PUT` Side View image.
4. `GET` the sample to verify that the server stored the full record and **both required images** for the intended revision.
5. Only then mark the local revision `synced`.

The backend must retain incomplete uploads as non-complete. A successful metadata/image request alone is insufficient proof of synchronization. Completion-response fields and revision conflict semantics are still unconfirmed; no boolean or status response schema is invented here. Repeated requests must not create duplicates. Local edits during upload require checking that the acknowledged revision still matches before marking it synced. Conflicting revisions need user review, not silent overwrite.
