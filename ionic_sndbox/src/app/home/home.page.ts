/* eslint-disable no-dupe-class-members */
/* eslint-disable @typescript-eslint/no-unused-vars */
import { Component, ChangeDetectorRef, OnDestroy } from '@angular/core';
import { Router } from '@angular/router';
// import { Platform, IonicModule, IonCheckbox } from '@ionic/angular';
import { App } from '@capacitor/app'; // Import Capacitor's App plugin
// import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';
import { ApiService } from '../services/api.service';
import * as Base64 from 'crypto-js/enc-base64';
// import { ScreenOrientation } from '@capacitor/screen-orientation';


// import { HttpClientModule } from '@angular/common/http';
import * as Utf8 from 'crypto-js/enc-utf8';
import { TranslateService, TranslateModule } from '@ngx-translate/core';

import { registerPlugin } from '@capacitor/core';
import { LoaderPagePage } from '../loader-page/loader-page.page';
import { LocalStorageService } from '../services/local-storage.service';
import { Subscription } from 'rxjs';
import {   IonicModule, Platform } from '@ionic/angular';
import { CommonModule } from '@angular/common';
import { IonCheckbox,IonRadio, IonRadioGroup ,IonHeader,
  IonToolbar,
  IonTitle,
  IonContent,
  IonItem,
  IonLabel,

  IonButton,
  IonButtons,
  IonModal,
  } from '@ionic/angular/standalone';

export interface SimCard {
  carrierName: string;
  simSlotIndex: number;
  subscriptionId: number;
}

export interface SimInfo {
  cards: SimCard[];
}

export interface SimBindPlugin {
  getSimInfo(): Promise<SimInfo>;
  sendSMS(options: { vmnNumber: string; message: string; simSlot: number }): Promise<{ status: string }>;
}

@Component({
  selector: 'app-home',
  templateUrl: 'home.page.html',
  styleUrls: ['home.page.scss'],
  standalone: true,
  imports: [
    IonRadio,
    IonModal,
    IonButtons,
    IonButton,
    IonTitle,
    IonContent,
    IonItem,
    IonLabel,
    IonCheckbox,
    IonToolbar,
    CommonModule,
    FormsModule,
    HttpClientModule,
    

    
    
    IonCheckbox, // Imported as standalone
    IonRadio,    // Imported as standalone
    IonRadioGroup, // Imported as standalone
    HttpClientModule, // ✅ Add this
    
    
    
    TranslateModule,
    LoaderPagePage,
    FormsModule,
    
    
],
  providers: [ApiService, LoaderPagePage, LocalStorageService],
})
export class HomePage implements OnDestroy {
  simInfo: SimInfo = { cards: [] };
  errorMessage: string = '';
  isTermsAccepted: boolean = false;
  isSimSelected: boolean = false;
  selectedSim: SimCard | null = null;
  isModalOpen: boolean = false;
  termsContent: string = '';
  isLoader: boolean = false;

  // Plugin registration for SimBind
  SimBind = registerPlugin<SimBindPlugin>('SimBindPlugin');

  // Subscription for the back button event on HomePage
  public backButtonSubscription?: Subscription;

  constructor(
    private router: Router,
    private apiService: ApiService,
    private loaderPage: LoaderPagePage,
    private cdr: ChangeDetectorRef,
    private storageService: LocalStorageService,
    public translate: TranslateService,
    private platform: Platform,
    
  ) {
    this.translate.setDefaultLang('en');
    this.getSimInfo();
  }
 
  // ionViewDidEnter() {
  //   // Subscribe to the hardware back button event with a high priority on HomePage.
  //   // This ensures that when the user is on the HomePage, pressing the back button exits the app.
  //   this.backButtonSubscription = this.platform.backButton.subscribeWithPriority(9999, () => {
  //     console.log('Hardware back button pressed on HomePage. Exiting app...');
  //     App.exitApp();
  //   });
  // }

