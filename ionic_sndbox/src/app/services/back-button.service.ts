import { Injectable } from '@angular/core';
import { Platform } from '@ionic/angular';
import { Subscription } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class BackButtonService {
  private backButtonSubscription: Subscription | null = null;

  constructor(private platform: Platform) {}

  
  disableBackButton() {
    this.backButtonSubscription = this.platform.backButton.subscribeWithPriority(9999, () => {
      // Prevent back navigation
    });
  }

  // Enable the back button
  enableBackButton() {
    if (this.backButtonSubscription) {
      this.backButtonSubscription.unsubscribe(); // Allow back navigation
      this.backButtonSubscription = null;
    }
  }
}
