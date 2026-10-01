# AquaGuard API Reference

Base URL: `http://localhost:3000/api`

## Response structure

All successful responses use:

```json
{
  "success": true,
  "data": {},
  "error": null,
  "message": "..."
}
```

## Endpoints

### Authentication

- `POST /auth/register`
- `POST /auth/login`

### Citizen complaints

- `POST /complaints`
- `GET /complaints/my`
- `GET /complaints/:id`

Required complaint fields: `title`, `category`, `description`, `priority`, `latitude`, `longitude`, and `address`.

### Admin

Admin JWT required:

- `GET /admin/complaints?status=&priority=`
- `GET /admin/workers`
- `GET /admin/analytics/summary`
- `PATCH /admin/complaints/:id/status`
- `PATCH /admin/complaints/:id/assign`

### Worker

Worker JWT required:

- `GET /worker/complaints`
- `PATCH /worker/complaints/:id/status`

Workers can update assigned complaints to `IN_PROGRESS` or `RESOLVED`.

### Notifications and feedback

- `GET /notifications`
- `PATCH /notifications/:id/read`
- `POST /feedback/complaints/:complaintId`

Feedback accepts a rating from 1 to 5 and is available after resolution.

### Health

- `GET /health`

## Security plan

- JWT authentication
- bcrypt password hashing
- request validation
- rate limiting
- CORS protection
- safe error messages