  ionViewWillLeave() {
    // Unsubscribe from the back button event when leaving HomePage to restore default behavior on other pages.
    this.backButtonSubscription?.unsubscribe();
  }

  // ngOnDestroy() {
  //   // Ensure subscription is cleaned up if the component is destroyed.
  //   this.backButtonSubscription?.unsubscribe();
  // }

  // async getSimInfo() {
  //   try {
  //     console.log('Fetching SIM info...');
  //     const response = await this.SimBind.getSimInfo();
  //     console.log('SIM info fetched:', response);
  //     this.simInfo = response;
  //   } catch (error) {
  //     console.error('Error fetching SIM info:', error);
  //     this.simInfo = { cards: [] };
  //     this.errorMessage = this.translate.instant('ERROR.SIM_INFO');
  //   }
  // }
  // async getSimInfo() {
  //   try {
  //     if (this.platform.is('android') || this.platform.is('ios')) {
  //       console.log('Fetching SIM info...');
  //       const response = await this.SimBind.getSimInfo();
  //       console.log('SIM info fetched:', response);
  //       this.simInfo = response;
  //     } else {
  //       console.warn('SIM Bind Plugin is not available on the web');
  //       this.errorMessage = this.translate.instant('ERROR.SIM_INFO');
  //     }
  //   } catch (error) {
  //     console.error('Error fetching SIM info:', error);
  //     this.simInfo = { cards: [] };
  //     this.errorMessage = this.translate.instant('ERROR.SIM_INFO');
  //   }
  // }
  async getSimInfo() {
    try {
      if (this.platform.is('android') || this.platform.is('ios')) {
        console.log('Fetching SIM info...');
        const response = await this.SimBind.getSimInfo();
        console.log('SIM info fetched:', response);
        this.simInfo = response;
      } else {
        console.warn('SIM Bind Plugin is not available on the web');
        this.errorMessage = this.translate.instant('ERROR.SIM_INFO');
      }
    } catch (error) {
      console.error('Error fetching SIM info:', error);
      this.simInfo = { cards: [] };
      this.errorMessage = this.translate.instant('ERROR.SIM_INFO');
    }
  }
  // async onNextClick() {
  //   this.isLoader = true;
  //   this.cdr.detectChanges();
  //   console.log('Next button clicked, isSimSelected:', this.isSimSelected);
  //   if (!this.isSimSelected) {
  //     alert(this.translate.instant('ERROR.SELECT_SIM'));
  //     return;
  //   }
  
  //   try {
  //     console.log('Showing loader...');
  //     this.loaderPage.show();
  
  //     const vmnList = this.storageService.getItem('vmn_list');
  //     console.log('Fetched VMN list:', vmnList);
  //     const smsSuccess = await this.sendSMSToVmnList(vmnList);
  
  //     if (smsSuccess) {
  //       console.log('SMS sent successfully, attempting to fetch mobile number...');
  //       const mobileNumberFetched = await this.fetchMobileNumberWithRetries(3, 3000);
  //       if (mobileNumberFetched) {
  //         this.isLoader = false;
  //         this.cdr.detectChanges();
  //         console.log('Mobile number fetched, navigating to account selection...');
  //         this.router.navigate(['/account-selection']);
  //       } else {
  //         this.isLoader = false;
  //         alert(this.translate.instant('ERROR.MOBILE_FETCH'));
  //       }
  //     } else {
  //       this.isLoader = false;
  //       alert(this.translate.instant('ERROR.SMS_SEND'));
  //     }
  //   } catch (error) {
  //     this.isLoader = false;
  //     console.error('Error in onNextClick:', error);
  //   } finally {
  //     this.isLoader = false;
  //     this.loaderPage.hide();
  //   }
  // }
  // async onNextClick() {
  //   this.isLoader = true;
  //   this.cdr.detectChanges();
  //   console.log('Next button clicked, isSimSelected:', this.isSimSelected);
  //   if (!this.isSimSelected) {
  //     alert(this.translate.instant('ERROR.SELECT_SIM'));
  //     this.isLoader = false;
  //     this.cdr.detectChanges();
  //     return;
  //   }
  
