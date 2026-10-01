# AquaGuard: Phase 1 Project Planning

## Phase title

## Phase 1: Planning

### 1. What we are building

AquaGuard is a real-world mobile and web-ready civic utility application built to help citizens report and track water-related issues such as pipe leaks, overflowing tanks, blocked drains, contaminated water, low pressure, illegal connections, and other infrastructure problems. The system connects citizens, administrators, and field workers in one transparent workflow that improves service delivery, accountability, and response time.

The mobile app will allow citizens to submit complaints with title, category, description, priority, GPS location, address, photo evidence, and timestamps. The administrator can verify, assign, and monitor every complaint. Field workers can accept assigned tasks, update progress, add remarks, upload proof photographs, and mark complaints resolved. The platform will also include notifications, feedback, offline-first complaint storage, and analytics dashboards for reporting and decision-making.

### 2. Architecture concept

The project follows a clean layered architecture with clear separation of responsibilities:

- UI layer: Flutter screens, widgets, form validation, navigation
- ViewModel / Provider layer: state management, validation, screen state, loading and error handling
- Repository layer: centralized access to data and business logic
- Remote data source: REST API calls to the Node.js backend
- Local data source: Hive or SQLite for offline-first storage
- Backend API layer: Express.js endpoints, JWT auth, validation, route guards
- Database layer: MySQL schema, relations, indexes, migrations, and seed data

This design ensures reusability, maintainability, and security. The repository acts as the single source of truth, while UI widgets remain presentation-focused and free from direct database or network logic.

### 3. Files and folders

Exact project structure (planned):

```text
aquaguard/
├── .gitignore
├── README.md
├── docker-compose.yml
├── mobile/
│   ├── lib/
│   │   ├── main.dart
│   │   ├── core/
│   │   │   ├── constants/
│   │   │   ├── theme/
│   │   │   ├── routes/
│   │   │   ├── errors/
│   │   │   └── utils/
│   │   ├── models/
│   │   │   ├── user.dart
│   │   │   ├── complaint.dart
│   │   │   ├── notification.dart
│   │   │   └── feedback.dart
│   │   ├── data/
│   │   │   ├── remote/
│   │   │   ├── local/
│   │   │   └── repositories/
│   │   ├── providers/
│   │   ├── viewmodels/
│   │   ├── screens/
│   │   │   ├── auth/
│   │   │   ├── citizen/
│   │   │   ├── admin/
│   │   │   └── worker/
│   │   ├── widgets/
│   │   └── services/
│   ├── assets/
│   │   ├── images/
│   │   └── icons/
│   ├── test/
│   └── pubspec.yaml
├── backend/
│   ├── src/
│   │   ├── config/
│   │   ├── controllers/
│   │   ├── middleware/
│   │   ├── models/
│   │   ├── routes/
│   │   ├── services/
│   │   ├── repositories/
│   │   ├── validators/
│   │   ├── utils/
│   │   ├── app.js
│   │   └── server.js
│   ├── tests/
│   ├── package.json
│   └── .env.example
├── database/
│   ├── migrations/
│   ├── seeds/
│   └── schema.sql
├── docs/
│   ├── architecture.md
│   ├── api.md
│   ├── database.md
│   ├── testing.md
│   ├── phase1-project-plan.md
│   └── screenshots/
└── README.md
```

### 4. Complete code

This phase is planning only. No business logic or runtime implementation code is added yet. The project is being structured and documented before the implementation phases begin.

The complete files created during this phase are:

- `aquaguard/README.md`
- `aquaguard/docs/phase1-project-plan.md`
- `aquaguard/docs/architecture.md`
- `aquaguard/docs/api.md`
- `aquaguard/docs/database.md`
- `aquaguard/docs/testing.md`

The directory structure above is the base for all future implementation work.

### 5. Commands

Windows PowerShell commands for the setup phase:

