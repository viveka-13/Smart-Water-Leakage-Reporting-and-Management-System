# AquaGuard: Phase 5 Authentication

## Phase title

## Phase 5: Authentication

### 1. What we are building

This phase implements the authentication layer of AquaGuard. The backend now supports:

- user registration
- login with password verification
- JWT generation and validation
- secure token handling
- current-user retrieval
- protected routes
- role-aware authorization
- basic authentication tests

This is the foundation for all later user-specific modules, including citizen complaint creation, worker task updates, and admin management.

### 2. Architecture concept

Authentication sits between the request layer and the application domain layer. It verifies identity, reads user role, and decides whether the caller may access protected resources.

The implementation uses:

- bcrypt for password hashing
- JWT for token generation
- Express middleware for route protection
- repository-based user lookup
- centralized response helpers for status-safe API responses

### 3. Files and folders

```text
aquaguard/backend/
├── .eslintrc.json
├── src/
│   ├── controllers/
│   │   └── authController.js
│   ├── middleware/
│   │   └── auth.js
│   ├── repositories/
│   │   └── userRepository.js
│   ├── routes/
│   │   └── authRoutes.js
│   ├── services/
│   │   └── authService.js
│   └── app.js
└── tests/
    └── auth.test.js
```

### 4. Complete code

The authentication implementation is present in the files above and includes:

- registration flow
- login flow
- JWT token signing
- protected route middleware
- authorization helper for role checks
- real test coverage for auth endpoints

### 5. Commands

```powershell
cd "C:\Users\Renta\Downloads\clg lab projects\Flutter Lab\aquaguard\backend"
npm install
npm test -- --runInBand
npm run lint
```

### 6. How to run

1. Start the backend server.
2. Use Postman or curl to test the auth endpoints.
3. Register a user with a valid email and password.
4. Log in to receive the JWT token.
5. Use the token in the Authorization header as `Bearer <token>`.
6. Call `/api/auth/me` to fetch the current user.

### 7. Expected output

A successful registration returns JSON similar to:

```json
{
  "success": true,
  "data": {
    "user": {
      "id": 1,
      "name": "Citizen User",
      "email": "citizen@example.com",
      "role": "citizen"
    },
    "token": "...jwt..."
  },
  "error": null
}
```

### 8. Common errors

- email already exists
- invalid password format
- invalid JWT token
- expired token
- missing Authorization header
- inactive account

### 9. Test checklist

- [ ] registration succeeds with valid data
- [ ] duplicate email is rejected
- [ ] login succeeds with correct credentials
- [ ] invalid credentials return an unauthorized response
- [ ] JWT protected route works
- [ ] role-based checks are enforced
- [ ] lint runs without errors

### 10. Academic explanation

Authentication is one of the most important parts of any secure digital system. AquaGuard uses user roles to control who can access what information, such as citizen complaint forms, field-worker task updates, and admin activities. This demonstrates secure design, role-based access, and proper token handling in a real-world mobile and backend ecosystem.

### 11. Stop

This is the end of Phase 5. Please confirm before moving to Phase 6.
