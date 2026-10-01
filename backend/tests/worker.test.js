const request = require('supertest');
const jwt = require('jsonwebtoken');
const config = require('../src/config/env');

jest.mock('../src/config/database', () => ({
  query: jest.fn(),
}));

const db = require('../src/config/database');
const app = require('../src/app');

function tokenFor(role) {
  return jwt.sign(
    { id: role === 'worker' ? 4 : 9, email: `${role}@example.com`, role },
    config.jwtSecret,
    { expiresIn: '1h' },
  );
}

describe('AquaGuard Worker API', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('returns only complaints assigned to the authenticated worker', async () => {
    const complaints = [{ id: 10, assigned_worker_id: 4, status: 'ASSIGNED' }];
    db.query
      .mockResolvedValueOnce([[{ id: 4, email: 'worker@example.com', role: 'worker', is_active: true }]])
      .mockResolvedValueOnce([complaints]);

    const response = await request(app)
      .get('/api/worker/complaints')
      .set('Authorization', `Bearer ${tokenFor('worker')}`);

    expect(response.status).toBe(200);
    expect(response.body.data).toEqual(complaints);
  });

  it('allows a worker to mark an assigned complaint in progress', async () => {
    db.query
      .mockResolvedValueOnce([[{ id: 4, email: 'worker@example.com', role: 'worker', is_active: true }]])
      .mockResolvedValueOnce([[{ status: 'ASSIGNED' }]])
      .mockResolvedValueOnce([{ affectedRows: 1 }])
      .mockResolvedValueOnce([{ affectedRows: 1 }]);

    const response = await request(app)
      .patch('/api/worker/complaints/10/status')
      .set('Authorization', `Bearer ${tokenFor('worker')}`)
      .send({ status: 'IN_PROGRESS', remarks: 'Repair team dispatched.' });

    expect(response.status).toBe(200);
    expect(response.body.data).toMatchObject({ id: 10, old_status: 'ASSIGNED', status: 'IN_PROGRESS' });
  });

  it('does not allow a worker to update an unassigned complaint', async () => {
    db.query
      .mockResolvedValueOnce([[{ id: 4, email: 'worker@example.com', role: 'worker', is_active: true }]])
      .mockResolvedValueOnce([[]]);

    const response = await request(app)
      .patch('/api/worker/complaints/99/status')
      .set('Authorization', `Bearer ${tokenFor('worker')}`)
      .send({ status: 'RESOLVED' });

    expect(response.status).toBe(404);
    expect(response.body.success).toBe(false);
  });

  it('blocks admins from worker endpoints', async () => {
    db.query.mockResolvedValueOnce([[{ id: 9, email: 'admin@example.com', role: 'admin', is_active: true }]]);

    const response = await request(app)
      .get('/api/worker/complaints')
      .set('Authorization', `Bearer ${tokenFor('admin')}`);

    expect(response.status).toBe(403);
  });
});