```powershell
cd "C:\Users\Renta\Downloads\clg lab projects\Flutter Lab"
mkdir aquaguard
cd aquaguard
mkdir mobile backend database docs
mkdir mobile\lib\core\constants mobile\lib\core\theme mobile\lib\core\routes mobile\lib\core\errors mobile\lib\core\utils
mkdir mobile\lib\models mobile\lib\data\remote mobile\lib\data\local mobile\lib\data\repositories
mkdir mobile\lib\providers mobile\lib\viewmodels mobile\lib\screens\auth mobile\lib\screens\citizen mobile\lib\screens\admin mobile\lib\screens\worker
mkdir mobile\lib\widgets mobile\lib\services mobile\assets\images mobile\assets\icons mobile\test
mkdir backend\src\config backend\src\controllers backend\src\middleware backend\src\models backend\src\routes backend\src\services backend\src\repositories backend\src\validators backend\src\utils backend\tests
mkdir database\migrations database\seeds docs\screenshots
```

### 6. How to run

At this planning stage, there is no application to launch. The next actions are:

1. Verify Flutter installation.
2. Verify Node.js and npm installation.
3. Verify MySQL service availability.
4. Initialize the Flutter project in `aquaguard/mobile`.
5. Initialize the backend in `aquaguard/backend`.
6. Create the database schema and seed scripts in `aquaguard/database`.

No runtime command should be executed yet because phase 1 is documentation and architecture planning only.

### 7. Expected output

The following outputs are expected after Phase 1:

- A clear project idea and problem definition
- Well-defined role-based requirements
- A maintenance-friendly folder structure
- A complete roadmap for all future phases
- A database and API plan ready for implementation

### 8. Common errors

Possible planning-stage problems:

- Confusing the app with a complaint app instead of a water-utility system
- Overlooking role-based access control between citizen, worker, and admin
- Missing offline-first requirements
- Ignoring GPS and image validation rules
- Forgetting real-world database and API constraints
- Starting implementation before architecture is finalized

### 9. Test checklist

Phase 1 checklist:

- [ ] Project idea is clearly defined
- [ ] Problem statement is documented
- [ ] Scope is realistic for an undergraduate project
- [ ] User roles are clearly separated
- [ ] Functional requirements are listed
- [ ] Non-functional requirements are documented
- [ ] Architecture is layered and maintainable
- [ ] Database entities are identified
- [ ] API list is prepared
- [ ] Flutter screens and modules are planned
- [ ] Development roadmap is ready
- [ ] Definition of done is written

### 10. Academic explanation

AquaGuard is a smart civic utility application that demonstrates how mobile apps can be used to improve public infrastructure management. The project is useful because it solves a real problem: citizens often struggle to report water-related problems quickly and clearly, while authorities and workers may not have a unified tool to track complaints from submission to resolution. This project showcases full-stack development, role-based systems, geolocation, image capture, notifications, analytics, and offline-first behavior in one practical application.

During the viva, this project can be explained as a complete digital workflow that improves transparency, accountability, and citizen satisfaction while making water-service management more structured and efficient.

### 11. Stop

This is the end of Phase 1. The project has been planned, scoped, and structurally prepared. The next phase will begin only after confirmation from the user.

---

## Project Summary

### Abstract

AquaGuard is a smart water leakage reporting and management system that allows citizens to report water-related issues, administrators to manage complaints and field workers, and workers to resolve problems efficiently. The system emphasizes real-time tracking, geolocation, evidence-based reporting, role-based authorization, and analytics.

### Problem statement

Many cities still rely on delayed manual reporting, inconsistent tracking, and scattered communication for water issues. Citizens face difficulty reporting problems, administrators lack a centralized system for monitoring operations, and field workers do not always have clear, structured assignments. AquaGuard solves this challenge through a digital, role-based workflow.

### Objectives

1. Build a practical Flutter mobile application for water issue reporting.
2. Implement role-based access for citizens, workers, and admins.
3. Integrate GPS and image-based evidence reporting.
4. Support complaint lifecycle management from reported to closed.
5. Add notifications, analytics, and offline synchronization.
6. Use a MySQL database and Node.js backend to show full-stack project implementation.