  //   try {
  //     console.log('Showing loader...');
  //     this.loaderPage.show();
  
  //     const vmnList = this.storageService.getItem('vmn_list');
  //     console.log('Fetched VMN list:', vmnList);
  //     const smsSuccess = await this.sendSMSToVmnList(vmnList);
  
  //     if (smsSuccess) {
  //       console.log('SMS sent successfully, attempting to fetch mobile number...');
  //       const mobileNumberFetched = await this.fetchMobileNumberWithRetries(3, 3000);
  //       if (mobileNumberFetched) {
  //         this.isLoader = false;
  //         this.cdr.detectChanges();
  //         console.log('Mobile number fetched, navigating to account selection...');
  //         this.router.navigate(['/account-selection']);
  //       } else {
  //         this.isLoader = false;
  //         this.cdr.detectChanges();
  //         alert(this.translate.instant('ERROR.MOBILE_FETCH'));
  //       }
  //     } else {
  //       this.isLoader = false;
  //       this.cdr.detectChanges();
  //       alert(this.translate.instant('ERROR.SMS_SEND'));
  //     }
  //   } catch (error) {
  //     this.isLoader = false;
  //     this.cdr.detectChanges();
  //     console.error('Error in onNextClick:', error);
  //   } finally {
  //     this.isLoader = false;
  //     this.loaderPage.hide();
  //     this.cdr.detectChanges();
  //   }
  // }

  
  
  ngOnDestroy() {
    console.log('Unsubscribing from back button event');
    this.backButtonSubscription?.unsubscribe();
  }
  async onNextClick() {
    console.log('onNextClick called');
    this.isLoader = true;
    this.cdr.detectChanges();
    console.log('isSimSelected:', this.isSimSelected);
  
    if (!this.isSimSelected) {
      console.log('No SIM selected, showing alert');
      alert(this.translate.instant('ERROR.SELECT_SIM'));
      this.isLoader = false;
      this.cdr.detectChanges();
      return;
    }
  
    try {
      console.log('Showing loader...');
      this.loaderPage.show();
  
      const vmnList = this.storageService.getItem('vmn_list');
      console.log('Fetched VMN list:', vmnList);
      const smsSuccess = await this.sendSMSToVmnList(vmnList);
      console.log('SMS send result:', smsSuccess);
  
      if (smsSuccess) {
        console.log('SMS sent successfully, attempting to fetch mobile number...');
        const mobileNumberFetched = await this.fetchMobileNumberWithRetries(3, 3000);
        console.log('Mobile number fetch result:', mobileNumberFetched);
  
        if (mobileNumberFetched) {
          console.log('Mobile number fetched, navigating to account selection...');
          this.isLoader = false;
          this.cdr.detectChanges();
          this.router.navigate(['/account-selection']);
        } else {
          console.log('Mobile number fetch failed, showing alert');
          this.isLoader = false;
          this.cdr.detectChanges();
          alert(this.translate.instant('ERROR.MOBILE_FETCH'));
        }
      } else {
        console.log('SMS send failed, showing alert');
        this.isLoader = false;
        this.cdr.detectChanges();
        alert(this.translate.instant('ERROR.SMS_SEND'));
      }
    } catch (error) {
      console.error('Error in onNextClick:', error);
      this.isLoader = false;
      this.cdr.detectChanges();
    } finally {
      console.log('Hiding loader...');
      this.isLoader = false;
      this.loaderPage.hide();
      this.cdr.detectChanges();
    }
  }
  
