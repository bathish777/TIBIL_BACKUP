import { Injectable } from '@angular/core';
import { Capacitor } from '@capacitor/core';
import { ActionPerformed, PushNotifications, PushNotificationSchema, Token } from '@capacitor/push-notifications';
import { BehaviorSubject } from 'rxjs';
import { StorageService } from './storage.service';
import { TextToSpeech } from '@capacitor-community/text-to-speech';
import { LocalNotifications } from '@capacitor/local-notifications';

@Injectable({
  providedIn: 'root',
})
export class FcmService {
  private _isMuted = false; // Tracks the mute state
  private _redirect = new BehaviorSubject<any>(null); // For handling redirects
  private _announcementQueue: { pid: number; amount: number }[] = []; // Queue for announcements
  private _isAnnouncing = false; // Tracks if an announcement is in progress

  get redirect() {
    return this._redirect.asObservable();
  }

  constructor(private storage: StorageService) {
    // Initialize the mute state from localStorage
    this._isMuted = JSON.parse(localStorage.getItem('isMuted') || 'false');
  }

  /**
   * Initializes push notifications.
   */
  // initPush() {
  //   if (Capacitor.getPlatform() !== 'web') {
  //     this.registerPush();
  //   }
  // }
  initPush() {
    if (Capacitor.getPlatform() !== 'web') {
      this.registerPush(); // Ensure this is being called
    }
  }
  /**
   * Displays a local notification with the received amount.
   */
  async showNotification(amount: number): Promise<void> {
    const randomId = Math.floor(Math.random() * 10000); // Generate a random ID

    await LocalNotifications.schedule({
      notifications: [
        {
          id: randomId,
          title: 'Amount Received',
          body: `${this.getFormattedAmount(amount)} is credited in your Soundbox`,
          extra: { payload: 'Hello' },
        },
      ],
    });
  }

  /**
   * Displays a local notification for OTP.
   */
  // async showOtpNotification(otp: string): Promise<void> {
  //   const randomId = Math.floor(Math.random() * 10000); // Generate a random ID

