# AquaGuard Architecture Overview

The project uses a layered architecture with Flutter frontend, Node.js API backend, and MySQL persistence.

## Planned layers

- Flutter UI layer
- Screen state and repository-driven presentation layer
- Repository layer
- Remote data source
- Local persistent storage
- Backend route, controller, service, and repository layers
- MySQL data access layer

## Design principles

- Repository as single source of truth
- UI separation from API logic
- Validation on both client and server
- Secure JWT authentication
- Role-based authorization
- Offline-first storage with queued synchronization

## Runtime flow

1. Flutter validates input and calls a repository.
2. The repository uses `ApiClient` and secure token storage.
3. Express middleware authenticates the JWT and authorizes the role.
4. Controllers delegate validation and business rules to services.
5. Repositories execute parameterized MySQL queries.
6. Status changes are recorded in `complaint_status_history`.

## Role boundaries

- Citizens create and track their own complaints, notifications, and feedback.
- Admins manage complaint status, assignments, workers, and analytics.
- Workers see and update only complaints assigned to them.
