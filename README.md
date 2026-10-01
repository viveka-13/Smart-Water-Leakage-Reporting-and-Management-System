# AquaGuard

AquaGuard is a smart water leakage reporting and management system designed for civic water utilities, municipal workers, and concerned citizens. The project focuses on real-world water-issue reporting, complaint tracking, worker assignment, analytics, and offline-first synchronization.

## Project status

Phases 1 through 14 are documented. The backend is verified with MySQL, linting, and Jest API tests. The Flutter web application has been run and checked in a browser.

## Project overview

- Mobile app: Flutter + Dart
- Backend: Node.js + Express.js
- Database: MySQL
- Architecture: Layered, role-based, repository-driven system
- Features: browser geolocation, citizen complaint tracking, admin workflow, field-worker tracking, notifications, analytics, offline sync

## Core roles

1. Citizen
2. Field Worker
3. Administrator

## Repository structure

- `aquaguard/mobile/` for the Flutter app
- `aquaguard/backend/` for the Express API
- `aquaguard/database/` for schema and seed scripts
- `aquaguard/docs/` for architecture, API, testing, and phase documentation

## Backend verification

```powershell
cd "aquaguard/backend"
npm install
npm run lint
npm test -- --runInBand
npm run test:coverage
```

## Mobile verification

```powershell
cd "aquaguard/mobile"
flutter pub get
flutter analyze
flutter test
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
```

Open `http://localhost:8080` in Chrome while the Flutter command remains running.

## Database startup

```powershell
cd "aquaguard"
docker compose up -d mysql
Get-Content .\database\schema.sql | docker exec -i aquaguard_mysql mysql -uroot -prootpassword
```

## Academic demo startup

After starting MySQL and applying the schema:

```powershell
cd "aquaguard/backend"
npm install
npm run seed:demo
$env:PORT = '3001'
npm start
```

In a second terminal:

```powershell
cd "aquaguard/mobile"
flutter pub get
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
```

Open `http://localhost:8080`. Demo password for all roles: `AquaGuard123!`.

- Citizen: `citizen@aquaguard.demo`
- Admin: `admin@aquaguard.demo`
- Worker: `worker@aquaguard.demo`

Change the development `JWT_SECRET` before using the backend outside an academic local demo.
