import { TestBed } from '@angular/core/testing';
import { StorageService, APP_TOKEN } from './storage.service';
import { Preferences } from '@capacitor/preferences';
import { of } from 'rxjs';

describe('StorageService', () => {
  let service: StorageService;
  let preferencesMock: jasmine.SpyObj<typeof Preferences>;

  beforeEach(() => {
    // Create a mock of Preferences
    preferencesMock = jasmine.createSpyObj('Preferences', ['set', 'get', 'remove', 'clear']);

    // Override the provider for Preferences with our mock
    TestBed.configureTestingModule({
      providers: [
        StorageService,
        { provide: Preferences, useValue: preferencesMock }
      ]
    });

    service = TestBed.inject(StorageService);

    // Set default return values for the mock methods
    preferencesMock.set.and.returnValue(Promise.resolve());
    preferencesMock.get.and.returnValue(Promise.resolve({ value: 'test_value' }));
    preferencesMock.remove.and.returnValue(Promise.resolve());
    preferencesMock.clear.and.returnValue(Promise.resolve());
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  // describe('setStorage', () => {
  //   it('should call Preferences.set with correct parameters', async () => {
  //     const key = 'test_key';
  //     const value = 'test_value';
  //     await service.setStorage(key, value);
  //     expect(preferencesMock.set).toHaveBeenCalledWith({ key: key, value: value });
  //   });
  // });

  // describe('getStorage', () => {
  //   it('should return the value from Preferences.get', async () => {
  //     const key = 'test_key';
  //     const expectedValue = 'test_value';

  //     const result = await service.getStorage(key);
  //     expect(preferencesMock.get).toHaveBeenCalledWith({ key });
  //     expect(result).toEqual({ value: expectedValue });
  //   });
  // });

  // describe('removeStorage', () => {
  //   it('should call Preferences.remove with the correct key', async () => {
  //     const key = 'test_key';
  //     await service.removeStorage(key);
  //     expect(preferencesMock.remove).toHaveBeenCalledWith({ key });
  //   });
  // });

  // describe('clearStorage', () => {
  //   it('should call Preferences.clear', async () => {
  //     await service.clearStorage();
  //     expect(preferencesMock.clear).toHaveBeenCalled();
  //   });
  // });

  describe('getToken', () => {
    it('should return an Observable of the token', (done) => {
      const token = 'sample_token';
      spyOn(service, 'getStorage').and.returnValue(Promise.resolve({ value: token }));
      
      service.getToken().subscribe(result => {
        expect(result).toEqual({ value: token });
        done();
      });
    });
  });

  describe('removeItem', () => {
    it('should call localStorage.removeItem with the correct key', () => {
      const removeItemSpy = spyOn(localStorage, 'removeItem');
      const key = 'test_key';
      service.removeItem(key);
      expect(removeItemSpy).toHaveBeenCalledWith(key);
    });
  });
});