  public async fetchMobileNumberWithRetries(maxRetries: number, delayMs: number): Promise<boolean> {
    console.log(`Fetching mobile number with retries: ${maxRetries}, delay: ${delayMs}`);
    for (let attempt = 1; attempt <= maxRetries; attempt++) {
      const success = await this.fetchMobileNumberFromAPI();
      if (success) {
        console.log('Mobile number fetched successfully!');
        return true;
      }
      console.log(`Retry attempt ${attempt} failed, retrying...`);
      await this.delay(delayMs);
    }
    console.log('Max retries reached, mobile number fetch failed');
    return false;
  }

  public delay(ms: number): Promise<void> {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }

  // public async sendSMSToVmnList(vmnList: any[]): Promise<boolean> {
  //   const vmnNumbers = this.getActiveVmnNumbers(vmnList);
  //   console.log('VMN numbers to send SMS to:', vmnNumbers);
  //   if (!vmnNumbers || vmnNumbers.length === 0) {
  //     console.error('No valid VMN numbers found.');
  //     return false;
  //   }

  //   const encodedMsg = this.encodedMessage('');

  //   for (const vmnNumber of vmnNumbers) {
  //     try {
  //       console.log(`Sending SMS to VMN number: ${vmnNumber}`);
  //       const result = await this.SimBind.sendSMS({
  //         vmnNumber: vmnNumber.toString(),
  //         message: encodedMsg,
  //         simSlot: this.selectedSim!.simSlotIndex,
  //       });

  //       if (result.status === 'SMS sent successfully.') {
  //         console.log(`SMS sent successfully to ${vmnNumber}`);
  //         return true;
  //       }
  //     } catch (error) {
  //       console.error(`Error sending SMS to ${vmnNumber}:`, error);
  //     }
  //   }
  //   return false;
  // }
  public async sendSMSToVmnList(vmnList: any[]): Promise<boolean> {
    if (!vmnList || vmnList.length === 0) {
      console.error('No valid VMN numbers found.');
      return false;
    }
  
    const vmnNumbers = this.getActiveVmnNumbers(vmnList);
    console.log('VMN numbers to send SMS to:', vmnNumbers);
    if (!vmnNumbers || vmnNumbers.length === 0) {
      console.error('No valid VMN numbers found.');
      return false;
    }
  
    const encodedMsg = this.encodedMessage('');
  
    for (const vmnNumber of vmnNumbers) {
      try {
        console.log(`Sending SMS to VMN number: ${vmnNumber}`);
        const result = await this.SimBind.sendSMS({
          vmnNumber: vmnNumber.toString(),
          message: encodedMsg,
          simSlot: this.selectedSim!.simSlotIndex,
        });
  
        if (result.status === 'SMS sent successfully.') {
          console.log(`SMS sent successfully to ${vmnNumber}`);
          return true;
        }
      } catch (error) {
        console.error(`Error sending SMS to ${vmnNumber}:`, error);
      }
    }
    return false;
  }
  public getActiveVmnNumbers(vmnList: any[]): string[] {
    const primaryVmnNumbers = vmnList.filter((vmn) => vmn.is_primary).map((vmn) => vmn.vmn_number);
    return primaryVmnNumbers.length > 0 ? primaryVmnNumbers : vmnList.map((vmn) => vmn.vmn_number);
  }

  // encodedMessage(simNumber: string): string {
  //   const deviceId = this.storageService.getItem('deviceId');
  //   const timestamp = new Date().getTime();
  //   const message = `${deviceId},${simNumber},${timestamp}`;
  //   const utf8Message = Utf8.parse(message);
  //   const encodedMessage = Base64.stringify(utf8Message);
    
  //   // Store the encoded message in local storage
  //   this.storageService.setItem('encodedMessage', encodedMessage);
    
