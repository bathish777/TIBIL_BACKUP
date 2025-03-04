import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { MyQrCodePage } from './my-qr-code.page';
import { Router } from '@angular/router';
import { TranslateService } from '@ngx-translate/core';
import { LocalStorageService } from '../services/local-storage.service';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import {
  IonContent,
  IonText,
  IonButton,
  IonImg,
  IonLabel,
} from '@ionic/angular/standalone';
import { TranslateModule } from '@ngx-translate/core';
import { Share, ShareResult } from '@capacitor/share';
import { Filesystem, Directory, WriteFileResult, GetUriResult } from '@capacitor/filesystem';

describe('MyQrCodePage', () => {
  let component: MyQrCodePage;
  let fixture: ComponentFixture<MyQrCodePage>;
  let routerSpy: jasmine.SpyObj<Router>;
  let translateServiceSpy: jasmine.SpyObj<TranslateService>;
  let localStorageServiceSpy: jasmine.SpyObj<LocalStorageService>;

  beforeEach(waitForAsync(() => {
    routerSpy = jasmine.createSpyObj('Router', ['navigate']);
    translateServiceSpy = jasmine.createSpyObj('TranslateService', ['use']);
    localStorageServiceSpy = jasmine.createSpyObj('LocalStorageService', ['getItem']);

    TestBed.configureTestingModule({
      imports: [
        CommonModule,
        FormsModule,
        TranslateModule,
        IonContent,
        IonText,
        IonButton,
        IonImg,
        IonLabel,
        MyQrCodePage, // Import standalone component
      ],
      providers: [
        { provide: Router, useValue: routerSpy },
        { provide: TranslateService, useValue: translateServiceSpy },
        { provide: LocalStorageService, useValue: localStorageServiceSpy },
      ],
    }).compileComponents();

    fixture = TestBed.createComponent(MyQrCodePage);
    component = fixture.componentInstance;
  }));

  it('should create the QR code page', () => {
    expect(component).toBeTruthy();
  });

  it('should initialize with values from local storage', () => {
    localStorageServiceSpy.getItem.and.callFake((key: string) => {
      if (key === 'base64QrCode') return 'iVBORw0KGgoAAAANSUhEUgA...'; // Fake Base64
      if (key === 'mobileNumber') return '1234567890';
      if (key === 'customerName') return 'John Doe';
      return null;
    });

    component.ngOnInit();

    expect(component.base64QrCode).toContain('data:image/png;base64,');
    expect(component.mobileNumber).toBe('1234567890');
    expect(component.customerName).toBe('John Doe');
  });

  it('should change language', () => {
    component.changeLanguage('fr');
    expect(translateServiceSpy.use).toHaveBeenCalledWith('fr');
  });

  it('should navigate back to settings', () => {
    component.goBack();
    expect(routerSpy.navigate).toHaveBeenCalledWith(['settings']);
  });

  // it('should share QR code successfully', async () => {
  //   spyOn(Share, 'share').and.returnValue(Promise.resolve({} as ShareResult)); // Correct return type

  //   spyOn(Filesystem, 'writeFile').and.returnValue(
  //     Promise.resolve({ uri: 'file:///path/to/qr.png' } as WriteFileResult) // Correct return type
  //   );

  //   spyOn(Filesystem, 'getUri').and.returnValue(
  //     Promise.resolve({ uri: 'file:///path/to/qr.png' } as GetUriResult) // Correct return type
  //   );

  //   component.base64QrCode = 'data:image/png;base64,FAKE_BASE64';
  //   await component.shareQrCode();

  //   expect(Filesystem.writeFile).toHaveBeenCalled();
  //   expect(Filesystem.getUri).toHaveBeenCalled();
  //   expect(Share.share).toHaveBeenCalled();
  // });
  it('should handle QR code sharing error', async () => {
    const consoleErrorSpy = spyOn(console, 'error'); // Properly spy on console.error
    spyOn(Filesystem, 'writeFile').and.returnValue(Promise.reject(new Error('Write error')));
  
    component.base64QrCode = 'data:image/png;base64,FAKE_BASE64';
    await component.shareQrCode();
  
    expect(consoleErrorSpy).toHaveBeenCalled(); // Ensure console.error was called
    expect(consoleErrorSpy).toHaveBeenCalledWith('Error saving file:', jasmine.any(Error)); // Match any error message
  });
  
  

  it('should handle missing QR code on share attempt', async () => {
    spyOn(console, 'error'); // Suppress error logs

    component.base64QrCode = null;
    await component.shareQrCode();

    expect(console.error).toHaveBeenCalledWith('No QR code available to share.');
  });

  it('should dismiss the notification', () => {
    component.dismissNotification();
    expect(component.showNotification).toBeFalse();
  });
});
