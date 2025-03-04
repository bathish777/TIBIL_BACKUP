import { Component, OnInit, ViewChild, OnDestroy, ChangeDetectorRef } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { NgOtpInputComponent, NgOtpInputModule } from 'ng-otp-input';
import { TranslateService, TranslateModule } from '@ngx-translate/core';
import {
  IonHeader,
  IonToolbar,
  IonTitle,
  IonContent,
  IonItem,
  IonLabel,
  IonInput,
  IonButton,
  IonText,
} from '@ionic/angular/standalone';
import { ApiService } from '../services/api.service';
import { LocalStorageService } from '../services/local-storage.service';
import { BackButtonService } from '../services/back-button.service';
import { FcmService } from '../services/fcm.service'; // Import FcmService

@Component({
  selector: 'app-verification',
  templateUrl: 'verification.page.html',
  styleUrls: ['verification.page.scss'],
  standalone: true,
  imports: [
    IonButton,
    IonTitle,
    IonContent,
    IonHeader,
    IonItem,
    IonLabel,
    IonInput,
    IonText,
    IonToolbar,
    CommonModule,
    FormsModule,
    NgOtpInputModule,
    TranslateModule,
  ],
})
export class VerificationPage implements OnInit, OnDestroy {
  otp: string = '';
  errorMessage: string = '';
  isOtpValid: boolean = false;
  resendTimer: number = 30;
  resendDisabled: boolean = false;
  action: string | null = null;
  mobile: string = '';
  responseIdentification: string | null = null;

  @ViewChild(NgOtpInputComponent, { static: false }) otpInput!: NgOtpInputComponent;

  constructor(
    private router: Router,
    private route: ActivatedRoute,
    private apiService: ApiService,
    private cdr: ChangeDetectorRef,
    private translate: TranslateService,
    private localStorageService: LocalStorageService,
    private backButtonService: BackButtonService,
    private fcmService: FcmService // Inject FcmService
  ) {}

  ngOnInit() {
    this.backButtonService.disableBackButton(); // Disable back button navigation

    this.resendDisabled = false;
    this.getMobileNumberFromStorage();
    this.fetchOtp();

    // Fetch OTP based on the action query parameter
    this.route.queryParams.subscribe((params) => {
      this.action = params['action'] || null;
      if (params['action'] === 'forgot-login-pin' || params['action'] === 'forgot-mpin') {
        this.fetchOtp(); // Trigger OTP notification
      }
    });
  }

  ngOnDestroy() {
    this.backButtonService.enableBackButton(); // Enable back button when leaving this page
    this.otp = '';
  }

  fetchOtp() {
    if (this.mobile) {
      this.apiService.getOtp(this.mobile).subscribe(
        (response: any) => {
          if (response.code === 2000) {
            this.responseIdentification = response.data.identification || this.maskMobileNumber(this.mobile);
            this.localStorageService.setItem('responseIdentification', this.responseIdentification || '');

            // Show OTP notification based on the action
            if (this.responseIdentification) {
              if (this.action === 'forgot-login-pin') {
                this.fcmService.showOtpNotification(this.responseIdentification, 'forgot-login-pin');
              } else if (this.action === 'forgot-mpin') {
                this.fcmService.showOtpNotification(this.responseIdentification, 'forgot-mpin');
              } else {
                this.fcmService.showOtpNotification(this.responseIdentification); // Default OTP notification
              }
            }
          } else {
            this.errorMessage = this.translate.instant('OTP_VERIFICATION.FETCH_FAILED');
          }
        },
        (error) => {
          console.error('Error fetching OTP:', error);
          this.errorMessage = this.translate.instant('OTP_VERIFICATION.ERROR_FETCHING');
        }
      );
    } else {
      this.errorMessage = this.translate.instant('OTP_VERIFICATION.NO_MOBILE');
    }
  }

  getMobileNumberFromStorage() {
    const userDevices = JSON.parse(this.localStorageService.getItem('userDevices') || '{}');
    if (userDevices?.mobile_number) {
      this.mobile = userDevices.mobile_number;
    } else {
      this.errorMessage = this.translate.instant('OTP_VERIFICATION.NO_VALID_MOBILE');
    }
  }

  maskMobileNumber(mobile: string): string {
    return mobile.length >= 10 ? `****${mobile.slice(-4)}` : mobile;
  }

  onOtpInputChange(otpValue: string) {
    this.otp = otpValue;
    this.isOtpValid = this.otp.length === 6;
  }

  verifyOtp() {
    const enteredOtp = this.otp; // Store the entered OTP in a separate variable

    this.localStorageService.setItem('enteredOtp', enteredOtp);

    if (!this.isOtpValid || enteredOtp !== this.responseIdentification) {
      this.errorMessage = this.translate.instant('OTP_VERIFICATION.INVALID_OTP');
      return;
    }

    const deviceId = this.localStorageService.getItem('deviceId');
    const identification = this.responseIdentification;

    if (!deviceId || !identification) {
      this.errorMessage = this.translate.instant('OTP_VERIFICATION.MISSING_DETAILS');
      return;
    }

    // Reset OTP before navigation
    this.otpInput.setValue('');
    this.otp = ''; // Clear the OTP field after storing it in enteredOtp

    this.router.navigate([this.action === 'forgot-mpin' ? '/create-new-login-pin' : '/mpin-create']).then(() => {
      const requestBody = {
        otp: Number(enteredOtp), // Use enteredOtp here
        mobile_number: this.mobile,
        device_id: deviceId,
        identification: identification,
      };

      this.apiService.updateOtp(requestBody).subscribe(
        (response: any) => {
          if (response.code === 2000) {
            this.localStorageService.setItem('otpVerificationResponse', JSON.stringify(response.data));
          } else {
            console.error('Error in OTP verification:', response.message);
          }
        },
        (error) => {
          console.error('Error verifying OTP:', error);
          this.errorMessage = error?.error?.message || this.translate.instant('OTP_VERIFICATION.ERROR_VERIFYING');
        }
      );
    }).catch(err => {
      console.error('Navigation failed:', err);
    });
  }

  resetOtp() {
    this.otp = '';
    this.isOtpValid = false;
    this.cdr.detectChanges();
  }

  changeLanguage(language: string) {
    this.translate.use(language);
  }

  resendOtp(event: Event) {
    event.preventDefault();

    if (this.resendDisabled) return;

    this.resetOtp();

    if (this.mobile) {
      this.fetchOtp(); // Fetch OTP and trigger notification
      this.startResendTimer();
    } else {
      this.errorMessage = this.translate.instant('OTP_VERIFICATION.NO_MOBILE');
    }
  }

  startResendTimer() {
    if (this.resendDisabled) return;
    this.resendDisabled = true;
    this.resendTimer = 30;

    const interval = setInterval(() => {
      this.resendTimer--;

      if (this.resendTimer <= 0) {
        clearInterval(interval);
        this.resendDisabled = false;
        this.cdr.detectChanges();
      }
    }, 1000);
  }

  formatTime(seconds: number): string {
    const minutes = Math.floor(seconds / 60);
    const remainingSeconds = seconds % 60;
    return `${minutes}:${remainingSeconds < 10 ? '0' : ''}${remainingSeconds}`;
  }
}