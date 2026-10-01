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

describe('AquaGuard quality checks', () => {
  beforeEach(() => jest.clearAllMocks());

  it('reports backend health', async () => {
    const response = await request(app).get('/api/health');

    expect(response.status).toBe(200);
    expect(response.body).toMatchObject({
      success: true,
      data: { status: 'ok', service: 'AquaGuard Backend' },
    });
  });

  it('returns the standard error envelope for unknown routes', async () => {
    const response = await request(app).get('/api/does-not-exist');

    expect(response.status).toBe(404);
    expect(response.body).toMatchObject({
      success: false,
      data: null,
      error: { message: 'Route not found' },
    });
  });

  it('rejects malformed complaint input before writing to the database', async () => {
    db.query.mockResolvedValueOnce([[{ id: 1, email: 'citizen@example.com', role: 'citizen', is_active: true }]]);

    const response = await request(app)
      .post('/api/complaints')
      .set('Authorization', `Bearer ${citizenToken()}`)
      .send({
        title: 'Leak',
        category: 'UNKNOWN_CATEGORY',
        description: 'Too short',
        latitude: 19,
        longitude: 73,
        address: 'Near school',
      });

    expect(response.status).toBe(400);
    expect(response.body.success).toBe(false);
    expect(db.query).toHaveBeenCalledTimes(1);
  });

  it('rejects an invalid worker status with a standard error', async () => {
    db.query.mockResolvedValueOnce([[{ id: 4, email: 'worker@example.com', role: 'worker', is_active: true }]]);

    const response = await request(app)
      .patch('/api/worker/complaints/10/status')
      .set('Authorization', `Bearer ${jwt.sign({ id: 4, role: 'worker' }, config.jwtSecret)}`)
      .send({ status: 'CLOSED' });

    expect(response.status).toBe(400);
    expect(response.body.error.message).toBe('Worker status is invalid.');
    expect(db.query).toHaveBeenCalledTimes(1);
  });
});