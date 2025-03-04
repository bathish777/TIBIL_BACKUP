import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { IonRadio, IonLabel, IonRadioGroup, IonModal } from '@ionic/angular/standalone';
import { ApiService } from '../services/api.service';
import { TranslateService, TranslateModule } from '@ngx-translate/core';
import { LocalStorageService } from '../services/local-storage.service';
import { Platform } from '@ionic/angular';
import { LoaderPagePage } from '../loader-page/loader-page.page';

interface Account {
  type: any;
  id: string;
  name: string;
  number: string;
  ifscCode?: string;
  showDetails?: boolean;
}

@Component({
  selector: 'app-account-selection',
  templateUrl: './account-selection.page.html',
  styleUrls: ['./account-selection.page.scss'],
  standalone: true,
  imports: [IonModal,
    IonRadio, IonLabel,
    IonRadioGroup,
    CommonModule, FormsModule, TranslateModule, LoaderPagePage],
})
export class AccountSelectionPage implements OnInit {
  accounts: Account[] = [];
  errorMessage: string = '';
  selectedAccountId: string | null = null;
  mobile: string = '';
  isExpanded: boolean | undefined;
  selectedLanguage: string = 'en';
  isLoader: boolean = false;

  constructor(
    private platform: Platform,
    private apiService: ApiService,
    private router: Router,
    private translate: TranslateService,
    private localStorageService: LocalStorageService // Inject LocalStorageService
  ) {}

  ngOnInit() {
    this.translate.setDefaultLang('en'); // Set default language
    console.log('ngOnInit called');
    this.getMobileNumberFromStorage();
    this.fetchAccounts();
  }

  // Retrieve mobile number from LocalStorage using LocalStorageService
  getMobileNumberFromStorage() {
    this.mobile = this.localStorageService.getItem('mobile_number'); // Use LocalStorageService to get mobile number
    if (!this.mobile) {
      this.errorMessage = 'Mobile number is not found in storage.';
      console.error(this.errorMessage);
    } else {
      console.log('Mobile number retrieved:', this.mobile);
    }
  }

  // Fetch accounts based on mobile number
  // fetchAccounts() {
  //   if (!this.mobile) {
  //     this.errorMessage = 'Mobile number is required to fetch accounts.';
  //     console.error(this.errorMessage);
  //     return;
  //   }

  //   console.log('Fetching accounts for mobile:', this.mobile);
  //   this.apiService.getAccounts(this.mobile).subscribe(
  //     (response: any) => {
  //       if (response.code === 2000) {
  //         this.accounts = response.data.accounts.map((account: any) => ({
  //           id: account.accountId,
  //           name: account.customerFullName,
  //           number: account.customerId,
  //           type: account.accountType,
  //           ifscCode: account.IFSCCode,
  //           showDetails: false,
  //         }));

  //         this.localStorageService.setItem('accounts', JSON.stringify(this.accounts)); // Use LocalStorageService to set accounts
  //         console.log('Accounts fetched successfully:', this.accounts);
  //       } else {
  //         this.errorMessage = response.message || 'Failed to fetch accounts.';
  //         console.error(this.errorMessage);
  //       }
  //     },
  //     (error) => {
  //       this.errorMessage = 'Error fetching accounts. Please try again.';
  //       console.error(this.errorMessage, error);
  //     }
  //   );
  // }
  fetchAccounts() {
    if (!this.mobile) {
      this.errorMessage = 'Mobile number is required to fetch accounts.';
      console.error(this.errorMessage);
      return;
    }
  
    console.log('Fetching accounts for mobile:', this.mobile);
    this.apiService.getAccounts(this.mobile).subscribe(
      (response: any) => {
        if (response.code === 2000) {
          this.accounts = response.data.accounts.map((account: any) => ({
            id: account.accountId,
            name: account.customerFullName,
            number: account.customerId,
            type: account.accountType,
            ifscCode: account.IFSCCode,
            showDetails: false,
          }));
  
          this.localStorageService.setItem('accounts', JSON.stringify(this.accounts));
          console.log('Accounts fetched successfully:', this.accounts);
        } else {
          this.errorMessage = response.message || 'Failed to fetch accounts.';
          console.error(this.errorMessage);
        }
      },
      (error) => {
        this.errorMessage = 'Error fetching accounts. Please try again.';
        console.error(this.errorMessage, error);
      }
    );
  }

  // Select account
  onAccountSelected(accountId: string) {
    console.log('Account selected:', accountId);
    this.selectedAccountId = accountId;
    this.localStorageService.setItem('selectedAccountId', accountId); // Use LocalStorageService to set selectedAccountId
  }

  // Toggle account details visibility
  toggleAccountDetails(accountId: string) {
    const account = this.accounts.find((acc) => acc.id === accountId);
    if (account) {
      account.showDetails = !account.showDetails;
      this.isExpanded = this.accounts.some((acc) => acc.showDetails);
      console.log('Toggled details for accountId:', accountId, 'Current state:', account.showDetails);
    }
  }

  // Navigate to the VPA selection page
  navigateToVpaSelection() {
    if (this.selectedAccountId) {
      console.log('Navigating to VPA selection with accountId:', this.selectedAccountId);
      
      // Show loader before navigating
      this.isLoader = true;
  
      this.router.navigate(['/vpa-selection'], {
        queryParams: { accountId: this.selectedAccountId },
      }).then(() => {
        // Hide loader once navigation is complete
        this.isLoader = false;
      }).catch((error) => {
        console.error('Navigation error:', error);
        this.isLoader = false;
      });
    } else {
      this.errorMessage = 'Please select an account before proceeding.';
      console.error(this.errorMessage);
    }
  }
  
  // Change language for translations
  changeLanguage(language: string) {
    console.log('Changing language to:', language);
    this.translate.use(language);
  }
}
