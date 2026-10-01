# AquaGuard: Phase 12 Analytics

## Phase title

## Phase 12: Admin analytics dashboard

### 1. What we are building

This phase gives administrators a measurable view of water-service operations. The dashboard summarizes complaint volume, open and resolved work, resolution time, citizen ratings, status distribution, priority distribution, and issue categories.

### 2. Backend API

```text
GET /api/admin/analytics/summary
```

The endpoint is protected by both JWT authentication and the `admin` role. It aggregates data from complaints and feedback using database-side counts and averages.

### 3. Returned analytics

```json
{
  "summary": {
    "total_complaints": 8,
    "open_complaints": 5,
    "resolved_complaints": 3,
    "average_resolution_hours": 18.5,
    "average_rating": 4.5,
    "feedback_count": 2
  },
  "by_status": [],
  "by_priority": [],
  "by_category": []
}
```

### 4. Mobile experience

The admin home screen now presents:

- total, open, resolved, and average-rating cards
- status breakdown bars
- priority breakdown bars
- category breakdown bars
- refresh action
- link to the detailed complaint queue

### 5. Files added or updated

```text
aquaguard/
├── backend/
│   ├── src/
│   │   ├── controllers/analyticsController.js
│   │   ├── repositories/analyticsRepository.js
│   │   ├── routes/adminRoutes.js
│   │   └── services/analyticsService.js
│   └── tests/phase12.test.js
├── mobile/lib/
│   ├── core/routes/app_router.dart
│   ├── data/repositories/admin_repository.dart
│   ├── models/analytics_summary.dart
│   └── screens/admin/admin_analytics_screen.dart
└── docs/phase12-analytics.md
```

### 6. Verification command

```powershell
cd "C:\Users\Renta\Downloads\clg lab projects\Flutter Lab\aquaguard\backend"
npm run lint
npm test -- --runInBand
```

### 7. Test checklist

- [ ] admin analytics summary loads
- [ ] citizen access is denied
- [ ] complaint totals are accurate
- [ ] resolution average is returned
- [ ] rating average is returned
- [ ] status, priority, and category breakdowns render
- [ ] dashboard refresh works
- [ ] complaint queue remains accessible

### 8. Academic explanation

Analytics turns operational records into decision-support information. Administrators can identify the most common issue categories, understand workload and priority, measure resolution speed, and observe citizen satisfaction. The aggregation endpoint keeps the dashboard efficient by calculating metrics in the database rather than transferring every complaint to the mobile app.

### 9. Stop

This is the end of Phase 12. Please confirm before starting Phase 13.
