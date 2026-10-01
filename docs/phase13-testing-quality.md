# AquaGuard: Phase 13 Testing and Quality

## Phase title

## Phase 13: Testing and quality assurance

### 1. What we are building

This phase establishes repeatable quality checks for the backend and Flutter model layer. The tests cover successful workflows, role boundaries, validation failures, ownership rules, standard error responses, and analytics parsing.

### 2. Backend quality gates

The backend now provides:

- ESLint checking through `npm run lint`
- full Jest suite through `npm test`
- coverage command through `npm run test:coverage`
- API health check coverage
- unknown-route envelope coverage
- malformed-input coverage
- invalid workflow transition coverage
- authentication and role authorization coverage
- complaint, admin, worker, notification, feedback, and analytics coverage

### 3. Flutter quality checks

The mobile test suite includes model parsing tests for analytics data:

```powershell
cd "C:\Users\Renta\Downloads\clg lab projects\Flutter Lab\aquaguard\mobile"
flutter test
```

The tests verify analytics parsing, MySQL decimal coordinate strings, MySQL integer notification flags, and the AquaGuard home screen.

### 4. Verification commands

```powershell
cd "C:\Users\Renta\Downloads\clg lab projects\Flutter Lab\aquaguard\backend"
npm run lint
npm test -- --runInBand
npm run test:coverage
```

### 5. Files added or updated

```text
aquaguard/
├── backend/
│   ├── package.json
│   └── tests/quality.test.js
├── mobile/test/analytics_summary_test.dart
└── docs/phase13-testing-quality.md
```

### 6. Test checklist

- [ ] lint passes
- [ ] all backend suites pass
- [ ] API health responds successfully
- [ ] unknown routes use the standard error envelope
- [ ] malformed complaint input is rejected
- [ ] invalid worker transitions are rejected
- [ ] role boundaries are tested
- [ ] ownership boundaries are tested
- [ ] analytics parsing is tested
- [ ] coverage report can be generated

### 7. Verification results

Backend lint passed and all 26 API tests passed. Flutter analysis reported no issues and all 5 mobile tests passed on Flutter 3.47.5.

### 8. Academic explanation

Testing demonstrates that the application is reliable beyond the happy path. API tests protect security boundaries and data contracts, while model tests protect the translation between backend responses and the mobile interface. Coverage reports help identify untested code before deployment or presentation.

### 9. Stop

This is the end of Phase 13. Please confirm before starting Phase 14.
