import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root',
})
export class TokenManagerService {
  private guestTokenKey = 'guest_token'; // Still stored in localStorage
  private accessToken: string | null = null; // Store access token in memory

  constructor() {}

  // Set the guest token in localStorage
  setGuestToken(token: string): void {
    localStorage.setItem(this.guestTokenKey, token);
  }

  // Set the access token in memory
  setAccessToken(token: string): void {
    this.accessToken = token;
    console.log('Access Token Set:', token); // Debug log
  }

  // Get the guest token from localStorage
  getGuestToken(): string | null {
    return localStorage.getItem(this.guestTokenKey);
  }

  // Get the access token from memory
  getAccessToken(): string | null {
    console.log('Access Token Retrieved:', this.accessToken); // Debug log
    return this.accessToken;
  }

  // Get the current token (access token takes precedence over guest token)
  getCurrentToken(): string | null {
    return this.getAccessToken() || this.getGuestToken();
  }

  // Clear the guest token from localStorage
  clearGuestToken(): void {
    localStorage.removeItem(this.guestTokenKey);
  }

  // Clear the access token from memory
  clearAccessToken(): void {
    console.log('Access Token Cleared'); // Debug log
    this.accessToken = null;
  }

  // Clear all tokens (guest token from localStorage and access token from memory)
  clearTokens(): void {
    this.clearGuestToken();
    this.clearAccessToken();
  }

  // Dynamically save the guest token from API response
  saveGuestTokenFromResponse(response: any): void {
    const guestToken = response?.data?.guest_token;
    if (guestToken) {
      this.setGuestToken(guestToken);
    }
  }

  // Dynamically save the access token from API response
  saveAccessTokenFromResponse(response: any): void {
    const accessToken = response?.data?.access_token;
    if (accessToken) {
      this.setAccessToken(accessToken);
    }
  }
}