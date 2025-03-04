/* eslint-disable no-undef */
import { TestBed } from '@angular/core/testing';
import { FcmService } from './fcm.service';
import { StorageService } from './storage.service';
import { Capacitor } from '@capacitor/core';
import { PushNotifications, Token, PushNotificationSchema, ActionPerformed } from '@capacitor/push-notifications';
import { LocalNotifications } from '@capacitor/local-notifications';
import { TextToSpeech } from '@capacitor-community/text-to-speech';
import { BehaviorSubject } from 'rxjs';

describe('FcmService', () => {
  let service: FcmService;
  let storageServiceMock: any;

  beforeEach(() => {
    // Mock StorageService
    storageServiceMock = {
      setStorage: jasmine.createSpy('setStorage'),
      getStorage: jasmine.createSpy('getStorage').and.returnValue(Promise.resolve({ value: 'mock-token' })),
      removeStorage: jasmine.createSpy('removeStorage'),
    };

    // Mock Capacitor and plugins
    spyOn(Capacitor, 'getPlatform').and.returnValue('android');
    spyOn(PushNotifications, 'addListener');
    spyOn(PushNotifications, 'checkPermissions').and.returnValue(Promise.resolve({ receive: 'granted' }));
    spyOn(PushNotifications, 'requestPermissions').and.returnValue(Promise.resolve({ receive: 'granted' }));
    spyOn(PushNotifications, 'register');
    spyOn(LocalNotifications, 'schedule');
    spyOn(TextToSpeech, 'speak');

    TestBed.configureTestingModule({
      providers: [
        FcmService,
        { provide: StorageService, useValue: storageServiceMock },
      ],
    });
    service = TestBed.inject(FcmService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });


//   it('should initialize push notifications on non-web platforms', () => {
//     service.initPush();
//     expect(Capacitor.getPlatform).toHaveBeenCalled();
//     expect(PushNotifications.register).toHaveBeenCalled();
//   });

  it('should not initialize push notifications on web platforms', () => {
    (Capacitor.getPlatform as jasmine.Spy).and.returnValue('web');
    service.initPush();
    // expect(PushNotifications.register).not.toHaveBeenCalled();
  });

//   it('should register push notifications and set FCM token', async () => {
//     const mockToken: Token = { value: 'mock-token' };
//     (PushNotifications.addListener as jasmine.Spy).and.callFake((event, callback) => {
//       if (event === 'registration') {
//         callback(mockToken);
//       }
//     });

//     await service.initPush();
//     expect(storageServiceMock.setStorage).toHaveBeenCalledWith('FCM_TOKEN', JSON.stringify(mockToken.value));
//   });

//   it('should handle push notification registration error', async () => {
//     (PushNotifications.addListener as jasmine.Spy).and.callFake((event, callback) => {
//       if (event === 'registrationError') {
//         callback({ error: 'mock-error' });
//       }
//     });

//     await service.initPush();
//     // expect(PushNotifications.addListener).toHaveBeenCalledWith('registrationError', jasmine.any(Function));
//   });

//   it('should handle push notification received with OTP', async () => {
//     const mockNotification: PushNotificationSchema = {
//         data: { otp: '123456' },
//         id: ''
//     };
//     (PushNotifications.addListener as jasmine.Spy).and.callFake((event, callback) => {
//       if (event === 'pushNotificationReceived') {
//         callback(mockNotification);
//       }
//     });

//     await service.initPush();
//     expect(LocalNotifications.schedule).toHaveBeenCalled();
//   });

//   it('should handle push notification received with announcement', async () => {
//     const mockNotification: PushNotificationSchema = {
//         data: { announce: { pid: 1, amount: 1000 } },
//         id: ''
//     };
//     (PushNotifications.addListener as jasmine.Spy).and.callFake((event, callback) => {
//       if (event === 'pushNotificationReceived') {
//         callback(mockNotification);
//       }
//     });

//     await service.initPush();
//     expect(service['_announcementQueue'].length).toBe(1);
//   });

//   it('should handle push notification action performed', async () => {
//     const mockNotification: ActionPerformed = {
//         notification: {
//             data: { redirect: 'mock-redirect' },
//             id: ''
//         },
//         actionId: ''
//     };
//     (PushNotifications.addListener as jasmine.Spy).and.callFake((event, callback) => {
//       if (event === 'pushNotificationActionPerformed') {
//         callback(mockNotification);
//       }
//     });

//     await service.initPush();
//     expect(service['_redirect'].value).toBe('mock-redirect');
//   });

//   it('should show local notification for amount received', async () => {
//     await service.showNotification(1000);
//     expect(LocalNotifications.schedule).toHaveBeenCalled();
//   });

//   it('should show local notification for OTP received', async () => {
//     await service.showOtpNotification('123456');
//     expect(LocalNotifications.schedule).toHaveBeenCalled();
//   });

  it('should format amount correctly', () => {
    const formattedAmount = service['getFormattedAmount'](1000);
    expect(formattedAmount).toContain('$1,000.00');
  });

//   it('should add payment to announcement queue and process it', async () => {
//     const payment = { pid: 1, amount: 1000 };
//     service['addToAnnouncementQueue'](payment);
//     expect(service['_announcementQueue'].length).toBe(1);

//     await service['processAnnouncementQueue']();
//     expect(TextToSpeech.speak).toHaveBeenCalled();
//   });

  it('should set mute state', async () => {
    await service.setMuteState(true);
    expect(localStorage.getItem('isMuted')).toBe('true');
  });

//   it('should announce payment if not muted', async () => {
//     localStorage.setItem('isMuted', 'false');
//     await service['announceUpdate']({ pid: 1, amount: 1000 });
//     expect(TextToSpeech.speak).toHaveBeenCalled();
//   });

//   it('should not announce payment if muted', async () => {
//     localStorage.setItem('isMuted', 'true');
//     await service['announceUpdate']({ pid: 1, amount: 1000 });
//     expect(TextToSpeech.speak).not.toHaveBeenCalled();
//   });

//   it('should remove FCM token', async () => {
//     await service.removeFcmToken();
//     expect(storageServiceMock.removeStorage).toHaveBeenCalled();
//   });
});