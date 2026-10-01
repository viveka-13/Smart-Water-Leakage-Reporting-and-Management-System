# AquaGuard: Phase 10 Notifications and Feedback

## Phase title

## Phase 10: Notifications and citizen feedback

### 1. What we are building

This phase closes the communication loop between AquaGuard and citizens. Citizens can view updates related to their complaints, mark notifications as read, and rate the quality of a completed resolution.

### 2. Backend API

```text
GET   /api/notifications
PATCH /api/notifications/:id/read
POST  /api/feedback/complaints/:complaintId
```

Notifications are scoped to the authenticated user. Feedback is scoped to the complaint owner, accepted only after `RESOLVED` or `CLOSED`, and limited to one submission per complaint.

### 3. Mobile experience

The Flutter app includes:

- notification center
- unread notification styling
- read-state action
- pull-to-refresh
- five-star resolution rating
- optional citizen comment
- feedback action on resolved complaint details

### 4. Files added or updated

```text
aquaguard/
├── backend/
│   ├── src/
│   │   ├── controllers/feedbackController.js
│   │   ├── controllers/notificationController.js
│   │   ├── repositories/feedbackRepository.js
│   │   ├── repositories/notificationRepository.js
│   │   ├── routes/feedbackRoutes.js
│   │   ├── routes/notificationRoutes.js
│   │   ├── services/feedbackService.js
│   │   ├── services/notificationService.js
│   │   └── app.js
│   └── tests/phase10.test.js
├── mobile/lib/
│   ├── core/routes/app_router.dart
│   ├── data/repositories/
│   │   ├── feedback_repository.dart
│   │   └── notification_repository.dart
│   ├── models/notification.dart
│   └── screens/citizen/
│       ├── complaint_detail_screen.dart
│       ├── feedback_screen.dart
│       └── notifications_screen.dart
└── docs/phase10-notifications-feedback.md
```

### 5. Verification command

```powershell
cd "C:\Users\Renta\Downloads\clg lab projects\Flutter Lab\aquaguard\backend"
npm run lint
npm test -- --runInBand
```

### 6. Expected behavior

- citizens see only their notifications
- a notification can be marked read only by its owner
- feedback accepts ratings from 1 to 5
- unresolved complaints cannot receive feedback
- duplicate feedback is rejected
- non-citizens cannot submit citizen feedback

### 7. Test checklist

- [ ] notification list works
- [ ] notification read state works
- [ ] resolved complaint feedback works
- [ ] unresolved complaint feedback is rejected
- [ ] duplicate feedback is rejected
- [ ] notification screen refresh works
- [ ] feedback screen validates a rating
- [ ] resolved detail screen opens feedback

### 8. Academic explanation

Notifications improve transparency by keeping citizens informed as their complaints move through the workflow. Feedback provides a measurable quality signal after resolution and helps the utility evaluate service delivery. Ownership and lifecycle validation prevent unrelated users from reading notifications or rating complaints they do not own.

### 9. Stop

This is the end of Phase 10. Please confirm before starting Phase 11.
