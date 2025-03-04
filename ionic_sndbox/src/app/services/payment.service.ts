// import { Injectable } from '@angular/core';
// import { HttpClient, HttpHeaders } from '@angular/common/http';
// import { Observable, catchError, switchMap, throwError } from 'rxjs';
// import { AuthService } from './auth.service';
// import { environment } from 'src/environments/environment';

// @Injectable({
//   providedIn: 'root',
// })
// export class PaymentService {
//   private baseUrl = environment.SERVER_URL;

//   constructor(private http: HttpClient, private authService: AuthService) {}

//   // Helper method to get headers with access token
//   private getAccessHeaders(): HttpHeaders {
//     const accessToken = this.authService.getAccessToken(); // Retrieve the access token
//     if (!accessToken) {
//       throw new Error('Access token is missing');
//     }
//     return new HttpHeaders({
//       'Content-Type': 'application/json',
//       Authorization: `Bearer ${accessToken}`,
//     });
//   }

//   // Fetch all payments
//   getAllPayments(
//     uuid: string,
//     vpa: string,
//     options?: {
//       fromDateTime?: string;
//       toDateTime?: string;
//       offset?: number;
//       limit?: number;
//       lastPid?: number;
//     }
//   ): Observable<any> {
//     const date = new Date().toISOString(); // Add current date
//     const body = { uuid, vpa, date, ...options }; // Include date in the body

//     return this.authService.ensureAccessToken().pipe(
//       switchMap(() => {
//         const headers = this.getAccessHeaders();
//         return this.http.post(`${this.baseUrl}/payment/get`, body, { headers });
//       }),
//       catchError((error) => {
//         console.error('Error fetching payments:', error);
//         return throwError(() => error); // Re-throw the error for further handling
//       })
//     );
//   }

//   // Get payment summary
//   getPaymentSummary(uuid: string, vpa: string, date: string): Observable<any> {
//     return this.authService.ensureAccessToken().pipe(
//       switchMap(() => {
//         const headers = this.getAccessHeaders();
//         const body = { uuid, vpa, date };

//         console.log('Making API call to /payment/summary/get');
//         console.log('Request Body:', body);
//         console.log('Request Headers:', headers);

//         return this.http.post(`${this.baseUrl}/payment/summary/get`, body, { headers });
//       }),
//       catchError((error) => {
//         console.error('Error fetching payment summary:', error);
//         return throwError(() => error);
//       })
//     );
//   }
// }