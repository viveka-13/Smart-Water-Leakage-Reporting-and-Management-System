const request = require('supertest');
const jwt = require('jsonwebtoken');
const config = require('../src/config/env');

jest.mock('../src/config/database', () => ({
  query: jest.fn(),
}));

const db = require('../src/config/database');
const app = require('../src/app');

function citizenToken() {
  return jwt.sign({ id: 1, email: 'citizen@example.com', role: 'citizen' }, config.jwtSecret, { expiresIn: '1h' });
}

describe('AquaGuard Phase 10 API', () => {
  beforeEach(() => jest.clearAllMocks());

  it('lists only the authenticated user notifications and marks one read', async () => {
    const notifications = [{ id: 7, user_id: 1, title: 'Complaint updated', is_read: false }];
    db.query
      .mockResolvedValueOnce([[{ id: 1, email: 'citizen@example.com', role: 'citizen', is_active: true }]])
      .mockResolvedValueOnce([notifications]);

    const listResponse = await request(app)
      .get('/api/notifications')
      .set('Authorization', `Bearer ${citizenToken()}`);

    expect(listResponse.status).toBe(200);
    expect(listResponse.body.data).toEqual(notifications);

    db.query
      .mockResolvedValueOnce([[{ id: 1, email: 'citizen@example.com', role: 'citizen', is_active: true }]])
      .mockResolvedValueOnce([{ affectedRows: 1 }]);

    const readResponse = await request(app)
      .patch('/api/notifications/7/read')
      .set('Authorization', `Bearer ${citizenToken()}`);

    expect(readResponse.status).toBe(200);
    expect(readResponse.body.data).toEqual({ id: 7, is_read: true });
  });

  it('accepts feedback for a resolved complaint', async () => {
    db.query
      .mockResolvedValueOnce([[{ id: 1, email: 'citizen@example.com', role: 'citizen', is_active: true }]])
      .mockResolvedValueOnce([[{ id: 10, status: 'RESOLVED' }]])
      .mockResolvedValueOnce([[]])
      .mockResolvedValueOnce([{ insertId: 21 }]);

    const response = await request(app)
      .post('/api/feedback/complaints/10')
      .set('Authorization', `Bearer ${citizenToken()}`)
      .send({ rating: 5, comment: 'The repair was completed quickly.' });

    expect(response.status).toBe(201);
    expect(response.body.data).toMatchObject({ complaint_id: 10, rating: 5 });
  });

  it('rejects feedback for an unresolved complaint', async () => {
    db.query
      .mockResolvedValueOnce([[{ id: 1, email: 'citizen@example.com', role: 'citizen', is_active: true }]])
      .mockResolvedValueOnce([[{ id: 10, status: 'IN_PROGRESS' }]]);

    const response = await request(app)
      .post('/api/feedback/complaints/10')
      .set('Authorization', `Bearer ${citizenToken()}`)
      .send({ rating: 4 });

    expect(response.status).toBe(400);
    expect(response.body.success).toBe(false);
  });
});