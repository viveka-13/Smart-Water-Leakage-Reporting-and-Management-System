# AquaGuard: Phase 14 Documentation and Presentation

## Phase title

## Phase 14: Documentation, deployment, and presentation readiness

### 1. Project summary

AquaGuard is a role-based smart water leakage reporting and management system. Citizens report water issues with location details, administrators verify and assign work, field workers update repair progress, and citizens receive notifications and submit resolution feedback.

### 2. Implemented capabilities

- JWT authentication with bcrypt password hashing
- citizen complaint reporting and ownership-scoped tracking
- admin complaint filtering, status management, worker assignment, and analytics
- worker assigned-task dashboard and progress updates
- notifications and read state
- resolution feedback and rating
- offline complaint queue and retry service
- MySQL schema with status history, notifications, feedback, and activity-ready tables
- backend API tests, linting, and coverage reporting

### 3. Local deployment

#### Start MySQL

```powershell
cd "C:\Users\Renta\Downloads\clg lab projects\Flutter Lab\aquaguard"
docker compose up -d mysql
Get-Content .\database\schema.sql | docker exec -i aquaguard_mysql mysql -uroot -prootpassword
```

#### Configure and start the backend

```powershell
cd backend
Copy-Item .env.example .env
npm install
npm run lint
npm test -- --runInBand
npm start
```

The backend listens on `http://localhost:3000` by default. The health endpoint is `GET /api/health`.

#### Configure and start Flutter

```powershell
cd mobile
flutter pub get
flutter analyze
flutter test
flutter run
```

For an Android emulator, the default API base URL is `http://10.0.2.2:3000/api`. For a physical device, use the development computer's LAN IP and update `ApiClient`.

### 4. Presentation flow

1. Explain the civic problem and AquaGuard objectives.
2. Show the three roles: citizen, admin, and field worker.
3. Demonstrate citizen complaint creation and location data.
4. Demonstrate tracking, notifications, and feedback.
5. Demonstrate admin analytics, status management, and assignment.
6. Demonstrate worker task progress and resolution.
7. Explain offline queue behavior.
8. Show architecture layers and database relationships.
9. Show test results and security controls.

### 5. Viva questions and answers

#### Why use JWT?

JWT provides stateless API authentication. The role in the verified user record is used by route authorization middleware to separate citizen, admin, and worker operations.

#### How is ownership protected?

Citizen detail and feedback queries include the authenticated user ID. Worker queries include `assigned_worker_id`, so changing an ID in the URL cannot expose or modify another user's record.

#### Why is offline synchronization needed?

Water issues may be reported from locations with unreliable connectivity. The mobile app saves validated payloads locally and retries them later instead of losing the report.

#### How are status changes audited?

Every admin or worker status update creates a `complaint_status_history` record containing the previous status, new status, actor, remarks, and timestamp.

#### How is the system tested?

Backend behavior is tested with Jest and Supertest, linted with ESLint, and measured with Jest coverage. Flutter model parsing has unit tests and the mobile source has editor diagnostics.

### 6. Security checklist

- [ ] Replace development `JWT_SECRET` before deployment
- [ ] Use a non-root production MySQL user
- [ ] Set a restricted `CORS_ORIGIN`
- [ ] Use HTTPS in production
- [ ] Keep `.env` out of source control
- [ ] Review upload limits and file validation before enabling uploads
- [ ] Rotate database and JWT secrets when needed
- [ ] Keep dependencies updated

### 7. Final verification status

- Backend lint: passed
- Backend tests: 26 passed
- Backend statement coverage: 84.07%
- Flutter analyzer: no issues found
- Flutter tests: 5 passed
- Flutter Web: served at `http://localhost:8080` and visually checked in Chrome
- MySQL: schema and demo records loaded; citizen/admin/worker endpoints manually verified

### 8. Known limitations

- Image upload and production push notifications need platform credentials and device testing.
- Automated Jest tests use mocked database calls; the seeded local MySQL workflow was also manually verified, but staging verification is still recommended.
- Browser geolocation requires the user to grant location permission and use a secure origin such as localhost or HTTPS.
- The development Docker credentials must not be reused in production.

### 9. Definition of done

AquaGuard is ready for academic demonstration when the backend tests pass, the database starts, Flutter dependencies resolve, the mobile app runs on an emulator or device, and the three role workflows can be demonstrated end to end.

### 10. Stop

This is the end of Phase 14 and the end of the planned implementation roadmap.
