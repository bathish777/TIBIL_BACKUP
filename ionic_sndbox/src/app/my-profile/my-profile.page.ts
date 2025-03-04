import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { CommonModule } from '@angular/common'; // Removed Location as it’s not needed
import { FormsModule } from '@angular/forms';
import { TranslateService, TranslateModule } from '@ngx-translate/core';
import {
  IonContent,
  IonLabel,
  IonRow } from '@ionic/angular/standalone';
import { LocalStorageService } from '../services/local-storage.service'; // Import LocalStorageService

@Component({
  selector: 'app-my-profile',
  templateUrl: './my-profile.page.html',
  styleUrls: ['./my-profile.page.scss'],
  standalone: true,
  imports: [IonRow,
    CommonModule,
    FormsModule,
    IonContent,
    IonLabel,
    TranslateModule],
})
export class ProfilePage implements OnInit {
  currentTab: string = 'my-profile'; // Default tab (Profile Tab)
  currentHeader: string = ' < My Profile'; // Default header text for profile page
  fullDate: string = new Date().toLocaleDateString('en-GB', {
    weekday: 'long',
    day: '2-digit',
    month: 'short',
    year: 'numeric',
  }); // Long date format
  showNotification: boolean = true; // To toggle the visibility of the notification banner

  customerName: string | null = null; // Dynamically fetched customer name
  userPhoneNumber: string | null = null; // Dynamically fetched phone number
  userDevices: any[] = []; // List of user devices

  constructor(
    private router: Router,
    private translate: TranslateService,
    private localStorageService: LocalStorageService // Inject LocalStorageService
  ) {}

  changeLanguage(language: string) {
    this.translate.use(language);
  }

  ngOnInit(): void {
    this.customerName = this.localStorageService.getItem('customerName');
    const userDevicesData = this.localStorageService.getItem('userDevices');
    if (userDevicesData) {
      try {
        const userDevices = JSON.parse(userDevicesData);
        if (userDevices && userDevices.mobile_number) {
          this.userPhoneNumber = userDevices.mobile_number;
        } else {
          console.error('Mobile number not found in user devices.');
        }
      } catch (error) {
        console.error('Error parsing user devices from local storage:', error);
      }
    } else {
      console.error('User devices data not found in local storage.');
    }
  }

  /**
   * Navigate back to the settings tab
   */
  goBack(): void {
    this.router.navigate(["settings"]);// Switch to the 'settings' tab
  }

  /**
   * Update the current tab and header based on selection
   */
  selectTab(tab: string): void {
    this.currentTab = tab;

    switch (tab) {
      case 'dashboard':
        this.currentHeader = 'Dashboard';
        break;
      case 'transactions':
        this.currentHeader = 'Transactions';
        break;
      case 'settings':
        this.currentHeader = 'Settings';
        break;
      case 'my-profile':
        this.currentHeader = ' < My Profile';
        break;
      default:
        this.currentHeader = 'Dashboard';
        break;
    }
  }

  /**
   * Navigate to the QR view
   */
  navigateTo(): void {
    this.router.navigate(['/qr-view']);
  }

  /**
   * Dismiss the notification banner
   */
  dismissNotification(): void {
    this.showNotification = false;
  }
}
