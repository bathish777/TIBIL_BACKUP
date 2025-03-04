import { ComponentFixture, TestBed } from '@angular/core/testing';
import { ForgotMpinPage } from './forgot-mpin.page';
import { Router } from '@angular/router';
import { TranslateService, TranslateModule } from '@ngx-translate/core';
import { LocalStorageService } from '../services/local-storage.service';
import { FormsModule } from '@angular/forms';
import { IonicModule } from '@ionic/angular';
import { of } from 'rxjs';
import { CommonModule } from '@angular/common';
import { ActivatedRoute } from '@angular/router';
import { TokenManagerService } from '../services/token-manager.service';
import { BackButtonService } from '../services/back-button.service';

describe('ForgotMpinPage', () => {
  let component: ForgotMpinPage;
  let fixture: ComponentFixture<ForgotMpinPage>;
  let router: jasmine.SpyObj<Router>;
  let translate: jasmine.SpyObj<TranslateService>;
  let localStorageService: jasmine.SpyObj<LocalStorageService>;
  let tokenManagerService: jasmine.SpyObj<TokenManagerService>;
  let backButtonService: jasmine.SpyObj<BackButtonService>;
  let activatedRoute: jasmine.SpyObj<ActivatedRoute>;

  beforeEach(async () => {
    const routerSpy = jasmine.createSpyObj('Router', ['navigate']);
    const translateSpy = jasmine.createSpyObj('TranslateService', ['setDefaultLang', 'use', 'get', 'instant'], {
      onLangChange: of({ lang: 'en' }),
    });
    translateSpy.get.and.returnValue(of('Mocked translation')); // Mock get method for translation
    const localStorageSpy = jasmine.createSpyObj('LocalStorageService', ['getItem', 'setItem']);
    const tokenManagerSpy = jasmine.createSpyObj('TokenManagerService', ['setAccessToken', 'clearGuestToken']);
    const backButtonSpy = jasmine.createSpyObj('BackButtonService', ['disableBackButton', 'enableBackButton']);
    const activatedRouteSpy = jasmine.createSpyObj('ActivatedRoute', ['queryParams'], {
      queryParams: of({ source: 'createdMpin' }),
    });

    await TestBed.configureTestingModule({
      imports: [IonicModule.forRoot(), FormsModule, CommonModule, TranslateModule.forRoot()],
      providers: [
        { provide: Router, useValue: routerSpy },
        { provide: TranslateService, useValue: translateSpy },
        { provide: LocalStorageService, useValue: localStorageSpy },
        { provide: TokenManagerService, useValue: tokenManagerSpy },
        { provide: BackButtonService, useValue: backButtonSpy },
        { provide: ActivatedRoute, useValue: activatedRouteSpy },
      ],
    }).compileComponents();

    fixture = TestBed.createComponent(ForgotMpinPage);
    component = fixture.componentInstance;
    router = TestBed.inject(Router) as jasmine.SpyObj<Router>;
    translate = TestBed.inject(TranslateService) as jasmine.SpyObj<TranslateService>;
    localStorageService = TestBed.inject(LocalStorageService) as jasmine.SpyObj<LocalStorageService>;
    tokenManagerService = TestBed.inject(TokenManagerService) as jasmine.SpyObj<TokenManagerService>;
    backButtonService = TestBed.inject(BackButtonService) as jasmine.SpyObj<BackButtonService>;
    activatedRoute = TestBed.inject(ActivatedRoute) as jasmine.SpyObj<ActivatedRoute>;

    // Ensure the component is initialized with a default value for expectedPin
    component.expectedPin = '1234';
  });

  it('should create the component', () => {
    expect(component).toBeTruthy();
  });

  // it('should fetch stored MPIN on init', () => {
  //   localStorageService.getItem.and.returnValue('1234'); // Mock the correct key
  //   component.ngOnInit();
  //   expect(localStorageService.getItem).toHaveBeenCalledWith('createdMpin'); // Ensure the correct key is used
  //   expect(backButtonService.disableBackButton).toHaveBeenCalled(); // Ensure back button is disabled
  // });

  // it('should verify MPIN correctly', () => {
  //   // Mock the OTP and expectedPin
  //   component.otp = '1234';
  //   component.expectedPin = '1234';
  
  //   // Mock localStorage.getItem to return the expectedPin
  //   localStorageService.getItem.and.returnValue('1234');
  
  //   // Mock tokenManagerService methods
  //   tokenManagerService.setAccessToken.and.returnValue();
  //   tokenManagerService.clearGuestToken.and.returnValue();
  
  //   // Mock router.navigate to return a resolved Promise
  //   router.navigate.and.returnValue(Promise.resolve(true));
  
  //   // Call the method
  //   component.verifyMpin();
  
  //   // Verify the results
  //   expect(component.errorMessage).toBe(''); // Ensure no error message on correct MPIN
  //   expect(tokenManagerService.setAccessToken).toHaveBeenCalledWith(jasmine.any(String)); // Ensure access token is set
  //   expect(tokenManagerService.clearGuestToken).toHaveBeenCalled(); // Check if guest token is cleared
  //   expect(router.navigate).toHaveBeenCalledWith(['/qr-view']); // Check navigation after successful verification
  // });

  it('should set error message on incorrect MPIN', () => {
    component.otp = '0000';
    component.expectedPin = '1234';
    translate.instant.and.returnValue('Invalid MPIN. Please try again.');
    component.verifyMpin();
    expect(component.errorMessage).toBe('Invalid MPIN. Please try again.'); // Check if error message is set
  });

  it('should change the language', () => {
    component.changeLanguage('fr');
    expect(translate.use).toHaveBeenCalledWith('fr'); // Ensure language change works
  });

  it('should navigate to verification page', () => {
    component.navigateToVerification();
    expect(router.navigate).toHaveBeenCalledWith(['/verification'], { queryParams: { action: 'forgot-login-pin' } });
  });

  // it('should retrieve stored mobile number and customerVpa', () => {
  //   localStorageService.getItem.withArgs('userDevices').and.returnValue(JSON.stringify({ mobile_number: '1234' }));
  //   localStorageService.getItem.withArgs('customerVpa').and.returnValue('testVpa');
  //   component.retrieveStoredData();
  //   expect(localStorageService.getItem).toHaveBeenCalledWith('userDevices');
  //   expect(component.mobileNumber).toBe('1234');
  //   expect(component.customerVpa).toBe('testVpa');
  // });

  it('should initialize OTP input field on change', () => {
    component.onOtpInputChange('1234');
    expect(component.otp).toBe('1234');
  });

  it('should call changeLanguage and change language to "fr"', () => {
    component.changeLanguage('fr');
    expect(translate.use).toHaveBeenCalledWith('fr');
  });

  it('should navigate to the forgot MPIN page on navigateToVerification', () => {
    component.navigateToVerification();
    expect(router.navigate).toHaveBeenCalledWith(['/verification'], { queryParams: { action: 'forgot-login-pin' } });
  });

  it('should enable back button on destroy', () => {
    component.ngOnDestroy();
    expect(backButtonService.enableBackButton).toHaveBeenCalled(); // Ensure back button is enabled
  });

  // it('should handle missing mobile number and customerVpa in retrieveStoredData', () => {
  //   localStorageService.getItem.withArgs('userDevices').and.returnValue(null);
  //   localStorageService.getItem.withArgs('customerVpa').and.returnValue(null);
  //   component.retrieveStoredData();
  //   expect(component.mobileNumber).toBe('');
  //   expect(component.customerVpa).toBe('');
  // });

  it('should handle missing expectedPin in verifyMpin', () => {
    component.otp = '1234';
    component.expectedPin = '';
    translate.instant.and.returnValue('Invalid MPIN. Please try again.');
    component.verifyMpin();
    expect(component.errorMessage).toBe('Invalid MPIN. Please try again.');
  });

  // it('should handle missing OTP in verifyMpin', () => {
  //   component.otp = '';
  //   component.expectedPin = '1234';
  //   translate.instant.and.returnValue('Invalid MPIN. Please try again.');
  //   component.verifyMpin();
  //   expect(component.errorMessage).toBe('Invalid MPIN. Please try again.');
  // });
});