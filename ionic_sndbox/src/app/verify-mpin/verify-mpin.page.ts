/* eslint-disable @angular-eslint/component-class-suffix */

import { ActivatedRoute, Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { NgOtpInputComponent, NgOtpInputModule } from 'ng-otp-input';
import { BackButtonService } from '../services/back-button.service'; 
import { Component, OnInit, ViewChild } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { TranslateService, TranslateModule } from '@ngx-translate/core';
import {
  IonButton,
  IonContent,
  IonHeader,
  IonItem,
  IonLabel,
  IonText,
  IonToolbar,
} from '@ionic/angular/standalone';
import { ApiService } from '../services/api.service';
import { LocalStorageService } from '../services/local-storage.service'; // Import LocalStorageService

@Component({
  selector: 'app-verify-mpin',
  templateUrl: 'verify-mpin.page.html',
  styleUrls: ['verify-mpin.page.scss'],
  standalone: true,
  imports: [
    IonButton,
    IonContent,
    IonHeader,
    IonItem,
    IonLabel,
    IonText,
    IonToolbar,
    CommonModule,
    FormsModule,
    NgOtpInputModule,
    TranslateModule
  ],
})
export class VerifyMpinPage implements OnInit {
  otp: string = ''; // Holds the re-entered MPIN
  errorMessage: string = ''; // Error message to display
  createdMpin: string = ''; // Placeholder for the created MPIN for comparison
  mobileNumber: string = ''; // Placeholder for the mobile number




 @ViewChild(NgOtpInputComponent, { static: false }) otpInput!: NgOtpInputComponent;   
 
 
   
  constructor(
    private router: Router,
    private route: ActivatedRoute,
    private apiService: ApiService,
    private backButtonService: BackButtonService ,
    private translate: TranslateService,
    private localStorageService: LocalStorageService // Inject LocalStorageService
  ) {}

  ngOnInit() {
    this.backButtonService.enableBackButton(); 
    this.retrieveMobileNumber(); // Get mobile number from local storage
    this.retrieveCreatedMpin();  // Retrieve created MPIN from local storage
  }

  ngOnDestroy() {
    this.backButtonService.disableBackButton(); // Enable back button when page is destroyed
  }

  // Retrieve created MPIN from LocalStorageService
  private retrieveCreatedMpin() {
    this.createdMpin = this.localStorageService.getItem('createdMpin') || '';
    if (!this.createdMpin) {
      this.errorMessage = 'No created MPIN found in local storage.';
      console.error(this.errorMessage);
    }
  }

  // Retrieve mobile number from LocalStorageService
  private retrieveMobileNumber() {
    try {
      const userDevices = this.localStorageService.getItem('userDevices');
      if (userDevices) {
        const parsedDevices = JSON.parse(userDevices);
        if (parsedDevices?.mobile_number) {
          this.mobileNumber = parsedDevices.mobile_number;
          console.log('Retrieved Mobile Number:', this.mobileNumber); // Debug log
        } else {
          this.errorMessage = 'No valid mobile number found in user devices.';
          console.error(this.errorMessage);
        }
      }
    } catch (error) {
      this.errorMessage = 'Error fetching mobile number from storage.';
      console.error('Error parsing mobile number from storage:', error);
    }
  }

  // Handle OTP input change
  onOtpInputChange(otpValue: string) {
    this.otp = otpValue;
  }

  changeLanguage(language: string) {
    this.translate.use(language);
  }

  // Verify MPIN and call API to get secrets
  verifyMpin() {
    console.log('Entered OTP:', this.otp);
    console.log('Stored MPIN:', this.createdMpin);

    if (this.otp === this.createdMpin) {
      console.log('MPIN Verified Successfully:', this.otp);

      // Call the API to get secrets
      this.apiService.getSecrets(this.mobileNumber, this.createdMpin).subscribe(
        (response) => {
          console.log('API Response:', response); // Log API response for debugging

          // Store user secrets securely in LocalStorageService
          this.localStorageService.setItem('userSecrets', JSON.stringify(response.data));

          // Store access and refresh tokens if available
          if (response.data && response.data.access_token && response.data.refresh_token) {
            this.localStorageService.setItem('access_token', response.data.access_token);
            
            this.localStorageService.setItem('refresh_token', response.data.refresh_token);
          } else {
            console.error('API Response is missing access tokens:', response);
            this.errorMessage = 'Failed to retrieve user secrets. Please try again.';
          }
          if (response.data.uuid) {
            this.localStorageService.setItem('uuid', response.data.uuid);
          }
      

          // Store default preferences if available
          if (response.data.default_preferences) {
            this.localStorageService.setItem('default_preferences', JSON.stringify(response.data.default_preferences));
          }
          this.otpInput.setValue('');
          // Navigate to the Forgot MPIN page after successful verification
          this.router.navigate(['/forgot-mpin']).then(() => {
            console.log('Navigation successful');
          }).catch(err => {
            console.error('Navigation failed:', err);
          });

        },
        (error) => {
          console.error('API Error:', error);
          this.errorMessage = 'Failed to retrieve user secrets. Please try again.';
        }
      );
    } else {
      console.log('OTP does not match the created MPIN');
      this.errorMessage = 'Entered PIN does not match. Please try again.';
    }
  }
}
