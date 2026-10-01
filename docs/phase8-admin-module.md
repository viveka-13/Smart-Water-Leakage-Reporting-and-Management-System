# AquaGuard: Phase 8 Admin Module

## Phase title

## Phase 8: Admin complaint management

### 1. What we are building

This phase gives administrators a protected operational view of citizen complaints. An admin can filter the complaint queue, verify or change complaint status, view active field workers, and assign a complaint to a worker.

### 2. Backend API

All endpoints require an authenticated user with the `admin` role:

```text
GET   /api/admin/complaints?status=REPORTED&priority=HIGH
GET   /api/admin/workers
PATCH /api/admin/complaints/:id/status
PATCH /api/admin/complaints/:id/assign
```

Status updates create a row in `complaint_status_history`. Assignment validates that the worker exists, is active, and has the `worker` role before updating the complaint.

### 3. Mobile experience

The Flutter admin screen includes:

- complaint queue loaded from the admin API
- status filtering
- pull-to-refresh
- status update dialog
- active worker assignment dialog
- success and error feedback
- admin route wiring from the admin home route

### 4. Files added or updated

```text
aquaguard/
├── backend/
│   ├── src/
│   │   ├── controllers/adminController.js
│   │   ├── repositories/complaintRepository.js
│   │   ├── repositories/userRepository.js
│   │   ├── routes/adminRoutes.js
│   │   ├── services/adminService.js
│   │   └── app.js
│   └── tests/admin.test.js
├── mobile/lib/
│   ├── core/routes/app_router.dart
│   ├── data/repositories/admin_repository.dart
│   └── screens/admin/admin_complaints_screen.dart
└── docs/phase8-admin-module.md
```

### 5. Verification command

```powershell
cd "C:\Users\Renta\Downloads\clg lab projects\Flutter Lab\aquaguard\backend"
npm run lint
npm test -- --runInBand
```

### 6. Expected behavior

- admins can view complaints and filter by status or priority
- citizens receive HTTP 403 when they call admin endpoints
- valid status changes update the complaint and record status history
- assignment accepts only an active field worker
- invalid complaint, worker, status, or priority values are rejected

### 7. Test checklist

- [ ] admin complaint filtering works
- [ ] citizen access is denied
- [ ] status update creates history
- [ ] worker assignment sets `ASSIGNED`
- [ ] inactive or non-worker assignment is rejected
- [ ] admin mobile queue loads
- [ ] status dialog works
- [ ] assignment dialog works

### 8. Academic explanation

The admin module is the coordination layer of AquaGuard. It transforms citizen reports into managed operational work. Role-based protection ensures that only authorized administrators can change workflow state or assign field staff. The status history table provides accountability because important changes retain who made them, what changed, and why.

### 9. Stop

This is the end of Phase 8. Please confirm before starting Phase 9.
