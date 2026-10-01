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
    { id: role === 'admin' ? 9 : 1, email: `${role}@example.com`, role },
    config.jwtSecret,
    { expiresIn: '1h' },
  );
}

describe('AquaGuard Admin API', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('allows admins to filter complaints by status', async () => {
    const complaints = [{ id: 10, title: 'Pipe leak', status: 'REPORTED' }];
    db.query
      .mockResolvedValueOnce([[{ id: 9, email: 'admin@example.com', role: 'admin', is_active: true }]])
      .mockResolvedValueOnce([complaints]);

    const response = await request(app)
      .get('/api/admin/complaints?status=REPORTED')
      .set('Authorization', `Bearer ${tokenFor('admin')}`);

    expect(response.status).toBe(200);
    expect(response.body.data).toEqual(complaints);
  });

  it('blocks citizens from admin endpoints', async () => {
    db.query.mockResolvedValueOnce([[{ id: 1, email: 'citizen@example.com', role: 'citizen', is_active: true }]]);

    const response = await request(app)
      .get('/api/admin/complaints')
      .set('Authorization', `Bearer ${tokenFor('citizen')}`);

    expect(response.status).toBe(403);
    expect(db.query).toHaveBeenCalledTimes(1);
  });

  it('allows admins to update status and records the history entry', async () => {
    db.query
      .mockResolvedValueOnce([[{ id: 9, email: 'admin@example.com', role: 'admin', is_active: true }]])
      .mockResolvedValueOnce([[{ status: 'REPORTED' }]])
      .mockResolvedValueOnce([{ affectedRows: 1 }])
      .mockResolvedValueOnce([{ affectedRows: 1 }]);

    const response = await request(app)
      .patch('/api/admin/complaints/10/status')
      .set('Authorization', `Bearer ${tokenFor('admin')}`)
      .send({ status: 'VERIFIED', remarks: 'Evidence checked.' });

    expect(response.status).toBe(200);
    expect(response.body.data).toMatchObject({
      id: 10,
      old_status: 'REPORTED',
      status: 'VERIFIED',
    });
  });

  it('assigns a complaint only to an active worker', async () => {
    const worker = { id: 4, name: 'Field Worker', email: 'worker@example.com' };
    db.query
      .mockResolvedValueOnce([[{ id: 9, email: 'admin@example.com', role: 'admin', is_active: true }]])
      .mockResolvedValueOnce([[worker]])
      .mockResolvedValueOnce([{ affectedRows: 1 }]);

    const response = await request(app)
      .patch('/api/admin/complaints/10/assign')
      .set('Authorization', `Bearer ${tokenFor('admin')}`)
      .send({ workerId: 4 });

    expect(response.status).toBe(200);
    expect(response.body.data).toMatchObject({
      id: 10,
      assigned_worker_id: 4,
      status: 'ASSIGNED',
      worker,
    });
  });
});