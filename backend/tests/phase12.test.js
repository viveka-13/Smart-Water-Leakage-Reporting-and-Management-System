const request = require('supertest');
const jwt = require('jsonwebtoken');
const config = require('../src/config/env');

jest.mock('../src/config/database', () => ({
  query: jest.fn(),
}));

const db = require('../src/config/database');
const app = require('../src/app');

function tokenFor(role) {
  return jwt.sign({ id: role === 'admin' ? 9 : 1, email: `${role}@example.com`, role }, config.jwtSecret, { expiresIn: '1h' });
}

describe('AquaGuard Phase 12 Analytics API', () => {
  beforeEach(() => jest.clearAllMocks());

  it('returns admin analytics aggregates', async () => {
    db.query
      .mockResolvedValueOnce([[{ id: 9, email: 'admin@example.com', role: 'admin', is_active: true }]])
      .mockResolvedValueOnce([[{ total_complaints: 8, open_complaints: 5, resolved_complaints: 3, average_resolution_hours: 18.5 }]])
      .mockResolvedValueOnce([[{ average_rating: 4.5, feedback_count: 2 }]])
      .mockResolvedValueOnce([[{ status: 'IN_PROGRESS', count: 3 }]])
      .mockResolvedValueOnce([[{ priority: 'HIGH', count: 4 }]])
      .mockResolvedValueOnce([[{ category: 'PIPE_LEAKAGE', count: 5 }]]);

    const response = await request(app)
      .get('/api/admin/analytics/summary')
      .set('Authorization', `Bearer ${tokenFor('admin')}`);

    expect(response.status).toBe(200);
    expect(response.body.data.summary).toMatchObject({
      total_complaints: 8,
      resolved_complaints: 3,
      average_rating: 4.5,
    });
    expect(response.body.data.by_category[0]).toEqual({ category: 'PIPE_LEAKAGE', count: 5 });
  });

  it('blocks non-admin analytics access', async () => {
    db.query.mockResolvedValueOnce([[{ id: 1, email: 'citizen@example.com', role: 'citizen', is_active: true }]]);

    const response = await request(app)
      .get('/api/admin/analytics/summary')
      .set('Authorization', `Bearer ${tokenFor('citizen')}`);

    expect(response.status).toBe(403);
  });
});