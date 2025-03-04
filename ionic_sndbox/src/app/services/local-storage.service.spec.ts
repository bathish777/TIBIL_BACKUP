import { TestBed } from '@angular/core/testing';
import { LocalStorageService } from './local-storage.service';
import * as CryptoJS from 'crypto-js';

describe('LocalStorageService', () => {
  let service: LocalStorageService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(LocalStorageService);
  });

  // Test for setItem method
  it('should store and encrypt data using setItem', () => {
    const key = 'testKey';
    const value = { test: 'value' };

    spyOn(localStorage, 'setItem'); // Spy on localStorage.setItem

    service.setItem(key, value);

    // Check if localStorage.setItem was called with encrypted data
    expect(localStorage.setItem).toHaveBeenCalledWith(
      key,
      jasmine.stringMatching(/^U2FsdGVkX1/) // Checking if the string starts with the encrypted header
    );
  });

  // Test for getItem method
  it('should decrypt and return data from getItem', () => {
    const key = 'testKey';
    const value = { test: 'value' };
    const encryptedValue = CryptoJS.AES.encrypt(JSON.stringify(value), service['secretKey']).toString();
    localStorage.setItem(key, encryptedValue);

    const result = service.getItem(key);

    expect(result).toEqual(value); // Expect the decrypted value to match the original value
  });

  it('should return null if decryption fails', () => {
    const key = 'testKey';
    const invalidEncryptedValue = 'invalidEncryptedData';
    localStorage.setItem(key, invalidEncryptedValue);

    const result = service.getItem(key);

    expect(result).toBeNull(); // Should return null if decryption fails
  });

  // Test for removeItem method
  it('should remove item from localStorage', () => {
    const key = 'testKey';
    spyOn(localStorage, 'removeItem'); // Spy on localStorage.removeItem

    service.removeItem(key);

    expect(localStorage.removeItem).toHaveBeenCalledWith(key); // Ensure removeItem was called with the correct key
  });

  // Test for extractAndStoreVmnCode method
  it('should extract and store vmnCode from vmn_list', () => {
    const vmnList = [{ vmn_code: '1234' }];
    service.setItem('vmn_list', vmnList);

    spyOn(service, 'setItem'); // Spy on setItem to check if vmnCode is stored

    service.extractAndStoreVmnCode();

    expect(service.setItem).toHaveBeenCalledWith('vmn_code', '1234'); // Ensure the vmnCode is stored
  });

  it('should not store vmnCode if vmn_list is empty or invalid', () => {
    service.setItem('vmn_list', []);
    spyOn(service, 'setItem'); // Spy on setItem to check if vmnCode is stored
  
    service.extractAndStoreVmnCode();
  
    // Expect the setItem not to be called with 'vmn_code' and any value.
    expect(service.setItem).not.toHaveBeenCalledWith('vmn_code', jasmine.anything());
  });
  
});
