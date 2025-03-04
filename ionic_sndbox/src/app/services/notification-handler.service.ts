import { Injectable } from '@angular/core';
import { ApiService } from './api.service';
import { FcmService } from './fcm.service';
import { interval } from 'rxjs';
import { LocalStorageService } from '../services/local-storage.service';

@Injectable({
  providedIn: 'root',
})
export class NotificationHandlerService {
  private lastPaymentId: number | null = null;
  private processedPayments = new Set<number>(); // Track processed payments
  private pollingIntervalSecs: number = 30; // Default polling interval

  constructor(
    private apiService: ApiService,
    private fcmService: FcmService,
    private localStorageService: LocalStorageService
  ) {
    // Initialize polling interval from local storage
    this.initializePollingInterval();
  }

  /**
   * Initialize the polling interval from local storage.
   * If not found, use the default value (30 seconds).
   */
  private initializePollingInterval(): void {
    const storedInterval = this.localStorageService.getItem('poll_interval_secs');
    if (storedInterval) {
      this.pollingIntervalSecs = parseInt(storedInterval, 10);
    }
    console.log(`[INFO] Polling interval set to: ${this.pollingIntervalSecs} seconds`);
  }

  /**
   * Start polling for new payments at the configured interval.
   */
  startPolling(): void {
    // Start polling with the configured interval
    interval(this.pollingIntervalSecs * 1000).subscribe(() => this.checkForNewPayments());
  }

  /**
   * Check for new payments and process them.
   */
  private async checkForNewPayments(): Promise<void> {
    try {
      // Retrieve required data from localStorage
      const uuid = this.localStorageService.getItem('uuid');
      const vpa = this.localStorageService.getItem('customerVpa');
      const currentDate = new Date().toISOString();

      // Retrieve lastPaymentId from localStorage
      const lastPaymentId = parseInt(localStorage.getItem('lastPaymentId') || '0', 10);

      // Define options for fetching payments
      const options = {
        fromDateTime: '2024-01-01T00:00:00Z', // Example start date
        toDateTime: currentDate, // Current date as end date
        offset: 0, // Start from the first record
        limit: 10, // Fetch 10 records at a time
        lastPid: lastPaymentId, // Use the last processed payment ID
      };

      // Fetch new payments from the API
      const response = await this.apiService
        .getAllPayments(uuid, vpa, options)
        .toPromise();

      // Check if the response is valid and contains new payments
      if (response?.code === 2000 && response.data.payments.length > 0) {
        const payments = response.data.payments;

        // Process each payment sequentially
        for (const payment of payments) {
          // Skip if the payment has already been processed
          if (payment.pid <= lastPaymentId || this.processedPayments.has(payment.pid)) {
            continue;
          }

          // Mark the payment as processed
          this.processedPayments.add(payment.pid);

          // Trigger notification for the payment
          await this.fcmService.showNotification(payment.amount);

          // Trigger announcement for the payment
          await this.fcmService.announceUpdate(payment);

          // Update lastPaymentId in localStorage
          localStorage.setItem('lastPaymentId', payment.pid.toString());

          console.log('Processed payment:', payment);
        }
      } else {
        console.log('No new payments found.');
      }
    } catch (error) {
      console.error('Error checking for new payments:', error);
    }
  }
}