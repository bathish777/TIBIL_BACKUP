/* eslint-disable @typescript-eslint/no-unused-vars */
import { Component, OnInit, ViewChild } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router'; // Import Router for navigation
import { CommonModule } from '@angular/common';
import { TranslateService, TranslateModule } from '@ngx-translate/core';
import { NgOtpInputComponent, NgOtpInputModule } from 'ng-otp-input';
import { FormsModule } from '@angular/forms'; // Import FormsModule to use ngModel
import {
  IonContent,
  IonLabel,
  IonText,
} from '@ionic/angular/standalone';
import { LocalStorageService } from '../services/local-storage.service'; // Import LocalStorageService

@Component({
  selector: 'app-mpin-create',
  templateUrl: 'mpin-create.page.html',
  styleUrls: ['mpin-create.page.scss'],
  standalone: true,
  imports: [
    IonContent,
    IonLabel,
    IonText,
    CommonModule,
    FormsModule,
    TranslateModule,
    NgOtpInputModule
],
})
export class MpinCreatePage implements OnInit {
  otp: string = ''; // Holds the MPIN input
  errorMessage: string = ''; // Error message to display
  isOtpValid: boolean = false; // Whether the MPIN is valid
  action: string | null = null; // Action from query parameters (optional)
  createdMpin!: string;
  
  @ViewChild(NgOtpInputComponent, { static: false }) otpInput!: NgOtpInputComponent;



  constructor(
    private router: Router,
    private route: ActivatedRoute,
    private translate: TranslateService,
    private localStorageService: LocalStorageService // Inject LocalStorageService
  ) {}

  ngOnInit() {
    // Capture query parameters if necessary
    this.route.queryParams.subscribe((params) => {
      this.action = params['action'] || null;

      // Retrieve MPIN from local storage using LocalStorageService
      this.createdMpin = this.localStorageService.getItem('createdMpin') || '';
    });
  }

  changeLanguage(language: string) {
    this.translate.use(language);
  }

  // Handle OTP input change
  onOtpInputChange(otpValue: string) {
    this.otp = otpValue;
    this.isOtpValid = this.otp.length === 4; // Validate MPIN (must be 4 digits)
  }

  createMpin() {
    if (this.isOtpValid) {
    // Log MPIN for debugging
      this.localStorageService.setItem('createdMpin', this.otp); // Save MPIN using LocalStorageService
  
      // Reset OTP before navigating
     
      this.otpInput.setValue('');
  
      this.router.navigate(['/verify-mpin']).catch(err => {
        
      });
    } else {
      this.errorMessage = this.translate.instant('ERROR.INVALID_PIN'); // Ensure translated error message
    }
  }
  
}
