/* eslint-disable no-undef */
import { ComponentFixture, TestBed, fakeAsync, tick } from '@angular/core/testing';
import { VerificationPage } from './verification.page';
import { Router, ActivatedRoute } from '@angular/router';
import { of, throwError } from 'rxjs';
import { ApiService } from '../services/api.service';
import { LocalStorageService } from '../services/local-storage.service';
import { BackButtonService } from '../services/back-button.service';
// import { TranslateService } from '@ngx-translate/core';
import { ChangeDetectorRef } from '@angular/core';
import { TranslateModule, TranslateService, TranslatePipe } from '@ngx-translate/core';

describe('VerificationPage', () => {
  let component: VerificationPage;
  let fixture: ComponentFixture<VerificationPage>;
  let mockApiService: jasmine.SpyObj<ApiService>;
  let mockRouter: jasmine.SpyObj<Router>;
  let mockActivatedRoute: ActivatedRoute;
  let mockLocalStorageService: jasmine.SpyObj<LocalStorageService>;
  let mockBackButtonService: jasmine.SpyObj<BackButtonService>;
  let mockTranslateService: jasmine.SpyObj<TranslateService>;
  let mockCdr: jasmine.SpyObj<ChangeDetectorRef>;

  beforeEach(async () => {
    mockApiService = jasmine.createSpyObj('ApiService', ['getOtp', 'updateOtp']);
    mockRouter = jasmine.createSpyObj('Router', ['navigate']);
    mockLocalStorageService = jasmine.createSpyObj('LocalStorageService', ['getItem', 'setItem']);
    mockBackButtonService = jasmine.createSpyObj('BackButtonService', ['disableBackButton', 'enableBackButton']);
    mockTranslateService = jasmine.createSpyObj('TranslateService', ['instant', 'use', 'get']);
    mockCdr = jasmine.createSpyObj('ChangeDetectorRef', ['detectChanges']);
    mockTranslateService.get.and.returnValue(of('translated value'));
    mockTranslateService.instant.and.returnValue('translated value');
  
    mockTranslateService.get = jasmine.createSpy().and.returnValue(of('translated value'));
    mockTranslateService.instant = jasmine.createSpy().and.returnValue('translated value');

    mockActivatedRoute = { queryParams: of({ action: 'forgot-mpin' }) } as any;

    await TestBed.configureTestingModule({
      declarations: [],
      imports: [
        VerificationPage,TranslateModule.forRoot()
      ],
      providers: [
        { provide: ApiService, useValue: mockApiService },
        { provide: Router, useValue: mockRouter },
        { provide: ActivatedRoute, useValue: mockActivatedRoute },
        { provide: LocalStorageService, useValue: mockLocalStorageService },
        { provide: BackButtonService, useValue: mockBackButtonService },
        { provide: TranslateService, useValue: mockTranslateService },
        { provide: ChangeDetectorRef, useValue: mockCdr },
        TranslatePipe,
      ]
    }).compileComponents();

    fixture = TestBed.createComponent(VerificationPage);
    component = fixture.componentInstance;
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });



  it('should prevent default event and do nothing if resend is disabled', () => {
    // Arrange
    const mockEvent = { preventDefault: jasmine.createSpy() } as any;
    component.resendDisabled = true;
  
    // Act
    component.resendOtp(mockEvent);
  
    // Assert
    expect(mockEvent.preventDefault).toHaveBeenCalled();
    expect(mockApiService.getOtp).not.toHaveBeenCalled();
  });
  







  // it('should start resend timer and disable resend button', fakeAsync(() => {
  //   // Arrange
  //   component.resendDisabled = false;
  
  //   // Act
  //   component.startResendTimer();
  //   tick(1000); // Simulate 1 second of timer
  
  //   // Assert
  //   expect(component.resendDisabled).toBeTrue();
  //   expect(component.resendTimer).toBe(29); // Timer should decrement
  
  //   // Simulate timer completion
  //   tick(29000); // Simulate remaining 29 seconds
  //   expect(component.resendDisabled).toBeFalse(); // Timer should re-enable resend
  //   expect(component.resendTimer).toBe(0); // Timer should reset
  //   expect(mockCdr.detectChanges).toHaveBeenCalled(); // Change detection should trigger
  // }));
  
  // it('should not start timer if resend is already disabled', () => {
  //   // Arrange
  //   component.resendDisabled = true;
  
  //   // Act
  //   component.startResendTimer();
  
  //   // Assert
  //   expect(component.resendTimer).toBe(0); // Timer should not start
  // });
  it('should prevent default event and do nothing if resend is disabled', () => {
    // Arrange
    const mockEvent = { preventDefault: jasmine.createSpy() } as any;
    component.resendDisabled = true;
  
    // Act
    component.resendOtp(mockEvent);
  
    // Assert
    expect(mockEvent.preventDefault).toHaveBeenCalled();
    expect(mockApiService.getOtp).not.toHaveBeenCalled();
  });











  

  it('should disable back button on init and enable it on destroy', () => {
    component.ngOnInit();
    expect(mockBackButtonService.disableBackButton).toHaveBeenCalled();

    component.ngOnDestroy();
    expect(mockBackButtonService.enableBackButton).toHaveBeenCalled();
  });

  it('should handle missing mobile number in local storage', () => {
    mockLocalStorageService.getItem.and.returnValue('{}');  // No mobile number
    component.getMobileNumberFromStorage();
    expect(component.errorMessage).toBe(mockTranslateService.instant('OTP_VERIFICATION.NO_VALID_MOBILE'));
  });




  it('should verify OTP successfully and navigate', fakeAsync(() => {
    // Set up test data
    component.otp = '123456';
    component.responseIdentification = '123456';
    component.isOtpValid = true; // Ensure OTP is valid
    component.action = 'forgot-mpin'; // Set the action explicitly
    component.mobile = '1234567890'; // Set the mobile number
  
    // Mock localStorageService to return required values
    mockLocalStorageService.getItem
      .withArgs('deviceId').and.returnValue('deviceId123') // Mock deviceId
      .withArgs('responseIdentification').and.returnValue('123456'); // Mock identification
  
    // Mock ApiService.updateOtp to return a successful response
    mockApiService.updateOtp.and.returnValue(of({ code: 2000, data: {} }));
  
    // Mock the OTP input component
    component.otpInput = { setValue: jasmine.createSpy('setValue') } as any;
  
    // Mock Router.navigate to return a resolved Promise
    mockRouter.navigate.and.returnValue(Promise.resolve(true));
  
    // Call the method
    component.verifyOtp();
    tick(); // Simulate async completion
  
    // Verify navigation
    expect(mockRouter.navigate).toHaveBeenCalledWith(['/create-new-login-pin']);
  
    // Verify OTP input is reset
    expect(component.otpInput.setValue).toHaveBeenCalledWith('');
  
    // Verify localStorageService.setItem is called
    expect(mockLocalStorageService.setItem).toHaveBeenCalledWith('enteredOtp', '123456');
    expect(mockLocalStorageService.setItem).toHaveBeenCalledWith('otpVerificationResponse', JSON.stringify({}));
  
    // Verify ApiService.updateOtp is called with the correct request body
    expect(mockApiService.updateOtp).toHaveBeenCalledWith({
      otp: 123456,
      mobile_number: '1234567890',
      device_id: 'deviceId123',
      identification: '123456',
    });
  }));













  

  it('should handle error when fetching OTP', () => {
    mockApiService.getOtp.and.returnValue(throwError(() => new Error('Error fetching OTP')));
    component.fetchOtp();
    expect(component.errorMessage).toBe(mockTranslateService.instant('OTP_VERIFICATION.ERROR_FETCHING'));
  });

  it('should change the language', () => {
    const language = 'en';
    component.changeLanguage(language);
    expect(mockTranslateService.use).toHaveBeenCalledWith(language);
  });
















  it('should update OTP value and validate it', () => {
    const otpValue = '123456';
    component.onOtpInputChange(otpValue);
    expect(component.otp).toBe(otpValue);
    expect(component.isOtpValid).toBeTrue();
  
    // Test with invalid OTP length
    component.onOtpInputChange('123');
    expect(component.isOtpValid).toBeFalse();
  });


  it('should format time correctly', () => {
    expect(component.formatTime(90)).toBe('1:30');
    expect(component.formatTime(45)).toBe('0:45');
    expect(component.formatTime(5)).toBe('0:05');
  });

  it('should fetch OTP successfully', () => {
    component.mobile = '1234567890';
    mockApiService.getOtp.and.returnValue(of({ code: 2000, data: { identification: '123456' } }));
  
    component.fetchOtp();
    expect(component.responseIdentification).toBe('123456');
    expect(mockLocalStorageService.setItem).toHaveBeenCalledWith('responseIdentification', '123456');
  });it('should handle missing identification during OTP verification', () => {
    component.otp = '123456';
    component.responseIdentification = null;
    component.isOtpValid = true;
    component.mobile = '1234567890';
  
    mockLocalStorageService.getItem
      .withArgs('deviceId').and.returnValue('deviceId123')
      .withArgs('responseIdentification').and.returnValue(null);
  
    component.verifyOtp();
    expect(component.errorMessage).toBe(mockTranslateService.instant('OTP_VERIFICATION.MISSING_DETAILS'));
  });it('should handle invalid OTP length during verification', () => {
  component.otp = '123';
  component.isOtpValid = false;

  component.verifyOtp();
  expect(component.errorMessage).toBe(mockTranslateService.instant('OTP_VERIFICATION.INVALID_OTP'));
});














  // it('should reset OTP fields', () => {
  //   component.otp = '123456';
  //   component.isOtpValid = true;

  //   component.resetOtp();

  //   expect(component.otp).toBe('');
  //   expect(component.isOtpValid).toBeFalse();
  // });

  // it('should handle route query parameter for forgot-mpin action', () => {
  //   mockActivatedRoute.queryParams = of({ action: 'forgot-mpin' });
  //   component.ngOnInit();
  //   expect(component.action).toBe('forgot-mpin');
  //   expect(mockApiService.getOtp).toHaveBeenCalled();
  // });

  // it('should handle missing route query parameter', () => {
  //   mockActivatedRoute.queryParams = of({});
  //   component.ngOnInit();
  //   expect(component.action).toBeNull();
  // });

  // it('should navigate to the correct route on OTP verification', fakeAsync(() => {
  //   component.otp = '123456';
  //   component.responseIdentification = '123456';
  //   mockLocalStorageService.getItem.and.returnValue('deviceId123');
  //   mockApiService.updateOtp.and.returnValue(of({ code: 2000, data: {} }));

  //   component.verifyOtp();
  //   tick();

  //   const expectedRoute = component.action === 'forgot-mpin' ? '/create-new-login-pin' : '/mpin-create';
  //   expect(mockRouter.navigate).toHaveBeenCalledWith([expectedRoute]);
  // }));




















  
  it('should update otp on OTP input change', () => {
    const otpValue = '123456';
    component.onOtpInputChange(otpValue);

    expect(component.otp).toBe(otpValue);
    expect(component.isOtpValid).toBeTrue();  // Because the OTP is 6 digits long
  });

  it('should fetch OTP when mobile number is present', () => {
    mockLocalStorageService.getItem.and.returnValue(JSON.stringify({ mobile_number: '1234567890' }));
    mockApiService.getOtp.and.returnValue(of({ code: 2000, data: { identification: '123456' } }));

    component.getMobileNumberFromStorage();
    component.fetchOtp();

    expect(mockApiService.getOtp).toHaveBeenCalledWith('1234567890');
    expect(component.responseIdentification).toBe('123456');
  });

  it('should handle OTP fetch failure', () => {
    mockApiService.getOtp.and.returnValue(throwError(() => new Error('Fetch Error')));

    component.fetchOtp();

    expect(component.errorMessage).toBe(mockTranslateService.instant('OTP_VERIFICATION.ERROR_FETCHING'));
  });
  // it('should start the resend timer and enable resend button after timeout', fakeAsync(() => {
  //   component.startResendTimer();
    
  //   expect(component.resendDisabled).toBeTrue();
  //   expect(component.resendTimer).toBe(30);
  
  //   tick(30000); // Simulate 30 seconds passing
  //   expect(component.resendDisabled).toBeFalse();
  // }));
  
  it('should format time correctly', () => {
    expect(component.formatTime(65)).toBe('1:05');
    expect(component.formatTime(120)).toBe('2:00');
    expect(component.formatTime(59)).toBe('0:59');
    expect(component.formatTime(0)).toBe('0:00');
  });
  
  // it('should verify OTP successfully and navigate', fakeAsync(() => {
  //   component.otp = '123456';
  //   component.responseIdentification = '123456';
  //   mockLocalStorageService.getItem.and.returnValue('deviceId123');
  //   mockApiService.updateOtp.and.returnValue(of({ code: 2000, data: {} }));

  //   component.verifyOtp();
  //   tick();

  //   expect(mockRouter.navigate).toHaveBeenCalledWith(['/mpin-create']);
  // }));

  it('should handle OTP verification failure', () => {
    component.otp = '123456';
    component.responseIdentification = '123456';
    mockLocalStorageService.getItem.and.returnValue('deviceId123');
    mockApiService.updateOtp.and.returnValue(throwError(() => new Error('Verification Error')));

    component.verifyOtp();

    expect(component.errorMessage).toBe(mockTranslateService.instant('OTP_VERIFICATION.ERROR_VERIFYING'));
  });
  

  // it('should resend OTP and start timer', fakeAsync(() => {
  //   mockApiService.getOtp.and.returnValue(of({ code: 2000 }));
  //   component.resendOtp(new Event('click'));
  //   expect(mockApiService.getOtp).toHaveBeenCalled();
  //   expect(component.resendDisabled).toBeTrue();

  //   tick(30000);
  //   expect(component.resendDisabled).toBeFalse();
  // }));

});
