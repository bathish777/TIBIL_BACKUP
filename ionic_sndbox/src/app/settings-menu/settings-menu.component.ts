import { Component, Output, EventEmitter, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { addIcons } from 'ionicons';
import { person, qrCode, megaphone, language, key, exit } from 'ionicons/icons';
import {
  IonModal,
  IonItem,
  IonLabel,
  IonIcon,
  IonImg,
  IonToggle,
  IonButton,
  IonButtons,
  IonToolbar,
  IonList, IonContent, IonAlert, IonText,
} from '@ionic/angular/standalone';
import { TranslateModule, TranslateService } from '@ngx-translate/core';
import { FcmService } from '../services/fcm.service'; // Import FcmService
import { LocalStorageService } from '../services/local-storage.service'; // Import LocalStorageService

addIcons({
  person,
  'qr-code': qrCode,
  megaphone,
  language,
  key,
  exit,
});

@Component({
  selector: 'app-settings-menu',
  templateUrl: './settings-menu.component.html',
  styleUrls: ['./settings-menu.component.scss'],
  standalone: true,
  imports: [
    IonText, IonAlert,
    IonModal,
    IonItem,
    IonLabel,
    IonIcon,
    IonImg,
    IonList,
    IonToggle,
    IonButton,
    IonButtons,
    IonToolbar,
    IonContent,
    TranslateModule,
    CommonModule,
    FormsModule,
  ],
})
export class SettingsMenuComponent implements OnInit {
  @Output() headerTextChange: EventEmitter<string> = new EventEmitter();
  _isMuted: boolean = false; // Tracks the mute state
  currentSettingsTab: string = 'settings';
  isSignOutModalOpen: boolean = false;
  isMuteAnnouncementModalOpen: boolean = false;
  muteConfirmationText: string = '';
  isResetMpinModalOpen: boolean = false;
  selectedLanguage: string = 'en'; // Default language
  newMpin: string = ''; // Holds the new MPIN input
  resetMpinError: string = ''; // Error message for reset MPIN

  constructor(
    private router: Router,
    private translateService: TranslateService,
    private fcmService: FcmService, // Inject FcmService
    private localStorageService: LocalStorageService // Inject LocalStorageService
  ) {
    this.translateService.setDefaultLang('en');
    this.translateService.use('en');
  }

  private processedPayments = new Set<number>();

  ngOnInit(): void {
    // Load saved language from local storage
    const storedLanguage = localStorage.getItem('selectedLanguage');
    if (storedLanguage) {
      this.selectedLanguage = storedLanguage;
      this.translateService.use(storedLanguage);
    } else {
      this.translateService.use(this.selectedLanguage);
    }

    // Initialize the mute state from localStorage
    this._isMuted = JSON.parse(localStorage.getItem('isMuted') || 'true');
  }

  /**
   * Switches the app language and stores it in local storage.
   */
  switchLanguage(language: string): void {
    this.selectedLanguage = language;
    this.translateService.use(language);
    localStorage.setItem('selectedLanguage', language);
  }

  /**
   * Sets the current page and updates the header text with translations.
   */
  setCurrentPage(tab: string) {
    this.currentSettingsTab = tab;
    const headerKey = tab === 'settings' ? 'SETTINGS' : tab.toUpperCase();
    this.translateService.get(headerKey).subscribe((translatedHeader) => {
      this.headerTextChange.emit(translatedHeader);
    });

    // Navigate to the appropriate page
    if (tab === 'profile') {
      this.router.navigate(['settings/my-profile']);
    } else if (tab === 'qr-code') {
      this.router.navigate(['settings/my-qr-code']);
    } else if (tab === 'language-preference') {
      this.router.navigate(['settings/language-preference']);
    }
  }

  /**
   * Toggles the muted state for announcements and displays translated confirmation text.
   */
  toggleMute() {
    const newMuteState = this._isMuted; 
    // Compute new state first
    localStorage.setItem('isMuted', JSON.stringify(newMuteState)); // Save to localStorage

    // Update FCM mute state
    this.fcmService.setMuteState(newMuteState);

    // Update UI state


    // Show confirmation modal with translated text
    const muteKey = newMuteState ? 'ANNOUNCEMENTS_UNMUTED':'ANNOUNCEMENTS_MUTED' ;
    this.translateService.get(muteKey).subscribe((translatedText) => {
      this.muteConfirmationText = translatedText;
      this.isMuteAnnouncementModalOpen = true;
    });
  }

  /**
   * Confirms the mute toggle and closes the modal.
   */
  confirmMuteToggle() {
    this.isMuteAnnouncementModalOpen = false;
  }

  /**
   * Navigates to the Forgot MPIN verification page with a query parameter.
   */
  navigateToForgotMpin() {
    this.router.navigate(['/verification'], {
      queryParams: { action: 'forgot-mpin' },
    });
  }

  /**
   * Confirms MPIN reset and navigates to the verification page.
   */
  navigateToVerification() {
    
    this.isResetMpinModalOpen = false;
    setTimeout(() => {
      this.router.navigate(['/verification'], {
        queryParams: { action: 'forgot-mpin' },
      });
    }, 100);
  }

  /**
   * Opens the reset MPIN confirmation modal.
   */
  confirmResetMpin() {
    this.isResetMpinModalOpen = true;
  }

  /**
   * Resets the MPIN after validation.
   */
  resetMpin() {
    const storedMpin = this.localStorageService.getItem('createdMpin'); // Get stored MPIN
    if (this.newMpin === storedMpin) {
      this.resetMpinError = 'You cannot use the same MPIN again. Please choose a different MPIN.';
    } else {
      // Save the new MPIN to local storage
      this.localStorageService.setItem('createdMpin', this.newMpin);
      this.resetMpinError = ''; // Clear error message
      this.isResetMpinModalOpen = false; // Close the modal
      console.log('MPIN reset successfully.');
      // Optionally, navigate to another page or show a success message
    }
  }

  /**
   * Opens and closes the sign-out modal.
   */
  openSignOutModal() {
    this.isSignOutModalOpen = true;
  }

  closeSignOutModal() {
    this.isSignOutModalOpen = false;
  }

  /**
   * Handles user sign-out.
   */
  signOut() {
    localStorage.removeItem('userCredential');
    // this.processedPayments.clear(); // Clear processed payments

    // Redirect to the login page
    // localStorage.clear();
    this.closeSignOutModal();
    setTimeout(() => {
      this.router.navigate(['/splash-screen']);
    }, 100);
  }

  /**
   * Closes the mute announcement modal.
   */
  closeMuteAnnouncementModal() {
    this.isMuteAnnouncementModalOpen = false;
  }

  /**
   * Closes the reset MPIN modal.
   */
  closeResetMpinModal() {
    this.isResetMpinModalOpen = false;
    this.resetMpinError = ''; // Clear error message when modal is closed
  }
}