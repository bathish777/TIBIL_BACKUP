import { Component, OnInit } from '@angular/core';
import { NavController, Platform } from '@ionic/angular';
import { ApiService } from '../services/api.service';
import { LocalStorageService } from '../services/local-storage.service';
import { Device } from '@capacitor/device';
import { FcmService } from '../services/fcm.service';
import { TokenManagerService } from '../services/token-manager.service';
import { TranslateModule } from '@ngx-translate/core'; 
import { TranslateService } from '@ngx-translate/core'; 
import { Preferences } from '@capacitor/preferences';


interface PermissionStatus {
  hasPermission: boolean;
}

declare let window: any;

@Component({
  selector: 'app-splash-screen',
  templateUrl: './splash-screen.component.html',
  styleUrls: ['./splash-screen.component.scss'],
  imports: [
    TranslateModule,
  ],
})
export class SplashScreenComponent implements OnInit {
  private readonly requiredPermissions = [
    'READ_SMS',
    'READ_PHONE_STATE',
    'SEND_SMS',
    'RECEIVE_SMS',
  ];

  constructor(
    private navCtrl: NavController,
    private apiService: ApiService,
    private storageService: LocalStorageService,
    private platform: Platform,
    private translate: TranslateService,
    private fcm: FcmService,
    private tokenManager: TokenManagerService // Inject TokenManagerService
  ) {
    if (!this.translate) {
      throw new Error('TranslateService is not available');
    }
    this.translate.use(this.translate.defaultLang); // Ensure default language is set
  }

  async ngOnInit() {
    try {
      await this.platform.ready();
      await this.handlePermissions();
      await this.initializeFCM();
      await this.fetchAndStoreDeviceInfo();
      await this.fetchUserInitData();
      
    } catch (error) {
      console.error('Initialization Error:', error);
    } finally {
      this.redirectBasedOnAuthState();
    }
  }

 

  private async handlePermissions(): Promise<void> {
    const permissions = window.cordova.plugins.permissions;

    const checkPermission = (permission: string): Promise<PermissionStatus> =>
      new Promise((resolve) => {
        permissions.checkPermission(
          permissions[permission],
          resolve,
          () => resolve({ hasPermission: false })
        );
      });

    const requestPermission = (permission: string): Promise<boolean> =>
      new Promise((resolve, reject) => {
        permissions.requestPermission(
          permissions[permission],
          (status: PermissionStatus) =>
            status.hasPermission ? resolve(true) : reject(`Permission denied: ${permission}`),
          reject
        );
      });

    for (const permission of this.requiredPermissions) {
      if (!permissions[permission]) {
        console.error(`Undefined permission: ${permission}`);
        continue;
      }
      const status = await checkPermission(permission);
      if (!status.hasPermission) {
        await requestPermission(permission);
      }
    }
  }

  private async initializeFCM(): Promise<void> {
    try {
      await this.fcm.initPush();
    } catch (error) {
      console.error('FCM Initialization Error:', error);
    }
  }

  private async fetchAndStoreDeviceInfo(): Promise<void> {
    try {
      const deviceId = await Device.getId();
      this.storageService.setItem('deviceId', deviceId);
    } catch (error) {
      console.error('Device Info Fetching Error:', error);
    }
  }

  private fetchUserInitData(): void {
    this.apiService.getUserInit().subscribe(
      (response: any) => {
        if (response.code === 2000) {
          const { vmn_list, guest_token } = response.data;
          this.storageService.setItem('vmn_list', vmn_list);
          this.storageService.setItem('guest_token', guest_token);
          this.tokenManager.setGuestToken(guest_token); // Set the guest token
        } else {
          console.warn('User Init API Error:', response.message || 'Unexpected error');
        }
      },
      (error) => {
        console.error('Error Fetching User Init Data:', error);
      }
    );
  }

  // private redirectBasedOnAuthState(): void {
  //   this.platform.ready().then(() => {
  //     const userCredential = this.storageService.getItem('userCredential');

  //     console.log('Stored User Credential:', userCredential);

  //     // Ensure translations are loaded before navigating
  //     this.translate.use('en').subscribe(() => {
  //       if (userCredential) {
  //         console.log('User credentials found, redirecting to Forgot MPIN page.');
  //         this.navCtrl.navigateRoot('/forgot-mpin');
  //       } else {
  //         console.log('No user credentials, redirecting to Home page.');
  //         this.navCtrl.navigateRoot('/home');
  //       }
  //     });
  //   });
  // }
  // private redirectBasedOnAuthState(): void {
  //   this.platform.ready().then(() => {
  //     const userCredential = JSON.parse(this.storageService.getItem('userCredential') || '{}');
  
  //     console.log('Stored User Credential:', userCredential); // Debug log
  
  //     // Ensure translations are loaded before navigating
  //     this.translate.use('en').subscribe(() => {
  //       if (userCredential && userCredential.verifiedLoginPin) {
  //         // Retrieve the access token and verifiedLoginPin from userCredential
  //         const accessToken = userCredential.accessToken;
  //         const verifiedLoginPin = userCredential.verifiedLoginPin;
  
  //         // Store them in localStorage
  //         if (accessToken) {
  //           localStorage.setItem('access_token', accessToken);
  //         }
  //         if (verifiedLoginPin) {
  //           localStorage.setItem('verifiedLoginPin', verifiedLoginPin);
  //         }
  
  //         console.log('User credentials found, redirecting to Forgot MPIN page.');
  //         this.navCtrl.navigateRoot('/forgot-mpin');
  //       } else {
  //         console.log('No user credentials, redirecting to Home page.');
  //         this.navCtrl.navigateRoot('/home');
  //       }
  //     });
  //   });
  // }
  private redirectBasedOnAuthState(): void {
    this.platform.ready().then(() => {
      const userCredential = JSON.parse(this.storageService.getItem('userCredential') || '{}');
  
      console.log('Stored User Credential:', userCredential); // Debug log
  
      // Ensure translations are loaded before navigating
      this.translate.use('en').subscribe(() => {
        if (userCredential && userCredential.verifiedLoginPin) {
          // Retrieve the access token and verifiedLoginPin from userCredential
          const accessToken = userCredential.accessToken;
          const verifiedLoginPin = userCredential.verifiedLoginPin;
  
          // Store them in localStorage
          if (accessToken) {
            localStorage.setItem('access_token', accessToken);
          }
          if (verifiedLoginPin) {
            localStorage.setItem('verifiedLoginPin', verifiedLoginPin);
          }
  
          console.log('User credentials found, redirecting to Forgot MPIN page.');
          console.log('Access Token:', accessToken); // Debug log
          console.log('Verified Login PIN:', verifiedLoginPin); // Debug log
  
          this.navCtrl.navigateRoot('/forgot-mpin');
        } else {
          console.log('No user credentials, redirecting to Home page.');
          this.navCtrl.navigateRoot('/home');
        }
      });
    });
  }
}