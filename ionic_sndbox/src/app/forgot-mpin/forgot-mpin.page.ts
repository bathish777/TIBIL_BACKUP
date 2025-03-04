import { Component, OnInit, OnDestroy, ViewChild } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { NgOtpInputComponent, NgOtpInputModule } from 'ng-otp-input';
import { FormsModule } from '@angular/forms';
import { TranslateService, TranslateModule } from '@ngx-translate/core';
import { IonContent, IonLabel, IonText } from '@ionic/angular/standalone';
import { LocalStorageService } from '../services/local-storage.service';
import { TokenManagerService } from '../services/token-manager.service'; 
import { Observable } from 'rxjs';
import { BackButtonService } from '../services/back-button.service';

@Component({
  selector: 'app-forgot-mpin',
  templateUrl: './forgot-mpin.page.html',
  styleUrls: ['./forgot-mpin.page.scss'],
  standalone: true,
  imports: [
    IonContent,
    IonLabel,
    IonText,
    CommonModule,
    FormsModule,
    NgOtpInputModule,
    TranslateModule,
  ],
})
export class ForgotMpinPage implements OnInit, OnDestroy {
  otp: string = '';
  errorMessage: string = '';
  pinSource: string = '';
  expectedPin: string = '';
  mpinInput: string = ''; 
  verifiedPin: string = ''; // Add this to store the verified PIN from query params
  mobileNumber: string = ''; 
  customerVpa: string = ''; 

  @ViewChild(NgOtpInputComponent, { static: false }) otpInput!: NgOtpInputComponent;

  constructor(
    private router: Router,
    private route: ActivatedRoute,
    private translate: TranslateService,
    private localStorageService: LocalStorageService,
    private tokenManager: TokenManagerService,
    private backButtonService: BackButtonService
  ) {
    if (!this.translate) {
      throw new Error('TranslateService is not available');
    }
    this.translate.use(this.translate.defaultLang);
  }

  // ngOnInit() {
  //   this.backButtonService.disableBackButton();

  //   this.route.queryParams.subscribe((params) => {
  //     this.pinSource = params['source'] || 'createdMpin';
  //     setTimeout(() => {
  //       this.expectedPin =
  //         this.pinSource === 'createdMpin'
  //           ? this.localStorageService.getItem('createdMpin') || ''
  //           : this.localStorageService.getItem('newLoginPin') || '';
  //       console.log('Expected Pin:', this.expectedPin); // Print expectedPin for debugging
  //     }, 0);
  //   });
  //   this.retrieveStoredData();
  // }
  ngOnInit() {
    this.backButtonService.disableBackButton();

    this.route.queryParams.subscribe((params) => {
      this.pinSource = params['source'] || 'createdMpin';
      this.verifiedPin = params['verifiedPin'] || ''; // Get the verified PIN from query params

      setTimeout(() => {
        this.expectedPin =
          this.pinSource === 'createdMpin'
            ? this.localStorageService.getItem('createdMpin') || ''
            : this.localStorageService.getItem('newLoginPin') || '';
        console.log('Expected Pin:', this.expectedPin); // Print expectedPin for debugging
      }, 0);
    });

    this.retrieveStoredData();
  }

  ngOnDestroy() {
    this.backButtonService.enableBackButton();
  }

  retrieveStoredData() {
    const userDevices = JSON.parse(this.localStorageService.getItem('userDevices') || '{}');
    this.mobileNumber = userDevices?.mobile_number || '';
    this.customerVpa = this.localStorageService.getItem('customerVpa') || '';
    const accessToken = this.localStorageService.getItem('access_token');
    console.log('Access Token in retrieveStoredData:', accessToken);
  }
  // retrieveStoredData() {
  //   const userDevices = JSON.parse(this.localStorageService.getItem('userDevices') || '{}');
  //   this.mobileNumber = userDevices?.mobile_number || '';
  //   this.customerVpa = this.localStorageService.getItem('customerVpa') || '';
  
  //   // Retrieve the access token from localStorage
  //   const accessToken = this.localStorageService.getItem('access_token');
  //   console.log('Access Token in retrieveStoredData:', accessToken);
  
  //   // If accessToken is null, fetch it from the API or handle the error
  //   if (!accessToken) {
  //     console.error('Access Token is null. Please ensure it is saved correctly.');
  //     this.errorMessage = 'Access Token is missing. Please log in again.';
  //   }
  // }
  getTranslation(key: string): Observable<string> {
    return this.translate.get(key);
  }

  navigateToVerification() {
    this.router.navigate(['/verification'], { queryParams: { action: 'forgot-login-pin' } });
  }

  onOtpInputChange(otpValue: string) {
    this.otp = otpValue;
    console.log('Updated OTP:', this.otp); // Print updated OTP for debugging
  }

  changeLanguage(language: string) {
    console.log(`Changing language to: ${language}`);
    this.translate.use(language);
  }

  // verifyMpin() {
  //   if (this.otp === this.expectedPin) {
  //     console.log('MPIN Verified Successfully:', this.otp);
  
  //     const accessToken = this.localStorageService.getItem('access_token');
  //     console.log('Access Token:', accessToken); // Print access token for debugging

  //     this.tokenManager.setAccessToken(accessToken);
  
  //     const userCredential = {
  //       verifiedLoginPin: this.otp, // This will be the correct OTP since verification passed
  //       mobileNumber: this.mobileNumber,
  //       customerVpa: this.customerVpa,
  //       deviceId: this.localStorageService.getItem('deviceId'),
  //       accessToken: accessToken,
  //     };
  
