import jwt from 'jsonwebtoken';
import middleware from '../../middlewares/autenticarToken.js';

jest.mock('jsonwebtoken', () => ({
  verify: jest.fn(),
}));

describe('Authentication Middleware', () => {
  let mockRequest;
  let mockResponse;
  let nextFunction;

  beforeEach(() => {
    mockRequest = {
      cookies: {
        token: null,
      },
      method: '',
    };
    mockResponse = {
      clearCookie: jest.fn(),
      redirect: jest.fn(),
      status: jest.fn().mockReturnThis(),
      json: jest.fn().mockReturnThis(),
    };
    nextFunction = jest.fn();
    jwt.verify.mockClear();
  });

  test('should verify token and call next on valid token', () => {
    const user = { id: '123', permissao: 'admin' };
    jwt.verify.mockImplementation(() => user);
    mockRequest.cookies.token = 'valid_token';
    middleware(mockRequest, mockResponse, nextFunction);
    expect(jwt.verify).toHaveBeenCalledWith('valid_token', 'segredo');
    expect(mockRequest.id).toBe(user.id);
    expect(mockRequest.permissao).toBe(user.permissao);
    expect(nextFunction).toHaveBeenCalled();
  });

  test('should clear cookie and redirect to login on GET request with invalid token', () => {
    jwt.verify.mockImplementation(() => {
      throw new Error('invalid token');
    });
    mockRequest.cookies.token = 'invalid_token';
    mockRequest.method = 'GET';
    middleware(mockRequest, mockResponse, nextFunction);
    expect(mockResponse.clearCookie).toHaveBeenCalledWith('token');
    expect(mockResponse.redirect).toHaveBeenCalledWith('/login');
  });

  test('should clear cookie and send 403 on non-GET request with invalid token', () => {
    jwt.verify.mockImplementation(() => {
      throw new Error('invalid token');
    });
    mockRequest.cookies.token = 'invalid_token';
    mockRequest.method = 'POST';
    middleware(mockRequest, mockResponse, nextFunction);
    expect(mockResponse.clearCookie).toHaveBeenCalledWith('token');
    expect(mockResponse.status).toHaveBeenCalledWith(403);
    expect(mockResponse.json).toHaveBeenCalledWith({ mensagem: 'Você não está logado' });
  });

  test('should redirect to login on GET request with no token', () => {
    mockRequest.method = 'GET';
    middleware(mockRequest, mockResponse, nextFunction);
    expect(mockResponse.redirect).toHaveBeenCalledWith('/login');
  });

  test('should send 403 on non-GET request with no token', () => {
    mockRequest.method = 'POST';
    middleware(mockRequest, mockResponse, nextFunction);
    expect(mockResponse.status).toHaveBeenCalledWith(403);
    expect(mockResponse.json).toHaveBeenCalledWith({ mensagem: 'Você não está logado' });
  });
});