import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { ApiService } from '../services/api.service';
import { TranslateService } from '@ngx-translate/core';
import { TabBarComponent } from '../shared/tab-bar/tab-bar.component';
import { CommonModule } from '@angular/common';
import { MyQrCodePage } from '../my-qr-code/my-qr-code.page';
import { Router } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { TranslateModule } from '@ngx-translate/core';
import { FcmService } from '../services/fcm.service';
import { LocalStorageService } from '../services/local-storage.service';
import { NotificationHandlerService } from '../services/notification-handler.service';
import {
  IonHeader,
  IonToolbar,
  IonTitle,
  IonContent,
  IonList,
  IonItem,
  IonLabel,
  IonIcon,
  IonInfiniteScroll,
  IonInfiniteScrollContent,
  IonFooter,
  IonSpinner,
} from '@ionic/angular/standalone';

@Component({
  selector: 'app-transactions',
  templateUrl: './transactions.page.html',
  styleUrls: ['./transactions.page.scss'],
  standalone: true,
  imports: [
    IonSpinner,
    IonFooter,
    IonInfiniteScrollContent,
    CommonModule,
    FormsModule,
    IonHeader,
    IonToolbar,
    IonTitle,
    IonContent,
    IonList,
    IonItem,
    IonLabel,
    IonIcon,
    IonInfiniteScroll,
    TranslateModule,
    MyQrCodePage,
    TabBarComponent,
  ],
})
export class TransactionsComponent implements OnInit {
  totalTransactions: number = 0;
  totalAmount: number = 0;
  transactionList: any[] = [];
  offset: number = 0;
  limit: number = 10;
  hasMore: boolean = true;
  showBanner: boolean = true;
  selectedLanguage: string = 'en';
  currentHeader: string = 'TRANSACTIONS';
  fullDate: string;
  showNotification: boolean = true;
  isLoading: boolean = false;

  constructor(
    private apiService: ApiService,
    private translate: TranslateService,
    private router: Router,
    private localStorageService: LocalStorageService,
    private cdr: ChangeDetectorRef,
    private fcmService: FcmService,
    private notificationHandler: NotificationHandlerService
  ) {
    // Initialize fullDate with the current date and time
    this.fullDate = new Date().toLocaleString('en-GB', {
      weekday: 'long',
      day: '2-digit',
      month: 'short',
      year: 'numeric'
     
    });
  }

  ngOnInit() {
    const accessToken = this.localStorageService.getItem('access_token');
  if (!accessToken) {
    console.error('Access token is missing. Please log in again.');
   
  } else {
    console.log('Access token found:', accessToken);
    // Proceed with API calls using access_token
  }
    this.setLanguage();
    this.fcmService.initPush();
    this.notificationHandler.startPolling();
  }

  ionViewWillEnter() {
    this.resetData();
    this.fetchPaymentSummary();
    this.fetchTransactions();
  }

  resetData() {
    this.transactionList = [];
    this.offset = 0;
    this.hasMore = true;
    this.isLoading = false;
  }

  navigateTo(): void {
    this.router.navigate(['/qr-view'], { replaceUrl: true });
  }

