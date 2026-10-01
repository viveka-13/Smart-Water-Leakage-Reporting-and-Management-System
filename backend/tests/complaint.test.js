const request = require('supertest');
const jwt = require('jsonwebtoken');
const config = require('../src/config/env');

jest.mock('../src/config/database', () => ({
  query: jest.fn(),
}));

const db = require('../src/config/database');
const app = require('../src/app');

describe('AquaGuard Complaint API', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('creates a complaint for a valid citizen', async () => {
    const token = jwt.sign(
      { id: 1, email: 'citizen@example.com', role: 'citizen' },
      config.jwtSecret,
      { expiresIn: '1h' },
    );

    db.query
      .mockResolvedValueOnce([[{ id: 1, email: 'citizen@example.com', role: 'citizen', is_active: true }]])
      .mockResolvedValueOnce([{ insertId: 10 }]);

    const response = await request(app)
      .post('/api/complaints')
      .set('Authorization', `Bearer ${token}`)
      .send({
        title: 'Main pipe leaking near school',
        category: 'PIPE_LEAKAGE',
        description: 'The main water line is leaking heavily near the school gate.',
        priority: 'HIGH',
        latitude: 19.1234,
        longitude: 72.9876,
        address: 'Near ABC School, Pune',
      });

    expect(response.status).toBe(201);
    expect(response.body.success).toBe(true);
    expect(response.body.data.title).toBe('Main pipe leaking near school');
  });

  it('rejects complaint creation without a valid auth token', async () => {
    const response = await request(app)
      .post('/api/complaints')
      .send({
        title: 'Water issue',
        category: 'PIPE_LEAKAGE',
        description: 'Problem description',
      });

    expect(response.status).toBe(401);
    expect(response.body.success).toBe(false);
  });

  it('rejects coordinates outside valid geographic ranges', async () => {
    const token = jwt.sign(
      { id: 1, email: 'citizen@example.com', role: 'citizen' },
      config.jwtSecret,
      { expiresIn: '1h' },
    );
    db.query.mockResolvedValueOnce([[{ id: 1, email: 'citizen@example.com', role: 'citizen', is_active: true }]]);

    const response = await request(app)
      .post('/api/complaints')
      .set('Authorization', `Bearer ${token}`)
      .send({
        title: 'Pipe burst near market',
        category: 'PIPE_LEAKAGE',
        description: 'Water is leaking from a broken main pipe.',
        priority: 'HIGH',
        latitude: 14508,
        longitude: 23654,
        address: 'Kandkoya',
      });

    expect(response.status).toBe(400);
    expect(response.body.error.message).toBe('Latitude must be between -90 and 90.');
    expect(db.query).toHaveBeenCalledTimes(1);
  });

  it('lists complaints belonging to the authenticated citizen', async () => {
    const token = jwt.sign(
      { id: 1, email: 'citizen@example.com', role: 'citizen' },
      config.jwtSecret,
      { expiresIn: '1h' },
    );

    const complaints = [{
      id: 10,
      user_id: 1,
      title: 'Main pipe leaking near school',
      status: 'IN_PROGRESS',
    }];

    db.query
      .mockResolvedValueOnce([[{ id: 1, email: 'citizen@example.com', role: 'citizen', is_active: true }]])
      .mockResolvedValueOnce([complaints]);

    const response = await request(app)
      .get('/api/complaints/my')
      .set('Authorization', `Bearer ${token}`);

    expect(response.status).toBe(200);
    expect(response.body.data).toEqual(complaints);
  });

  it('returns a citizen complaint detail and hides another citizen complaint', async () => {
    const token = jwt.sign(
      { id: 1, email: 'citizen@example.com', role: 'citizen' },
      config.jwtSecret,
      { expiresIn: '1h' },
    );

    db.query
      .mockResolvedValueOnce([[{ id: 1, email: 'citizen@example.com', role: 'citizen', is_active: true }]])
      .mockResolvedValueOnce([[{ id: 10, user_id: 1, title: 'Main pipe leaking near school', status: 'REPORTED' }]]);

    const detailResponse = await request(app)
      .get('/api/complaints/10')
      .set('Authorization', `Bearer ${token}`);

    expect(detailResponse.status).toBe(200);
    expect(detailResponse.body.data.id).toBe(10);

    db.query
      .mockResolvedValueOnce([[{ id: 1, email: 'citizen@example.com', role: 'citizen', is_active: true }]])
      .mockResolvedValueOnce([[]]);

    const hiddenResponse = await request(app)
      .get('/api/complaints/99')
      .set('Authorization', `Bearer ${token}`);

    expect(hiddenResponse.status).toBe(404);
    expect(hiddenResponse.body.success).toBe(false);
  });
});
