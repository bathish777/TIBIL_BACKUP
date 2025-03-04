// import { Component, OnInit } from '@angular/core';
import { Component, OnInit, ViewChild } from '@angular/core';
import { Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { NgOtpInputComponent, NgOtpInputModule } from 'ng-otp-input';

import { TranslateService, TranslateModule } from '@ngx-translate/core';
import { FormsModule } from '@angular/forms';
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
import { LocalStorageService } from '../services/local-storage.service'; // Import LocalStorageService

@Component({
  selector: 'app-create-new-login-pin',
  templateUrl: './create-new-login-pin.page.html',
  styleUrls: ['./create-new-login-pin.page.scss'],
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
export class CreateNewLoginPage implements OnInit {
  otp: string = ''; // Holds the entered MPIN
  errorMessage: string = ''; // Error message to display
  newLoginPin: string = ''; // Placeholder for the newly created MPIN
  @ViewChild(NgOtpInputComponent, { static: false }) otpInput!: NgOtpInputComponent;   
 
  constructor(
    private router: Router,
    private translate: TranslateService,
    private localStorageService: LocalStorageService // Inject LocalStorageService
  ) {}

  changeLanguage(language: string) {
    this.translate.use(language);
  }

  ngOnInit() {
    // Retrieve the stored PIN from LocalStorageService if needed
    this.newLoginPin = this.localStorageService.getItem('newLoginPin') || '';
  }

  // Handle OTP input change
  onOtpInputChange(otpValue: string) {
    this.otp = otpValue;
  }

  // Create a new PIN and save it using LocalStorageService
  createNewPin() {
    if (this.otp.length === 4) {
      // Save the newly created PIN using LocalStorageService
      this.localStorageService.setItem('newLoginPin', this.otp);
      console.log('New PIN Created:', this.otp); // Log for debugging
      this.otpInput.setValue('');
      this.router.navigate(['/verify-new-login-pin']); // Navigate to PIN verification page
    } else {
      this.errorMessage = 'Please enter a valid 4-digit PIN.'; // Show error if the PIN is invalid
    }
  }
}
