import { Component, OnDestroy, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ApiService } from '../services/api.service';
import { BackButtonService } from '../services/back-button.service';
import { TranslateService, TranslateModule } from '@ngx-translate/core';
import { FcmService } from '../services/fcm.service';
import { NotificationHandlerService } from '../services/notification-handler.service';
import { IonContent, IonIcon, IonFooter } from '@ionic/angular/standalone';
import { TabBarComponent } from "../shared/tab-bar/tab-bar.component";
import { LocalStorageService } from '../services/local-storage.service';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.page.html',
  styleUrls: ['./dashboard.page.scss'],
  standalone: true,
  imports: [
    CommonModule,
    FormsModule,
    IonContent,
    IonIcon,
    IonFooter,
    TabBarComponent,
    TranslateModule
  ],
})
export class DashboardPage implements OnInit, OnDestroy {
  currentTab: string = 'dashboard';
  currentHeader: string = 'DASHBOARD';
  fullDate: string = new Date().toLocaleDateString('en-GB', {
    weekday: 'long',
    day: '2-digit',
    month: 'short',
    year: 'numeric',
  });
  totalTransactions: number = 0;
  totalAmount: number = 0;
  showBanner: boolean = true;
  showNotification: boolean = true;
  pinkContainerVisible: boolean = false;
  selectedLanguage: string = 'en';

  constructor(
    private router: Router,
    private apiService: ApiService,
    public translateService: TranslateService,
    private fcmService: FcmService,
    private backButtonService: BackButtonService,
    private notificationHandler: NotificationHandlerService,
    private localStorageService: LocalStorageService,
  ) {
    console.log('DashboardPage initialized.');
  }

  ngOnInit(): void {
    // const accessToken = localStorage.getItem('access_token');
    // if (!accessToken) {
    //   console.error('Access token is missing. Please log in again.');
    //   this.router.navigate(['/login']);
    // } else {
    //   console.log('Access token found:', accessToken);
    //   // Proceed with API calls using access_token
    // }

    const accessToken = this.localStorageService.getItem('access_token');
    if (!accessToken) {
      console.error('Access token is missing. Please log in again.');
     
    } else {
      console.log('Access token found:', accessToken);
      // Proceed with API calls using access_token
    }
  
    this.backButtonService.disableBackButton();
    const storedLanguage = localStorage.getItem('selectedLanguage');
    this.selectedLanguage = storedLanguage || 'en';
    this.translateService.use(this.selectedLanguage);

    // Initialize push notifications and start polling for new payments
    this.fcmService.initPush();
    this.notificationHandler.startPolling();

    this.fetchPaymentSummary();
  }

  ngOnDestroy() {
    this.backButtonService.disableBackButton();
  }

  switchLanguage(language: string): void {
    this.selectedLanguage = language;
    this.translateService.use(language);
    localStorage.setItem('selectedLanguage', language);
  }

  fetchPaymentSummary() {
    
    const uuid = this.localStorageService.getItem('uuid');
    const vpa = this.localStorageService.getItem('customerVpa');

    const date = new Date().toISOString();
  
    if (!uuid || !vpa) {
      console.error('Missing required data in local storage');
      return;
    }
    console.log( uuid, vpa, date)
    this.apiService.getPaymentSummary( uuid, vpa, date).subscribe(
      (summary) => {
        console.log(summary)
        if (summary?.data) {
          this.totalTransactions = summary.data.transactionCount;
          this.totalAmount = summary.data.totalAmount;
        }
      },
      (error) => {
        console.error('Failed to fetch payment summary:', error);
      }
    );
  }

  togglePinkContainer(): void {
    this.pinkContainerVisible = !this.pinkContainerVisible;
    console.log('Pink container visibility toggled:', this.pinkContainerVisible);
  }

  selectTab(route: string): void {
    this.router.navigate([route]);
    this.updateHeader(route);
  }

  updateHeader(tab: string) {
    if (tab === 'settings') {
      this.translateService.get('SETTINGS').subscribe((translatedHeader) => {
        this.currentHeader = translatedHeader;
      });
    } else if (tab === 'dashboard') {
      this.translateService.get('DASHBOARD').subscribe((translatedHeader) => {
        this.currentHeader = translatedHeader;
      });
    } else if (tab === 'transactions') {
      this.translateService.get('TRANSACTIONS').subscribe((translatedHeader) => {
        this.currentHeader = translatedHeader;
      });
    }
  }

  onHeaderTextChange(newHeader: string): void {
    this.currentHeader = newHeader;
    console.log('Header text changed:', this.currentHeader);
  }

  navigateTo(): void {
    console.log('Navigating to QR Code view.');
    this.router.navigate(['/qr-view']);
  }

  dismissNotification() {
    console.log('Closing notification');
    this.showBanner = false;
  }
}