# AquaGuard: Phase 6 Citizen Complaint Reporting

## Phase title

## Phase 6: Citizen complaint reporting

### 1. What we are building

This phase focuses on citizen complaint submission. We implement the complaint creation flow so a citizen can report a water-related issue with a title, category, description, priority, location information, and address. The backend accepts a validated complaint and stores it in the database with a default `REPORTED` status.

### 2. Architecture concept

The complaint workflow follows the layered structure already established in the project:

- Flutter form for collecting complaint data
- validation before submission
- backend endpoint for complaint creation
- service rules for validation and business logic
- repository layer for MySQL insert operations
- role-based access protection so only citizens can create complaints

This step is essential because it connects the user-facing app to the backend data layer in a safe and structured manner.

### 3. Files and folders

```text
aquaguard/
├── backend/
│   └── src/
│       ├── controllers/
│       │   └── complaintController.js
│       ├── repositories/
│       │   └── complaintRepository.js
│       ├── routes/
│       │   └── complaintRoutes.js
│       ├── services/
│       │   └── complaintService.js
│       └── app.js
├── mobile/
│   └── lib/
│       ├── models/
│       │   └── complaint.dart
│       └── screens/
│           └── citizen/
│               └── report_complaint_screen.dart
└── docs/
    └── phase6-citizen-complaint-reporting.md
```

### 4. Complete code

The complete Phase 6 implementation is in the files listed above. It includes:

- complaint creation route for citizens
- validation of title, category, description, priority, latitude, longitude, and address
- complaint repository insert logic
- complaint model for Flutter
- complaint form with inputs and validation checks

### 5. Commands

```powershell
cd "C:\Users\Renta\Downloads\clg lab projects\Flutter Lab\aquaguard\backend"
npm test -- --runInBand tests/complaint.test.js
```

### 6. How to run

1. Start the backend.
2. Register or log in as a citizen.
3. Send a POST request to `/api/complaints` with a valid JWT.
4. Use the complaint form in Flutter to collect user input.
5. Validate that the complaint is saved with a `REPORTED` status.

### 7. Expected output

A valid request should return a response like:

```json
{
  "success": true,
  "data": {
    "id": 10,
    "user_id": 1,
    "category": "PIPE_LEAKAGE",
    "title": "Main pipe leaking near school",
    "description": "The main water line is leaking heavily near the school gate.",
    "priority": "HIGH",
    "status": "REPORTED",
    "latitude": 19.1234,
    "longitude": 72.9876,
    "address": "Near ABC School, Pune"
  },
  "error": null
}
```

### 8. Common errors

- missing JWT token
- invalid category
- title too short
- description too short
- missing address
- missing latitude or longitude
- unauthorized role access

### 9. Test checklist

- [ ] complaint creation succeeds for valid citizen
- [ ] complaint creation fails without authentication
- [ ] invalid title is rejected
- [ ] invalid category is rejected
- [ ] invalid description is rejected
- [ ] address field is required
- [ ] form validation works in Flutter

### 10. Academic explanation

This phase demonstrates the core functionality of the project: collecting real citizen complaints and storing them in a structured system. It connects user interface design, form validation, backend logic, and database persistence. In a viva, this phase is important because it shows how a practical civic app can convert user input into a verifiable complaint record that later moves through verification, assignment, and resolution.

### 11. Stop

This is the end of Phase 6. Please confirm before starting Phase 7.
