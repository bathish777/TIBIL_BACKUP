import { ComponentFixture, TestBed } from '@angular/core/testing';
import { ProfilePage } from './my-profile.page';
import { TranslateService } from '@ngx-translate/core';
import { Router } from '@angular/router';
import { LocalStorageService } from '../services/local-storage.service';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { TranslateModule } from '@ngx-translate/core';
import {
  IonContent,
  IonLabel,
  IonRow,
} from '@ionic/angular/standalone';

describe('ProfilePage', () => {
  let component: ProfilePage;
  let fixture: ComponentFixture<ProfilePage>;
  let routerSpy: jasmine.SpyObj<Router>;
  let translateServiceSpy: jasmine.SpyObj<TranslateService>;
  let localStorageServiceSpy: jasmine.SpyObj<LocalStorageService>;

  beforeEach(async () => {
    routerSpy = jasmine.createSpyObj('Router', ['navigate']);
    translateServiceSpy = jasmine.createSpyObj('TranslateService', ['use']);
    localStorageServiceSpy = jasmine.createSpyObj('LocalStorageService', ['getItem']);

    await TestBed.configureTestingModule({
      imports: [
        CommonModule,
        FormsModule,
        TranslateModule,
        IonContent,
        IonLabel,
        IonRow,
        ProfilePage, // Import standalone component
      ],
      providers: [
        { provide: Router, useValue: routerSpy },
        { provide: TranslateService, useValue: translateServiceSpy },
        { provide: LocalStorageService, useValue: localStorageServiceSpy },
      ],
    }).compileComponents();

    fixture = TestBed.createComponent(ProfilePage);
    component = fixture.componentInstance;
  });

  it('should create the profile page', () => {
    expect(component).toBeTruthy();
  });

  it('should initialize with values from local storage', () => {
    localStorageServiceSpy.getItem.and.callFake((key: string) => {
      if (key === 'customerName') return 'John Doe';
      if (key === 'userDevices') return JSON.stringify({ mobile_number: '1234567890' });
      return null;
    });

    component.ngOnInit();

    expect(component.customerName).toBe('John Doe');
    expect(component.userPhoneNumber).toBe('1234567890');
  });

  it('should handle missing or invalid local storage data gracefully', () => {
    localStorageServiceSpy.getItem.and.returnValue(null);

    component.ngOnInit();

    expect(component.customerName).toBeNull();
    expect(component.userPhoneNumber).toBeNull();
  });

  it('should change language', () => {
    component.changeLanguage('fr');
    expect(translateServiceSpy.use).toHaveBeenCalledWith('fr');
  });

  it('should navigate back to settings', () => {
    component.goBack();
    expect(routerSpy.navigate).toHaveBeenCalledWith(['settings']);
  });

  it('should update header when selecting a tab', () => {
    component.selectTab('dashboard');
    expect(component.currentHeader).toBe('Dashboard');

    component.selectTab('transactions');
    expect(component.currentHeader).toBe('Transactions');

    component.selectTab('settings');
    expect(component.currentHeader).toBe('Settings');

    component.selectTab('my-profile');
    expect(component.currentHeader).toBe(' < My Profile');
  });

  it('should navigate to QR view', () => {
    component.navigateTo();
    expect(routerSpy.navigate).toHaveBeenCalledWith(['/qr-view']);
  });

  it('should dismiss the notification', () => {
    component.dismissNotification();
    expect(component.showNotification).toBeFalse();
  });
});
