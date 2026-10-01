# AquaGuard Testing Reference

The project uses Jest and Supertest for backend API quality checks and Flutter test for mobile model tests.

## Planned test coverage

- Flutter unit tests
- Widget tests
- Backend API tests
- Integration tests
- Linting checks
- Coverage reporting

## Commands

```powershell
cd backend
npm run lint
npm test -- --runInBand
npm run test:coverage

cd ../mobile
flutter analyze
flutter test
```

## Coverage target

The current backend coverage run reports 84.07% statement coverage. Flutter commands require the Flutter SDK, which is not installed in the current development environment.
