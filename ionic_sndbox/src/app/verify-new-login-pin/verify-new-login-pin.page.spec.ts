import { ComponentFixture, TestBed } from '@angular/core/testing';
import { VerifyNewLoginPage } from './verify-new-login-pin.page';
import { ActivatedRoute, Router } from '@angular/router';
import { TranslateService, TranslateModule } from '@ngx-translate/core';
import { LocalStorageService } from '../services/local-storage.service';
import { NgOtpInputComponent } from 'ng-otp-input';
import { of } from 'rxjs';
import { FormsModule } from '@angular/forms';
import { BackButtonService } from '../services/back-button.service';

describe('VerifyNewLoginPage', () => {
  let component: VerifyNewLoginPage;
  let fixture: ComponentFixture<VerifyNewLoginPage>;
  let routerSpy: jasmine.SpyObj<Router>;
  let localStorageSpy: jasmine.SpyObj<LocalStorageService>;
  let translateSpy: jasmine.SpyObj<TranslateService>;
  let backButtonServiceSpy: jasmine.SpyObj<BackButtonService>;

  beforeEach(async () => {
    routerSpy = jasmine.createSpyObj('Router', ['navigate']);
    localStorageSpy = jasmine.createSpyObj('LocalStorageService', ['getItem', 'setItem', 'removeItem']);
    translateSpy = jasmine.createSpyObj('TranslateService', ['use', 'get', 'stream']);
    backButtonServiceSpy = jasmine.createSpyObj('BackButtonService', ['enableBackButton', 'disableBackButton']);

    translateSpy.get.and.returnValue(of(''));
    translateSpy.stream.and.returnValue(of(''));

    await TestBed.configureTestingModule({
      imports: [
        VerifyNewLoginPage, // Import standalone component
        TranslateModule.forRoot(),
        FormsModule,
      ],
      providers: [
        { provide: Router, useValue: routerSpy },
        { provide: ActivatedRoute, useValue: { queryParams: of({ isUpdating: 'true' }) } },
        { provide: TranslateService, useValue: translateSpy },
        { provide: LocalStorageService, useValue: localStorageSpy },
        { provide: BackButtonService, useValue: backButtonServiceSpy },
      ],
    }).compileComponents();

    fixture = TestBed.createComponent(VerifyNewLoginPage);
    component = fixture.componentInstance;
  });

  it('should create the component', () => {
    expect(component).toBeTruthy();
  });

  it('should retrieve stored PINs on initialization', () => {
    localStorageSpy.getItem.and.callFake((key: string) => {
      if (key === 'newLoginPin') return '1234';
      if (key === 'createdMpin') return '5678';
      return '';
    });

    component.ngOnInit();
    expect(component.storedPin).toBe('1234');
    expect(component.createdMpin).toBe('5678');
    expect(backButtonServiceSpy.enableBackButton).toHaveBeenCalled();
  });

  it('should update OTP when input changes', () => {
    component.onOtpInputChange('1234');
    expect(component.otp).toBe('1234');
  });

  it('should navigate to forgot-mpin page on successful PIN verification (update mode)', () => {
    component.isUpdating = true;
    component.createdMpin = '5678';
    component.otp = '5678';
    localStorageSpy.getItem.and.returnValue('token123');

    component.verifyLoginPin();

    expect(localStorageSpy.setItem).toHaveBeenCalledWith('createdMpin', '5678');
    expect(localStorageSpy.removeItem).toHaveBeenCalledWith('newLoginPin');
    expect(localStorage.setItem).toHaveBeenCalledWith('access_token', 'token123');
    expect(backButtonServiceSpy.disableBackButton).toHaveBeenCalled();
    expect(routerSpy.navigate).toHaveBeenCalledWith(['/forgot-mpin'], {
      queryParams: { source: 'createdMpin' },
    });
  });

  it('should navigate to forgot-mpin page on successful PIN verification (new PIN mode)', () => {
    component.isUpdating = false;
    component.storedPin = '1234';
    component.otp = '1234';
    localStorageSpy.getItem.and.returnValue('token123');

    component.verifyLoginPin();

    expect(localStorageSpy.setItem).toHaveBeenCalledWith('createdMpin', '1234');
    expect(localStorageSpy.removeItem).toHaveBeenCalledWith('newLoginPin');
    expect(localStorage.setItem).toHaveBeenCalledWith('access_token', 'token123');
    expect(backButtonServiceSpy.disableBackButton).toHaveBeenCalled();
    expect(routerSpy.navigate).toHaveBeenCalledWith(['/forgot-mpin'], {
      queryParams: { source: 'newLoginPin' },
    });
  });

  it('should show error for incorrect PIN', () => {
    component.storedPin = '1234';
    component.otp = '5678';
    component.verifyLoginPin();
    expect(component.errorMessage).toBe('The entered PIN does not match. Please try again.');
  });

  it('should show error for incomplete PIN', () => {
    component.otp = '12';
    component.verifyLoginPin();
    expect(component.errorMessage).toBe('Please re-enter a valid 4-digit PIN.');
  });

  it('should disable back button on component destruction', () => {
    component.ngOnDestroy();
    expect(backButtonServiceSpy.disableBackButton).toHaveBeenCalled();
  });
});