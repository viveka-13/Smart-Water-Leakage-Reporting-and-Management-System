const request = require('supertest');

jest.mock('../src/config/database', () => ({
  query: jest.fn(),
}));

const db = require('../src/config/database');
const app = require('../src/app');

describe('AquaGuard Auth API', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('registers a citizen with valid data', async () => {
    db.query
      .mockResolvedValueOnce([[]])
      .mockResolvedValueOnce([{ insertId: 1 }]);

    const response = await request(app)
      .post('/api/auth/register')
      .send({
        name: 'Citizen User',
        email: 'citizen@example.com',
        password: 'StrongPass123',
        phone: '9876543210',
        role: 'citizen',
      });

    expect(response.status).toBe(201);
    expect(response.body.success).toBe(true);
    expect(response.body.data.user.email).toBe('citizen@example.com');
    expect(response.body.data.user.role).toBe('citizen');
  });

  it('does not allow public registration to assign an elevated role', async () => {
    db.query
      .mockResolvedValueOnce([[]])
      .mockResolvedValueOnce([{ insertId: 2 }]);

    const response = await request(app)
      .post('/api/auth/register')
      .send({
        name: 'Unexpected Admin',
        email: 'unexpected-admin@example.com',
        password: 'StrongPass123',
        role: 'admin',
      });

    expect(response.status).toBe(201);
    expect(response.body.data.user.role).toBe('citizen');
  });

  it('rejects duplicate registration email', async () => {
    db.query.mockResolvedValueOnce([[{ id: 99 }]]);

    const response = await request(app)
      .post('/api/auth/register')
      .send({
        name: 'Duplicate User',
        email: 'duplicate@example.com',
        password: 'StrongPass123',
      });

    expect(response.status).toBe(409);
    expect(response.body.success).toBe(false);
  });

  it('logs in a valid user', async () => {
    db.query.mockResolvedValueOnce([[{
      id: 2,
      name: 'Login User',
      email: 'login@example.com',
      password_hash: '$2a$10$06Q0Bqnuybk1KEHZwAy56.zmQ8WGwMluGrYNrW7SCn3.V25dmW85i',
      role: 'citizen',
      is_active: true,
    }]]);

    const response = await request(app)
      .post('/api/auth/login')
      .send({
        email: 'login@example.com',
        password: 'StrongPass123',
      });

    expect(response.status).toBe(200);
    expect(response.body.success).toBe(true);
    expect(response.body.data.token).toBeTruthy();
  });
});
