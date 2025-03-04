
import { Injectable } from '@angular/core';
import * as CryptoJS from 'crypto-js';

@Injectable({
  providedIn: 'root'
})
export class LocalStorageService {
  clear() {
    throw new Error('Method not implemented.');
  }
  private secretKey: string = 'dmsSoundboxmobileinformation';

  constructor() { }

  // Encrypt and store data*
  setItem(key: string, value: any): void {
    const encryptedValue = CryptoJS.AES.encrypt(JSON.stringify(value), this.secretKey).toString();
    localStorage.setItem(key, encryptedValue);
  }

  // Decrypt and retrieve data
  getItem(key: string): any {
    console.log("error here only /.......")
    const encryptedValue = localStorage.getItem(key);
    if (encryptedValue) {
      try {
        const bytes = CryptoJS.AES.decrypt(encryptedValue, this.secretKey);
        const decryptedValue = bytes.toString(CryptoJS.enc.Utf8);
        return JSON.parse(decryptedValue);
      } catch (error) {
        console.error('Decryption error:', error,key);
        
        return null;
      }
    }
    return null;
  }

  // Remove item from local storage
 removeItem(key: string): void {
    localStorage.removeItem(key);
 }
  

  // Decrypt VMN list, extract VMN code, and store separately
  extractAndStoreVmnCode(): void {
    const vmnList = this.getItem('vmn_list');
    if (Array.isArray(vmnList) && vmnList.length > 0) {
      const vmnCode = vmnList[0]?.vmn_code || null;
      if (vmnCode) {
        this.setItem('vmn_code', vmnCode);
      } else {
        console.warn('VMN code not found in the list.');
      }
    } else {
      console.warn('VMN list is empty or invalid.');
    }
  }
} 

// Usage example:
// this.storageService.extractAndStoreVmnCode();
// const vmnCode = this.storageService.getItem('vmn_code');