  //   await LocalNotifications.schedule({
  //     notifications: [
  //       {
  //         id: randomId,
  //         title: 'OTP Received',
  //         body: `Your OTP is ${otp}. Do not share it with anyone.`,
  //         extra: { payload: 'OTP' },
  //       },
  //     ],
  //   });
  // }
  async showOtpNotification(otp: string, action?: string): Promise<void> {
    const randomId = Math.floor(Math.random() * 10000); // Generate a random ID
  
    let title: string;
    let body: string;
  
    // Customize the notification based on the action
    switch (action) {
      case 'forgot-login-pin':
        title = 'Reset Login PIN OTP';
        body = `Your OTP to reset your login PIN is ${otp}. Do not share it with anyone.`;
        break;
      case 'forgot-mpin':
        title = 'Reset MPIN OTP';
        body = `Your OTP to reset your MPIN is ${otp}. Do not share it with anyone.`;
        break;
      default:
        title = 'OTP Received';
        body = `Your OTP is ${otp}. Do not share it with anyone.`;
        break;
    }
  
    await LocalNotifications.schedule({
      notifications: [
        {
          id: randomId,
          title: title,
          body: body,
          extra: { payload: 'OTP' },
        },
      ],
    });
  }
  /**
   * Formats the amount with commas (e.g., 10000 -> "10,000").
   */
  private getFormattedAmount(amount: number): string {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD',
    }).format(amount);
  }

  /**
   * Registers the device for push notifications.
   */
  // private async registerPush() {
  //   try {
  //     await this.addListeners();
  //     let permStatus = await PushNotifications.checkPermissions();

  //     if (permStatus.receive === 'prompt') {
  //       permStatus = await PushNotifications.requestPermissions();
  //     }

  //     if (permStatus.receive !== 'granted') {
  //       throw new Error('User denied permissions!');
  //     }

  //     await PushNotifications.register();
  //   } catch (e) {
  //     console.log(e);
  //   }
  // }
  private async registerPush() {
    try {
      await this.addListeners();
      let permStatus = await PushNotifications.checkPermissions();
  
      if (permStatus.receive === 'prompt') {
        permStatus = await PushNotifications.requestPermissions();
      }
  
      if (permStatus.receive !== 'granted') {
        throw new Error('User denied permissions!');
      }
  
      console.log('About to call PushNotifications.register'); // Debug log
      await PushNotifications.register();
      console.log('PushNotifications.register called'); // Debug log
    } catch (e) {
      console.log(e);
    }
  }
  /**
   * Adds listeners for push notification events.
   */
  addListeners() {
    PushNotifications.addListener('registration', async (token: Token) => {
      console.log('FCM TOKEN: ', token);
      this.storage.setStorage('FCM_TOKEN', JSON.stringify(token.value));
    });

    PushNotifications.addListener('registrationError', (error: any) => {
      console.log('Error: ' + JSON.stringify(error));
    });

    PushNotifications.addListener(
      'pushNotificationReceived',
      async (notification: PushNotificationSchema) => {
        const data = notification?.data;
        console.log('Notification Data:', data);

        // Handle OTP notifications
        if (data?.otp) {
          this.showOtpNotification(data.otp); // Display OTP notification
        }

        if (data?.announce) {
          this.addToAnnouncementQueue(data.announce);
        }
        if (data?.redirect) {
          this._redirect.next(data?.redirect);
        }
      }
    );

    PushNotifications.addListener(
      'pushNotificationActionPerformed',
      async (notification: ActionPerformed) => {
        const data = notification.notification.data;
        if (data?.redirect) {
          this._redirect.next(data?.redirect);
        }
      }
    );
  }

  /**
   * Adds a payment announcement to the queue.
   */
  private addToAnnouncementQueue(payment: { pid: number; amount: number }) {
    this._announcementQueue.push(payment);
    this.processAnnouncementQueue();
  }

  /**
   * Processes the announcement queue sequentially.
   */
  private async processAnnouncementQueue() {
    if (this._isAnnouncing || this._announcementQueue.length === 0) {
      return; // Skip if already announcing or queue is empty
    }

    this._isAnnouncing = true;
    const payment = this._announcementQueue.shift(); // Get the next payment from the queue

    if (payment) {
      await this.announceUpdate(payment); // Announce the payment
    }

    this._isAnnouncing = false;

    // Process the next announcement after a short delay
    setTimeout(() => this.processAnnouncementQueue(), 1500); // 1-second delay
  }

  /**
   * Sets the mute state for announcements.
   */
  async setMuteState(isMuted: boolean) {
    try {
      // this._isMuted = isMuted;
      localStorage.setItem('isMuted', JSON.stringify(isMuted));
      console.log(`Announcements ${isMuted ? 'muted' : 'unmuted'}`);
    } catch (error) {
      console.error('Error updating mute state:', error);
    }
  }

  /**
   * Announces a payment using Text-to-Speech.
   */
  async announceUpdate(payment: { pid: number; amount: number }): Promise<void> {
    try {
      const isMuted = JSON.parse(localStorage.getItem('isMuted') || 'false');
      if (!isMuted) {
        console.log('Announcements are muted. Skipping announcement.');
        return;
      }

      // Format the amount with commas (e.g., 10000 -> "10,000")
      const formattedAmount = new Intl.NumberFormat('en-IN').format(payment.amount);

      // Create the announcement message
      const announcementMessage = `${formattedAmount} rupees credited in your  soundbox.`;

      // Use Text-to-Speech to announce the message
      await TextToSpeech.speak({
        text: announcementMessage,
        lang: 'en-US', // You can change this to 'en-IN' for Indian English
        rate: 1.0, // Adjust the speech rate if needed
        pitch: 1.0, // Adjust the pitch if needed
      });

      console.log(`Announced payment: ${announcementMessage}`);
    } catch (error) {
      console.error('Error with Text-to-Speech:', error);
    }
  }

  /**
   * Removes the FCM token from storage.
   */
  async removeFcmToken() {
    try {
      const saved_token = JSON.parse((await this.storage.getStorage('FCM_TOKEN')).value);
      this.storage.removeStorage(saved_token);
    } catch (e) {
      console.log(e);
      throw e;
    }
  }
}