  //   return encodedMessage;
  // }
  encodedMessage(simNumber: string): string {
    const deviceId = this.storageService.getItem('deviceId');
    console.log('[DEBUG] Device ID:', deviceId);
  
    const timestamp = new Date().getTime();
    console.log('[DEBUG] Timestamp:', timestamp);
  
    const message = `${deviceId},${simNumber},${timestamp}`;
    console.log('[DEBUG] Message:', message);
  
    const utf8Message = Utf8.parse(message);
    const encodedMessage = Base64.stringify(utf8Message);
    console.log('[DEBUG] Encoded Message:', encodedMessage);
  
    // Store the encoded message in local storage
    this.storageService.setItem('encodedMessage', encodedMessage);
    console.log('[DEBUG] Encoded message saved to local storage');
  
    return encodedMessage;
  }
  
  // public fetchMobileNumberFromAPI(): Promise<boolean> {
  //   return new Promise((resolve) => {
  //     const encodedMessage = this.storageService.getItem('encodedMessage');
  //     console.log('[DEBUG] Encoded Message:', encodedMessage);
  
  //     if (!encodedMessage) {
  //       console.error('[ERROR] Encoded message is missing in local storage.');
  //       resolve(false);
  //       return;
  //     }
  
  //     console.log('[INFO] Making API call to fetch user devices...');
  
  //     this.apiService.getUserDevices(encodedMessage)?.subscribe(
  //       (response: { code: number; mobile_number?: string }) => {
  //         console.log('[DEBUG] API Response:', response);
  
  //         if (response.code !== 2000) {
  //           console.error('[ERROR] Invalid response code:', response.code);
  //           resolve(false);
  //           return;
  //         }
  
  //         try {
  //           const mobileNumber = response.mobile_number;
  
  //           if (mobileNumber) {
  //             this.storageService.setItem('mobile_number', mobileNumber);
  //             console.log('[SUCCESS] Mobile number saved:', mobileNumber);
  //           } else {
  //             console.warn('[WARNING] No mobile number found in response.');
  //           }
  
  //           this.storageService.setItem('userDevices', JSON.stringify(response));
  //           console.log('[SUCCESS] User devices saved successfully.');
  //           resolve(true);
  //         } catch (error) {
  //           console.error('[ERROR] Failed to save user devices:', error);
  //           resolve(false);
  //         }
  //       },
  //       (error: any) => {
  //         console.error('[ERROR] API request failed:', JSON.stringify(error));
  //         resolve(false);
  //       }
  //     );
  //   });
  // }
  // public fetchMobileNumberFromAPI(): Promise<boolean> {
  //   return new Promise((resolve) => {
  //     const encodedMessage = this.storageService.getItem('encodedMessage');
  //     console.log('[DEBUG] Encoded Message:', encodedMessage);
  
  //     if (!encodedMessage) {
  //       console.error('[ERROR] Encoded message is missing in local storage.');
  //       resolve(false);
  //       return;
  //     }
  
  //     console.log('[INFO] Making API call to fetch user devices...');
  
  //     this.apiService.getUserDevices(encodedMessage)?.subscribe(
  //       (response: { code: number; mobile_number?: string }) => {
  //         console.log('[DEBUG] API Response:', response);
  
  //         if (response.code !== 2000) {
  //           console.error('[ERROR] Invalid response code:', response.code);
  //           resolve(false);
  //           return;
  //         }
  
  //         try {
  //           const mobileNumber = response.mobile_number;
  
  //           if (mobileNumber) {
  //             this.storageService.setItem('mobile_number', mobileNumber);
  //             console.log('[SUCCESS] Mobile number saved:', mobileNumber);
  //           } else {
  //             console.warn('[WARNING] No mobile number found in response.');
  //           }
  
