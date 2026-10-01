# AquaGuard: Phase 9 Worker Module

## Phase title

## Phase 9: Field worker task management

### 1. What we are building

This phase gives field workers a focused task dashboard. A worker can see only complaints assigned to their account, open the issue details, and report work progress by moving a task to `IN_PROGRESS` or `RESOLVED` with optional remarks.

### 2. Backend API

Worker-only endpoints:

```text
GET   /api/worker/complaints
PATCH /api/worker/complaints/:id/status
```

The route requires a valid JWT with the `worker` role. The database query scopes both reads and writes by `assigned_worker_id`, preventing one worker from changing another worker's task.

### 3. Mobile experience

The Flutter worker dashboard includes:

- assigned task list
- pull-to-refresh
- empty and error states
- task address and description
- progress update dialog
- `IN_PROGRESS` and `RESOLVED` actions
- optional repair remarks

### 4. Files added or updated

```text
aquaguard/
├── backend/
│   ├── src/
│   │   ├── controllers/workerController.js
│   │   ├── repositories/complaintRepository.js
│   │   ├── routes/workerRoutes.js
│   │   ├── services/workerService.js
│   │   └── app.js
│   └── tests/worker.test.js
├── mobile/lib/
│   ├── core/routes/app_router.dart
│   ├── data/repositories/worker_repository.dart
│   └── screens/worker/worker_tasks_screen.dart
└── docs/phase9-worker-module.md
```

### 5. Verification command

```powershell
cd "C:\Users\Renta\Downloads\clg lab projects\Flutter Lab\aquaguard\backend"
npm run lint
npm test -- --runInBand
```

### 6. Expected behavior

- a worker receives only assigned complaints
- a worker can update an assigned complaint to `IN_PROGRESS`
- a worker can mark an assigned complaint `RESOLVED`
- every progress update is added to status history
- an unassigned or differently assigned complaint returns HTTP 404
- admins and citizens receive HTTP 403 from worker endpoints

### 7. Test checklist

- [ ] assigned complaint list works
- [ ] worker progress update works
- [ ] status history is recorded
- [ ] unassigned complaint cannot be updated
- [ ] non-worker access is denied
- [ ] worker dashboard refresh works
- [ ] progress dialog submits remarks

### 8. Academic explanation

The worker module closes the operational loop begun by citizen reporting and admin assignment. It uses role-based authorization and row-level ownership checks to ensure that field staff can act only on their assigned work. Recording remarks and status history makes the repair process auditable and useful for later analytics.

### 9. Stop

This is the end of Phase 9. Please confirm before starting Phase 10.
