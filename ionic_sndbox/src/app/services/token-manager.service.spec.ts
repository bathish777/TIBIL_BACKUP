import { TestBed } from '@angular/core/testing';
import { TokenManagerService } from './token-manager.service';

describe('TokenManagerService', () => {
  let service: TokenManagerService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(TokenManagerService);
    localStorage.clear(); // Clear localStorage before each test
  });

  afterEach(() => {
    localStorage.clear(); // Clear localStorage after each test
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  it('should set and get guest token', () => {
    service.setGuestToken('guest123');
    expect(localStorage.getItem('guest_token')).toBe('guest123');
    expect(service.getGuestToken()).toBe('guest123');
  });

  it('should set and get access token', () => {
    service.setAccessToken('access123');
    expect(service.getAccessToken()).toBe('access123');
  });

  it('should return access token when both tokens exist', () => {
    service.setGuestToken('guest123');
    service.setAccessToken('access123');
    expect(service.getCurrentToken()).toBe('access123');
  });

  it('should return guest token if access token is not set', () => {
    service.setGuestToken('guest123');
    expect(service.getCurrentToken()).toBe('guest123');
  });

  it('should return null if no token exists', () => {
    expect(service.getCurrentToken()).toBeNull();
  });

  it('should clear guest token only', () => {
    service.setGuestToken('guest123');
    service.setAccessToken('access123');
    service.clearGuestToken();
    expect(localStorage.getItem('guest_token')).toBeNull();
    expect(service.getAccessToken()).toBe('access123'); // Access token should still exist
  });

  it('should clear access token only', () => {
    service.setGuestToken('guest123');
    service.setAccessToken('access123');
    service.clearAccessToken();
    expect(service.getAccessToken()).toBeNull();
    expect(localStorage.getItem('guest_token')).toBe('guest123'); // Guest token should still exist
  });

  it('should clear all tokens', () => {
    service.setGuestToken('guest123');
    service.setAccessToken('access123');
    service.clearTokens();
    expect(localStorage.getItem('guest_token')).toBeNull();
    expect(service.getAccessToken()).toBeNull();
  });

  it('should save guest token from API response', () => {
    const response = { data: { guest_token: 'guestFromResponse' } };
    service.saveGuestTokenFromResponse(response);
    expect(localStorage.getItem('guest_token')).toBe('guestFromResponse');
  });

  it('should not save guest token if response does not contain it', () => {
    const response = { data: {} };
    service.saveGuestTokenFromResponse(response);
    expect(localStorage.getItem('guest_token')).toBeNull();
  });

  it('should save access token from API response', () => {
    const response = { data: { access_token: 'accessFromResponse' } };
    service.saveAccessTokenFromResponse(response);
    expect(service.getAccessToken()).toBe('accessFromResponse');
  });

  it('should not save access token if response does not contain it', () => {
    const response = { data: {} };
    service.saveAccessTokenFromResponse(response);
    expect(service.getAccessToken()).toBeNull();
  });
});