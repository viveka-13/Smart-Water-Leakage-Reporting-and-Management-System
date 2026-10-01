# AquaGuard: Phase 4 Backend Foundation

## Phase title

## Phase 4: Backend foundation

### 1. What we are building

In this phase, we prepare the backend foundation for the AquaGuard project. We create the Express.js server, app configuration, MySQL connection setup, security middleware, validation structure, request logging, health endpoint, and database schema foundation.

This phase forms the API backbone that all future modules will build on, including authentication, complaint workflows, admin operations, worker actions, and analytics.

### 2. Architecture concept

The backend follows a modular server structure designed for maintainability:

- config: environment and database configuration
- middleware: logging, validation, error handling, security
- utils: reusable response helpers
- routes: endpoints grouped by feature
- app module: Express application bootstrap
- database: schema and seed scripts for MySQL

This design supports clean layering, easier testing, and future expansion without mixing business logic across the app.

### 3. Files and folders

The backend foundation files created are:

```text
aquaguard/backend/
├── .env.example
├── package.json
├── src/
│   ├── app.js
│   ├── server.js
│   ├── config/
│   │   ├── database.js
│   │   └── env.js
│   ├── middleware/
│   │   ├── errorHandler.js
│   │   ├── logger.js
│   │   └── validation.js
│   └── utils/
│       └── response.js
└── database/
    ├── schema.sql
    └── seeds/
        └── seed_data.sql
```

### 4. Complete code

The code is already created in the files shown above. It includes:

- Express app initialization
- environment-based configuration
- HTTP security with Helmet and CORS
- rate limiting
- JSON body parsing
- request logging
- global error handling
- MySQL connection pool
- base API response structure
- schema and seed SQL files

### 5. Commands

Use these Windows PowerShell commands:

```powershell
cd "C:\Users\Renta\Downloads\clg lab projects\Flutter Lab\aquaguard\backend"
npm install
npm run dev
```

To verify the health endpoint:

```powershell
Invoke-WebRequest http://localhost:3000/api/health
```

### 6. How to run

1. Open the backend folder.
2. Copy `.env.example` to `.env` and update values if needed.
3. Start MySQL and create the `aquaguard` database.
4. Run `npm install`.
5. Start the app with `npm run dev`.
6. Access `http://localhost:3000/api/health`.

### 7. Expected output

The backend should respond with a JSON status such as:

```json
{
  "success": true,
  "data": {
    "status": "ok",
    "service": "AquaGuard Backend",
    "timestamp": "..."
  },
  "error": null
}
```

### 8. Common errors

- Missing Node.js or npm
- MySQL not running
- `.env` values not matching local database setup
- Port 3000 already in use
- forgetting to create the `aquaguard` database before testing

Fixes:

```powershell
node -v
npm -v
Get-Service mysql
```

Or change the port in `.env`.

### 9. Test checklist

- [ ] `npm install` succeeds
- [ ] `npm run dev` starts without crashing
- [ ] `GET /api/health` returns success response
- [ ] rate limiting is active
- [ ] CORS and Helmet are enabled
- [ ] MySQL pool is configured correctly
- [ ] database schema file is ready for migration
- [ ] seed data file is ready for initial users and categories

### 10. Academic explanation

This phase shows how a real-world service-oriented application is built. The backend is the central component that supports user authentication, complaint logic, and data persistence. Creating the server, database layer, validation, and secure API structure demonstrates professional software engineering and prepares the project for later role-based features.

### 11. Stop

This is the end of Phase 4. Please confirm before moving to Phase 5.
