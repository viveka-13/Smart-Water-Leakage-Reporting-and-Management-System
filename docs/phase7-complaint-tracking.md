# AquaGuard: Phase 7 Complaint Tracking

## Phase title

## Phase 7: Complaint tracking and details

### 1. What we are building

This phase lets a citizen track every complaint submitted from their account. The citizen can refresh the list, filter complaints by status, open a complaint detail page, and view the current progress timeline.

### 2. Backend API

The citizen-only endpoints are:

```text
GET /api/complaints/my
GET /api/complaints/:id
```

Both endpoints require a valid citizen JWT. The detail query always filters by both complaint ID and authenticated user ID, so a citizen cannot view another citizen's complaint by changing the URL ID.

### 3. Mobile experience

The Flutter tracking flow includes:

- complaint list loaded from the backend
- pull-to-refresh and refresh action
- status filter chips
- empty and network-error states
- complaint summary cards
- complaint detail screen
- status progress timeline
- category, priority, description, address, and coordinates

### 4. Files added or updated

```text
aquaguard/
├── backend/
│   ├── src/
│   │   ├── controllers/complaintController.js
│   │   ├── repositories/complaintRepository.js
│   │   ├── routes/complaintRoutes.js
│   │   └── services/complaintService.js
│   └── tests/complaint.test.js
├── mobile/lib/
│   ├── core/routes/app_router.dart
│   ├── data/repositories/complaint_repository.dart
│   └── screens/citizen/
│       ├── complaint_detail_screen.dart
│       └── complaints_screen.dart
└── docs/phase7-complaint-tracking.md
```

### 5. Verification command

```powershell
cd "C:\Users\Renta\Downloads\clg lab projects\Flutter Lab\aquaguard\backend"
npm run lint
npm test -- --runInBand
```

### 6. Expected API behavior

- authenticated citizen receives their complaint list with HTTP 200
- authenticated citizen receives their own complaint detail with HTTP 200
- a complaint belonging to another citizen appears as not found with HTTP 404
- missing or invalid authentication is rejected by the existing auth middleware

### 7. Test checklist

- [ ] complaint list loads for an authenticated citizen
- [ ] complaint detail loads for the complaint owner
- [ ] another citizen's complaint cannot be read
- [ ] list refresh works
- [ ] status filters work locally
- [ ] empty state is visible when there are no matching complaints
- [ ] error state offers retry
- [ ] detail timeline reflects the complaint status

### 8. Academic explanation

Complaint tracking is the feedback loop of AquaGuard. Reporting an issue without visibility would leave citizens uncertain about whether their request was received or acted upon. This phase demonstrates authenticated retrieval, ownership-based authorization, state representation, and a mobile workflow for monitoring progress.

### 9. Stop

This is the end of Phase 7. Please confirm before starting Phase 8.