  //           this.storageService.setItem('userDevices', JSON.stringify(response));
  //           console.log('[SUCCESS] User devices saved successfully.');
  //           resolve(true);
  //         } catch (error) {
  //           console.error('[ERROR] Failed to save user devices:', error);
  //           resolve(false);
  //         }
  //       },
  //       (error: any) => {
  //         console.error('[ERROR] API request failed:', JSON.stringify(error));
  //         resolve(false);
  //       }
  //     );
  //   });
  // }
  // public fetchMobileNumberFromAPI(): Promise<boolean> {
  //   return new Promise((resolve) => {
  //     const encodedMessage = this.storageService.getItem('encodedMessage');
  //     console.log('[DEBUG] Encoded Message:', encodedMessage);
  
  //     if (!encodedMessage) {
  //       console.error('[ERROR] Encoded message is missing in local storage.');
  //       resolve(false);
  //       return;
  //     }
  
  //     console.log('[INFO] Making API call to fetch user devices...');
  
  //     this.apiService.getUserDevices(encodedMessage)?.subscribe(
  //       (response: { code: number; mobile_number?: string }) => {
  //         console.log('[DEBUG] API Response:', response);
  
  //         if (response.code !== 2000) {
  //           console.error('[ERROR] Invalid response code:', response.code);
  //           resolve(false);
  //           return;
  //         }
  
  //         try {
  //           const mobileNumber = response.mobile_number;
  
  //           if (mobileNumber) {
  //             this.storageService.setItem('mobile_number', mobileNumber);
  //             console.log('[SUCCESS] Mobile number saved:', mobileNumber);
  //           } else {
  //             console.warn('[WARNING] No mobile number found in response.');
  //           }
  
  //           this.storageService.setItem('userDevices', JSON.stringify(response));
  //           console.log('[SUCCESS] User devices saved successfully.');
  //           resolve(true);
  //         } catch (error) {
  //           console.error('[ERROR] Failed to save user devices:', error);
  //           resolve(false);
  //         }
  //       },
  //       (error: any) => {
  //         console.error('[ERROR] API request failed:', JSON.stringify(error));
  //         resolve(false);
  //       }
  //     );
  //   });
  // }
  // 
  // public fetchMobileNumberFromAPI(): Promise<boolean> {
  //   return new Promise((resolve) => {
  //     const encodedMessage = this.storageService.getItem('encodedMessage');
  //     console.log('[DEBUG] Encoded Message:', encodedMessage);
  
  //     if (!encodedMessage) {
  //       console.error('[ERROR] Encoded message is missing in local storage.');
  //       resolve(false);
  //       return;
  //     }
  
  //     console.log('[INFO] Making API call to fetch user devices...');
  
  //     this.apiService.getUserDevices(encodedMessage)?.subscribe(
  //       (response: { code: number; mobile_number?: string }) => {
  //         console.log('[DEBUG] API Response:', response);
  
  //         if (response.code !== 2000) {
  //           console.error('[ERROR] Invalid response code:', response.code);
  //           resolve(false);
  //           return;
  //         }
  
  //         try {
  //           const mobileNumber = response.mobile_number;
  
  //           if (mobileNumber) {
  //             this.storageService.setItem('mobile_number', mobileNumber);
  //             console.log('[SUCCESS] Mobile number saved:', mobileNumber);
  //           } else {
  //             console.warn('[WARNING] No mobile number found in response.');
  //           }
  
