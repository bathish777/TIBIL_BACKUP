import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { catchError, Observable } from 'rxjs';
import { environment } from 'src/environments/environment';

@Injectable({
  providedIn: 'root',
})
export class ApiService {
  private baseUrl = environment.SERVER_URL;

  constructor(private http: HttpClient) {}

  // Helper function to create headers with access token
  private getAccessHeaders(): HttpHeaders {
    const accessToken = localStorage.getItem('access_token'); // Retrieve access token from localStorage
    if (!accessToken) {
      console.error('Access token is missing');
    }
    return new HttpHeaders({
      Authorization: `Bearer ${accessToken}`, // Use Bearer token format
      'Content-Type': 'application/json', // Ensure content type is set
    });
  }

  // Helper function to create headers with guest token
  private getGuestHeaders(): HttpHeaders {
    const guestToken = localStorage.getItem('guest_token'); // Retrieve guest token from localStorage
    if (!guestToken) {
      console.error('Guest token is missing');
    }
    return new HttpHeaders({
      guest_token: guestToken || '', // Pass guest_token directly
    });
  }

  // Ping endpoint (no token required)
  ping(): Observable<any> {
    return this.http.get(`${this.baseUrl}/ping`);
  }

  // User initialization endpoint (no token required)
  getUserInit(): Observable<any> {
    return this.http.post(`${this.baseUrl}/user/init/get`, {});
  }

  // Terms and conditions endpoint (requires guest token)
  getTermsAndConditions(): Observable<any> {
    const headers = this.getGuestHeaders();
    return this.http.post(`${this.baseUrl}/user/tnc/get`, {}, { headers });
  }

  // User devices endpoint (requires guest token)
  getUserDevices(vmnCode: string): Observable<any> {
    const headers = this.getGuestHeaders();
    const body = { vmn_code: vmnCode };
    return this.http.post(`${this.baseUrl}/user/devices`, body, { headers });
  }

  // User accounts endpoint (requires guest token)
  getAccounts(mobile: string): Observable<any> {
    const headers = this.getGuestHeaders();
    const body = { mobile };
    return this.http.post(`${this.baseUrl}/user/accounts/get`, body, { headers });
  }

  // UPI QR code endpoint (requires guest token)
  getUpiQrCode(mobile: string): Observable<any> {
    const headers = this.getGuestHeaders();
    const body = { mobile };
    return this.http.post(`${this.baseUrl}/user/account/upi/get`, body, { headers });
  }

  // OTP generation endpoint (requires guest token)
  getOtp(mobile: string): Observable<any> {
    const headers = this.getGuestHeaders();
    const body = { mobile };
    return this.http.post(`${this.baseUrl}/user/otp`, body, { headers });
  }

  // OTP verification endpoint (requires guest token)
  updateOtp(body: {
    otp: number;
    mobile_number: string;
    device_id: string;
    identification: string;
  }): Observable<any> {
    const headers = this.getGuestHeaders();
    console.log('Request Body:', body); // Log request body for debugging
    return this.http.patch(`${this.baseUrl}/user/otp`, body, { headers });
  }

  // Secrets endpoint (requires guest token)
  getSecrets(mobile_number: string, mpin: string): Observable<any> {
    const headers = this.getGuestHeaders(); // Use guest_token here
    const body = { mobile_number, mpin };
    return this.http.post(`${this.baseUrl}/user/secrets`, body, { headers });
  }

  // User preferences endpoint (requires access token)
  updatePreferences(): Observable<any> {
    const headers = this.getAccessHeaders();
    return this.http.put(`${this.baseUrl}/user/preferences`, {}, { headers });
  }

  // Get all payments endpoint (requires access token)
  getAllPayments(
    uuid: string,
    vpa: string,
    options?: {
      fromDateTime?: string;
      toDateTime?: string;
      offset?: number;
      limit?: number;
      lastPid?: number;
    }
  ): Observable<any> {
    const headers = this.getAccessHeaders();
    const date = new Date().toISOString(); // Add current date
    const body = { uuid, vpa, date, ...options }; // Include date in the body

    return this.http.post(`${this.baseUrl}/payment/get`, body, { headers }).pipe(
      catchError((error) => {
        console.error('Error fetching payments:', error);
        throw error; // Re-throw the error for further handling
      })
    );
  }

  // Get payment summary endpoint (requires access token)
  getPaymentSummary(uuid: string, vpa: string, date: string): Observable<any> {
    const headers = this.getAccessHeaders();
    const body = { uuid, vpa, date };

    console.log('Making API call to /payment/summary/get');
    console.log('Request Body:', body);
    console.log('Request Headers:', headers);

    return this.http.post(`${this.baseUrl}/payment/summary/get`, body, { headers });
  }
}