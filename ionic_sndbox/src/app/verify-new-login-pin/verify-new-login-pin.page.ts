import { Component, OnInit, OnDestroy, ViewChild } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { NgOtpInputComponent, NgOtpInputModule } from 'ng-otp-input';
import { FormsModule } from '@angular/forms';
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
import { LocalStorageService } from '../services/local-storage.service';
import { BackButtonService } from '../services/back-button.service'; // Adjust the path as needed

@Component({
  selector: 'app-verify-new-login-pin',
  templateUrl: './verify-new-login-pin.page.html',
  styleUrls: ['./verify-new-login-pin.page.scss'],
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
    TranslateModule,
    NgOtpInputModule,
  ],
})
export class VerifyNewLoginPage implements OnInit, OnDestroy {
  otp: string = ''; // Holds the entered PIN
  errorMessage: string = ''; // Error message to display
  storedPin: string = ''; // Placeholder for the newly created PIN from local storage
  createdMpin: string = ''; // Placeholder for newly created PIN
  isUpdating: boolean = false; // Tracks if navigating from updating PIN

  @ViewChild(NgOtpInputComponent, { static: false }) otpInput!: NgOtpInputComponent;

  constructor(
    private router: Router,
    private route: ActivatedRoute,
  
    public translate: TranslateService,
    private localStorageService: LocalStorageService,
    private backButtonService: BackButtonService // Inject BackButtonService
  ) {}

  ngOnInit() {
    this.backButtonService.enableBackButton(); 
    this.retrieveStoredPins();
    this.route.queryParams.subscribe((params) => {
      this.isUpdating = params['isUpdating'] === 'true';
    });

    // Enable the back button for this page
   
  }

  
  ngOnDestroy() {
    this.backButtonService.disableBackButton(); // Enable back button when page is destroyed
  }

  private retrieveStoredPins() {
    this.storedPin = this.localStorageService.getItem('newLoginPin') || '';
    this.createdMpin = this.localStorageService.getItem('createdMpin') || '';
  }

  onOtpInputChange(otpValue: string) {
    this.otp = otpValue;
  }

  // verifyLoginPin() {
  //   if (this.otp.length === 4) {
  //     const expectedPin = this.isUpdating ? this.createdMpin : this.storedPin;
  //     if (this.otp === expectedPin) {
  //       // Store the verified PIN in localStorage as the new createdMpin
  //       this.localStorageService.setItem('createdMpin', this.otp);

  //       // Clear the temporary newLoginPin
  //       this.localStorageService.removeItem('newLoginPin');

  //       // Retrieve the access token from localStorage
  //       const accessToken = this.localStorageService.getItem('access_token');

  //       // Store the access token in localStorage (if needed)
  //       if (accessToken) {
  //         localStorage.setItem('access_token', accessToken);
  //       }

  //       // Navigate to the forgot MPIN page
  //       this.router.navigate(['/forgot-mpin'], {
  //         queryParams: { source: this.isUpdating ? 'createdMpin' : 'newLoginPin' },
  //       });
  //     } else {
  //       this.errorMessage = 'The entered PIN does not match. Please try again.';
  //     }
  //   } else {
  //     this.errorMessage = 'Please re-enter a valid 4-digit PIN.';
  //   }
  // }
  verifyLoginPin() {
  if (this.otp.length === 4) {
    const expectedPin = this.isUpdating ? this.createdMpin : this.storedPin;
    if (this.otp === expectedPin) {
      // Store the verified PIN in localStorage as the new createdMpin
      this.localStorageService.setItem('createdMpin', this.otp);

      // Clear the temporary newLoginPin
      this.localStorageService.removeItem('newLoginPin');

      // Retrieve the access token from localStorage
      const accessToken = this.localStorageService.getItem('access_token');

      // Store the access token in localStorage (if needed)
      if (accessToken) {
        localStorage.setItem('access_token', accessToken);
      }

      // Disable back button before navigation
      this.backButtonService.disableBackButton();

      // Navigate to the forgot MPIN page
      this.router.navigate(['/forgot-mpin'], {
        queryParams: { source: this.isUpdating ? 'createdMpin' : 'newLoginPin' },
      });
    } else {
      this.errorMessage = 'The entered PIN does not match. Please try again.';
    }
  } else {
    this.errorMessage = 'Please re-enter a valid 4-digit PIN.';
  }
}
}