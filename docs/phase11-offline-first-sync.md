# AquaGuard: Phase 11 Offline-First Synchronization

## Phase title

## Phase 11: Offline complaint queue and synchronization

### 1. What we are building

This phase allows citizens to prepare and save a complaint when the device has no network connection. The complaint remains in a persistent local queue and is retried when a connection is available. Successful retry removes the item from the queue.

### 2. Architecture

The offline path is intentionally small and layered:

- `ComplaintSubmissionService` checks connectivity and chooses online submission or local queueing.
- `OfflineComplaintQueue` persists JSON payloads with `shared_preferences`.
- `OfflineSyncService` retries pending payloads and keeps failed items for a later attempt.
- The backend accepts `synced_from_offline` and stores it in the existing complaints table.

### 3. Mobile behavior

- online form submission posts directly to `/api/complaints`
- offline submission is saved locally
- network connection failures fall back to the queue; authentication, validation, and server errors are shown instead
- latitude and longitude are retained with the queued complaint
- queued payloads are marked `synced_from_offline: true`
- retry removes only successfully submitted items
- pending items are retried when an authenticated user opens the report screen

### 4. Files added or updated

```text
aquaguard/
├── backend/src/
│   ├── repositories/complaintRepository.js
│   └── services/complaintService.js
├── mobile/
│   ├── pubspec.yaml
│   └── lib/
│       ├── data/local/offline_complaint_queue.dart
│       ├── screens/citizen/report_complaint_screen.dart
│       └── services/
│           ├── complaint_submission_service.dart
│           └── offline_sync_service.dart
└── docs/phase11-offline-first-sync.md
```

### 5. Setup command

After installing Flutter, run:

```powershell
cd "C:\Users\Renta\Downloads\clg lab projects\Flutter Lab\aquaguard\mobile"
flutter pub get
```

### 6. Verification command

```powershell
cd "C:\Users\Renta\Downloads\clg lab projects\Flutter Lab\aquaguard\backend"
npm run lint
npm test -- --runInBand
```

### 7. Test checklist

- [ ] online complaint submission works
- [ ] offline complaint is persisted
- [ ] queue survives app restart
- [ ] failed retry remains queued
- [ ] successful retry removes the item
- [ ] offline marker reaches the backend
- [ ] latitude and longitude are retained

### 8. Academic explanation

Offline-first behavior makes AquaGuard useful in locations with unreliable connectivity, which is common during field reporting. The queue separates data capture from network delivery: citizens do not lose a report simply because the request cannot be sent immediately. Retaining the synchronization marker also helps administrators understand how a complaint entered the system.

### 9. Stop

This is the end of Phase 11. Please confirm before starting Phase 12.