  //           this.storageService.setItem('userDevices', JSON.stringify(response));
  //           console.log('[SUCCESS] User devices saved successfully.');
  //           resolve(true);
  //         } catch (error) {
  //           console.error('[ERROR] Failed to save user devices:', error);
  //           resolve(false);
  //         }
  //       },
  //       (error: any) => {
  //         console.error('[ERROR] API request failed:', JSON.stringify(error));
  //         resolve(false);
  //       }
  //     );
  //   });
  // }
  public fetchMobileNumberFromAPI(): Promise<boolean> {
    return new Promise((resolve) => {
        const encodedMessage = this.storageService.getItem('encodedMessage');
        console.log('[DEBUG] Encoded Message:', encodedMessage);

        if (!encodedMessage) {
            console.error('[ERROR] Encoded message is missing in local storage.');
            resolve(false);
            return;
        }

        console.log('[INFO] Making API call to fetch user devices...');

        this.apiService.getUserDevices(encodedMessage)?.subscribe(
            (response: { code: number; mobile_number?: string; data?: { poll_interval_secs?: number } }) => {
                console.log('[DEBUG] API Response:', response);

                if (response.code !== 2000) {
                    console.error('[ERROR] Invalid response code:', response.code);
                    resolve(false);
                    return;
                }

                try {
                    const mobileNumber = response.mobile_number;
                    const pollIntervalSecs = response.data?.poll_interval_secs || 30; // Default to 30 seconds if not provided

                    if (mobileNumber) {
                        this.storageService.setItem('mobile_number', mobileNumber);
                        console.log('[SUCCESS] Mobile number saved:', mobileNumber);
                    } else {
                        console.warn('[WARNING] No mobile number found in response.');
                    }

                    // Save polling interval to local storage
                    this.storageService.setItem('poll_interval_secs', pollIntervalSecs.toString());
                    console.log('[SUCCESS] Polling interval saved:', pollIntervalSecs);

                    this.storageService.setItem('userDevices', JSON.stringify(response));
                    console.log('[SUCCESS] User devices saved successfully.');
                    resolve(true);
                } catch (error) {
                    console.error('[ERROR] Failed to save user devices:', error);
                    resolve(false);
                }
            },
            (error: any) => {
                console.error('[ERROR] API request failed:', JSON.stringify(error));
                resolve(false);
            }
        );
    });
}
  // async openTermsModal() {
  //   console.log('Opening terms modal...');
  //   this.apiService.getTermsAndConditions()?.subscribe(
  //     (response: { code: number; message: string }) => {
  //       if (response && response.message) {
  //         this.termsContent = response.message;
  //         console.log('Fetched terms content:', this.termsContent);
  //       } else {
  //         this.termsContent = this.translate.instant('ERROR.NO_TERMS');
  //         console.log('No terms content available');
  //       }
  //       this.isModalOpen = true;
  //     },
  //     () => {
  //       this.termsContent = this.translate.instant('ERROR.TERMS_LOAD');
  //       console.log('Error loading terms content');
  //       this.isModalOpen = true;
  //     }
  //   );
  // }
  ionViewDidEnter() {
    console.log('Subscribing to back button event');
    this.backButtonSubscription = this.platform.backButton.subscribeWithPriority(9999, () => {
      console.log('Hardware back button pressed on HomePage. Exiting app...');
      App.exitApp();
    });
  }

  
  async openTermsModal() {
    console.log('Opening terms modal...');
    this.apiService.getTermsAndConditions()?.subscribe(
      (response: { code: number; message: string }) => {
        if (response && response.message) {
          this.termsContent = response.message;
          console.log('Fetched terms content:', this.termsContent);
        } else {
          this.termsContent = this.translate.instant('ERROR.NO_TERMS');
          console.log('No terms content available');
        }
        this.isModalOpen = true;
        console.log('Modal opened:', this.isModalOpen);
      },
      () => {
        this.termsContent = this.translate.instant('ERROR.TERMS_LOAD');
        console.log('Error loading terms content');
        this.isModalOpen = true;
        console.log('Modal opened:', this.isModalOpen);
      }
    );
  }
  onSimSelected(sim: SimCard | null) {
    console.log('SIM selected:', sim);
    this.selectedSim = sim;
    this.isSimSelected = !!sim;
  }

  closeTermsModal() {
    console.log('Closing terms modal...');
    this.isModalOpen = false;
    document.body.classList.remove('modal-open');
  }

  changeLanguage(language: string) {
    console.log(`Changing language to: ${language}`);
    this.translate.use(language);
  }
  openModal() {
    this.isModalOpen = true;
    document.body.classList.add('modal-open');
  }
}
