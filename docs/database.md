# AquaGuard Database Reference

The database uses MySQL 8 and is created from `database/schema.sql`. Docker configuration is provided in `docker-compose.yml`.

## Tables

- users
- complaints
- complaint_status_history
- notifications
- feedback
- activity_logs
- complaint_categories
- refresh_tokens

## Constraints and indexes

- Primary keys
- Foreign keys
- Indexes on status, priority, category, user_id, assigned_worker_id, and created_at
- Unique email constraint
- Parameterized SQL access
- Complaint status history records admin and worker changes.
- `synced_from_offline` identifies complaints delivered by the offline queue.
- Foreign keys protect users, complaints, workers, notifications, and feedback.

## Local setup

```powershell
docker compose up -d mysql
Get-Content .\database\schema.sql | docker exec -i aquaguard_mysql mysql -uroot -prootpassword
```

For production, replace the development root password and use a dedicated database user with only the required privileges.