  //     this.localStorageService.setItem('userCredential', JSON.stringify(userCredential));
  //     console.log('Stored User Credential:', userCredential);
  
  //     if (this.otpInput) {
  //       this.otpInput.setValue(''); // Clear the OTP input field
  //     }
  
  //     this.router.navigate(['/qr-view']); // Navigate to the next page
  //   } else {
  //     this.errorMessage = this.translate.instant('ERROR.INVALID_OTP');
  //     console.error('Invalid OTP. Expected:', this.expectedPin, 'Received:', this.otp);
  
  //     // Clear the OTP input field and reset the state
  //     if (this.otpInput) {
  //       this.otpInput.setValue('');
  //     }
  //     this.otp = ''; // Reset the OTP value
  //   }
  // }
  // verifyMpin() {
  //   if (this.otp === this.expectedPin) {
  //     console.log('MPIN Verified Successfully:', this.otp);

  //     const accessToken = this.localStorageService.getItem('access_token');
  //     console.log('Access Token:', accessToken); // Print access token for debugging

  //     this.tokenManager.setAccessToken(accessToken);

  //     // Update the user credential with the verified PIN
  //     const userCredential = {
  //       verifiedLoginPin: this.otp, // Use the verified PIN
  //       mobileNumber: this.mobileNumber,
  //       customerVpa: this.customerVpa,
  //       deviceId: this.localStorageService.getItem('deviceId'),
  //       accessToken: accessToken,
  //     };

  //     // Save the updated user credential
  //     this.localStorageService.setItem('userCredential', JSON.stringify(userCredential));
  //     console.log('Stored User Credential:', userCredential);

  //     // Clear the OTP input field
  //     if (this.otpInput) {
  //       this.otpInput.setValue('');
  //     }

  //     // Navigate to the next page (e.g., qr-view)
  //     this.router.navigate(['/qr-view']);
  //   } else {
  //     this.errorMessage = this.translate.instant('ERROR.INVALID_OTP');
  //     console.error('Invalid OTP. Expected:', this.expectedPin, 'Received:', this.otp);

  //     // Clear the OTP input field and reset the state
  //     if (this.otpInput) {
  //       this.otpInput.setValue('');
  //     }
  //     this.otp = ''; // Reset the OTP value
  //   }
  // }
  verifyMpin() {
    // Retrieve the expectedPin from localStorage
    this.expectedPin = this.localStorageService.getItem('createdMpin') || '';
  
    if (this.otp === this.expectedPin) {
      console.log('MPIN Verified Successfully:', this.otp);
  
      const accessToken = this.localStorageService.getItem('access_token');
      console.log('Access Token:', accessToken); // Print access token for debugging
  
      this.tokenManager.setAccessToken(accessToken);
  
      // Update the user credential with the verified PIN
      const userCredential = {
        verifiedLoginPin: this.otp, // Use the verified PIN
        mobileNumber: this.mobileNumber,
        customerVpa: this.customerVpa,
        deviceId: this.localStorageService.getItem('deviceId'),
        accessToken: accessToken,
      };
  
      // Save the updated user credential
      this.localStorageService.setItem('userCredential', JSON.stringify(userCredential));
      console.log('Stored User Credential:', userCredential);
  
      // Clear the OTP input field
      if (this.otpInput) {
        this.otpInput.setValue('');
      }
  
      // Navigate to the next page (e.g., qr-view)
      this.router.navigate(['/qr-view']);
    } else {
      this.errorMessage = this.translate.instant('ERROR.INVALID_OTP');
      console.error('Invalid OTP. Expected:', this.expectedPin, 'Received:', this.otp);
  
      // Clear the OTP input field and reset the state
      if (this.otpInput) {
        this.otpInput.setValue('');
      }
      this.otp = ''; // Reset the OTP value
    }
  }
  // verifyMpin() {
  //   // Retrieve the expectedPin from localStorage
  //   this.expectedPin = this.localStorageService.getItem('createdMpin') || '';
  
  //   if (this.otp === this.expectedPin) {
  //     console.log('MPIN Verified Successfully:', this.otp);
  
  //     const accessToken = this.tokenManager.getAccessToken(); // Use TokenManagerService
  //     console.log('Access Token:', accessToken); // Print access token for debugging
  
  //     if (!accessToken) {
  //       console.error('Access Token is missing. Cannot proceed.');
  //       this.errorMessage = 'Access Token is missing. Please log in again.';
  //       return;
  //     }
  
  //     // Update the user credential with the verified PIN
  //     const userCredential = {
  //       verifiedLoginPin: this.otp, // Use the verified PIN
  //       mobileNumber: this.mobileNumber,
  //       customerVpa: this.customerVpa,
  //       deviceId: this.localStorageService.getItem('deviceId'),
  //       accessToken: accessToken,
  //     };
  
  //     // Save the updated user credential
  //     this.localStorageService.setItem('userCredential', JSON.stringify(userCredential));
  //     console.log('Stored User Credential:', userCredential);
  
  //     // Clear the OTP input field
  //     if (this.otpInput) {
  //       this.otpInput.setValue('');
  //     }
  
  //     // Navigate to the next page (e.g., qr-view)
  //     this.router.navigate(['/qr-view']);
  //   } else {
  //     this.errorMessage = this.translate.instant('ERROR.INVALID_OTP');
  //     console.error('Invalid OTP. Expected:', this.expectedPin, 'Received:', this.otp);
  
  //     // Clear the OTP input field and reset the state
  //     if (this.otpInput) {
  //       this.otpInput.setValue('');
  //     }
  //     this.otp = ''; // Reset the OTP value
  //   }
  // }
}