### Scope

The scope includes:

- Complaint submission and tracking
- Admin verification and assignment
- Field worker updates and repair proof
- Notifications and feedback
- Offline queue management and sync
- Analytics dashboard with charts
- MySQL-backed backend architecture

### User roles

A. Citizen
- Register/login
- Submit complaints
- Add photo and location
- Track complaint history
- Submit feedback and ratings

B. Field Worker
- Log in and see assigned tasks
- View location and map
- Update work progress
- Add remarks and proof images
- Mark tasks resolved

C. Administrator
- View all complaints and users
- Verify complaints
- Assign workers
- Update priorities and status
- View analytics and activity logs

### Functional requirements

- User authentication and role-based access
- Complaint creation with validation
- Category, priority, and status management
- GPS location capture and reverse geocoding
- Image upload and evidence handling
- Notification and activity tracking
- Complaint history and status timeline
- Offline complaint storage and retry sync
- Dashboard analytics and charts

### Non-functional requirements

- Secure authentication with JWT and password hashing
- Input validation on both frontend and backend
- SQL injection prevention by parameterized queries
- CORS and rate limiting for backend security
- Clean Flutter UI with role-based navigation
- Responsive design for mobile usability
- Offline-first data handling with local persistence
- scalability and maintainability through clean architecture

### Database entities

- users
- complaints
- complaint_status_history
- notifications
- feedback
- activity_logs
- complaint_categories
- refresh_tokens

### API list

Authentication
- POST /api/auth/register
- POST /api/auth/login
- GET /api/auth/me
- POST /api/auth/logout

Users
- GET /api/users/me
- PUT /api/users/me
- GET /api/admin/users
- PUT /api/admin/users/:id/status

Complaints
- POST /api/complaints
- GET /api/complaints/my
- GET /api/complaints/:id
- PUT /api/complaints/:id
- DELETE /api/complaints/:id
- PATCH /api/complaints/:id/reopen

Admin
- GET /api/admin/complaints
- PATCH /api/admin/complaints/:id/verify
- PATCH /api/admin/complaints/:id/assign
- PATCH /api/admin/complaints/:id/status
- GET /api/admin/analytics
- GET /api/admin/activity-logs

Worker
- GET /api/worker/complaints
- PATCH /api/worker/complaints/:id/accept
- PATCH /api/worker/complaints/:id/status
- POST /api/worker/complaints/:id/proof

Notifications
- GET /api/notifications
- PATCH /api/notifications/:id/read
- PATCH /api/notifications/read-all

Feedback
- POST /api/complaints/:id/feedback
- GET /api/complaints/:id/feedback

Health
- GET /api/health

### Flutter screens

- Splash and onboarding
- Login and registration
- Citizen dashboard
- Report complaint form
- My complaints list
- Complaint detail screen
- Complaint map preview
- Notification center
- Feedback screen
- Admin dashboard
- Worker dashboard
- Assignment and status management screens

### Development roadmap

1. Phase 1: Planning and architecture
2. Phase 2: Environment setup
3. Phase 3: Flutter foundation
4. Phase 4: Backend foundation
5. Phase 5: Authentication
6. Phase 6: Citizen complaint reporting
7. Phase 7: Complaint tracking
8. Phase 8: Admin module
9. Phase 9: Worker module
10. Phase 10: Notifications and feedback
11. Phase 11: Offline-first synchronization
12. Phase 12: Analytics
13. Phase 13: Testing and quality
14. Phase 14: Documentation and presentation

### Definition of done

The project is considered complete when:

- The Flutter app runs without critical errors
- The express backend connects to MySQL successfully
- Authentication and authorization work for all roles
- Citizens can submit valid complaints with location and image evidence
- Admins can verify, assign, and track work
- Workers can update task progress and upload proof
- Notifications are visible and readable
- Feedback and ratings are implemented
- Offline queue sync survives reconnection
- Analytics charts display meaningful data
- Tests cover the major features
- Documentation and presentation materials are ready