  setLanguage() {
    const storedLanguage = localStorage.getItem('selectedLanguage');
    this.selectedLanguage = storedLanguage || this.translate.defaultLang || 'en';
    this.translate.use(this.selectedLanguage);
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
  dismissNotification() {
    console.log('Closing notification');
    this.showBanner = false;
  }

  getRandomColor(): string {
    const letters = '0123456789ABCDEF';
    let color = '#';
    for (let i = 0; i < 6; i++) {
      color += letters[Math.floor(Math.random() * 16)];
    }
    return color;
  }

  // fetchTransactions(event?: any) {
  //   if (!this.hasMore) {
  //     if (event) event.target.disabled = true;
  //     return;
  //   }

  //   this.isLoading = true;

  //   const authToken = 'your-auth-token';
  //   const uuid = '12345';
  //   const vpa = 'test@upi';
  //   const currentDate = new Date().toISOString();

  //   const options = {
  //     fromDateTime: '2024-01-01T00:00:00Z', // Adjust as needed
  //     toDateTime: currentDate, // Use current date
  //     offset: this.offset,
  //     limit: this.limit,
  //   };

  //   this.apiService.getAllPayments(authToken, uuid, vpa, options).subscribe(
  //     (response) => {
  //       this.isLoading = false;
  //       if (response?.code === 2000 && response.data.payments.length > 0) {
  //         // Map each transaction with a unique color and formatted date
  //         const newTransactions = response.data.payments.map((transaction: any) => {
  //           const transactionDate = new Date(transaction.date);
  //           const formattedDate = isNaN(transactionDate.getTime())
  //             ? 'Invalid Date'
  //             : transactionDate.toLocaleString('en-GB', {
  //                 day: '2-digit',
  //                 month: 'short',
  //                 year: 'numeric',
  //                 hour: '2-digit',
  //                 minute: '2-digit',
  //                 second: '2-digit',
  //               });

  //           return {
  //             ...transaction,
  //             color: this.getRandomColor(),
  //             date: formattedDate, // Use the formatted date
  //           };
  //         });

  //         // Append new transactions to the existing list
  //         this.transactionList = [...this.transactionList, ...newTransactions];
  //         this.offset += this.limit;
  //         this.hasMore = response.data.payments.length === this.limit;
  //       } else {
  //         this.hasMore = false;
  //       }
  //       this.cdr.detectChanges();
  //       if (event) event.target.complete();
  //     },
  //     (error) => {
  //       this.isLoading = false;
  //       console.error('Error fetching transactions:', error);
  //       if (event) event.target.complete();
  //     }
  //   );
  // }

  fetchTransactions(event?: any) {
    // If there are no more transactions to load, disable the infinite scroll
    if (!this.hasMore) {
      if (event) event.target.disabled = true;
      return;
    }
  
    // Set isLoading to true only if it's not an infinite scroll event
    if (!event) {
      this.isLoading = true;
    }
  
    // const authToken = 'your-auth-token';
    const authToken = this.localStorageService.getItem('access_token');
    // const uuid = '12345';
    const uuid = this.localStorageService.getItem('uuid');
    // const vpa = 'test@upi';
    const vpa = this.localStorageService.getItem('customerVpa');
    const currentDate = new Date().toISOString();
  
    const options = {
      fromDateTime: '2024-01-01T00:00:00Z', // Adjust as needed
      toDateTime: currentDate, // Use current date
      offset: this.offset,
      limit: this.limit,
    };
  
    this.apiService.getAllPayments(uuid, vpa, options).subscribe(
      (response) => {
        // Set isLoading to false once the data is fetched
        this.isLoading = false;
  
        if (response?.code === 2000 && response.data.payments.length > 0) {
          // Map each transaction with a unique color and formatted date
          
          const newTransactions = response.data.payments.map((transaction: any) => {
            const transactionDate = new Date(transaction.date);
            const formattedDate = isNaN(transactionDate.getTime())
              ? 'Invalid Date'
              : transactionDate.toLocaleString('en-GB', {
                  day: '2-digit',
                  month: 'short',
                  year: 'numeric',
                  hour: '2-digit',
                  minute: '2-digit',
                  second: '2-digit',
                });
  
            return {
              ...transaction,
              color: this.getRandomColor(),
              date: formattedDate, // Use the formatted date
            };
          });
  
          // Append new transactions to the existing list
          this.transactionList = [...this.transactionList, ...newTransactions];
          this.offset += this.limit;
          this.hasMore = response.data.payments.length === this.limit;
        } else {
          this.hasMore = false;
        }
  
        // Trigger change detection
        this.cdr.detectChanges();
  
        // Complete the infinite scroll event if it exists
        if (event) event.target.complete();
      },
      (error) => {
        // Set isLoading to false in case of error
        this.isLoading = false;
        console.error('Error fetching transactions:', error);
  
        // Complete the infinite scroll event if it exists
        if (event) event.target.complete();
      }
    );
  }
}