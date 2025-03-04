/* eslint-disable no-undef */
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';
import { TranslateModule } from '@ngx-translate/core';
import { NgOtpInputModule } from 'ng-otp-input';
import { CreateNewLoginPage } from './create-new-login-pin.page';
import { LocalStorageService } from '../services/local-storage.service';
import { Router } from '@angular/router';

describe('CreateNewLoginPage', () => {
  let component: CreateNewLoginPage;
  let fixture: ComponentFixture<CreateNewLoginPage>;
  let mockLocalStorageService: any;
  let mockRouter: any;

  beforeEach(async () => {
    mockLocalStorageService = {
      getItem: jasmine.createSpy('getItem').and.returnValue(''),
      setItem: jasmine.createSpy('setItem')
    };

    mockRouter = {
      navigate: jasmine.createSpy('navigate')
    };

    await TestBed.configureTestingModule({
      imports: [
        CreateNewLoginPage, 
        TranslateModule.forRoot(), 
        NgOtpInputModule, 
        IonicModule.forRoot()
      ],
      providers: [
        { provide: LocalStorageService, useValue: mockLocalStorageService },
        { provide: Router, useValue: mockRouter }
      ]
    }).compileComponents();

    fixture = TestBed.createComponent(CreateNewLoginPage);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create the component', () => {
    expect(component).toBeTruthy();
  });

  it('should initialize newLoginPin from local storage', () => {
    expect(mockLocalStorageService.getItem).toHaveBeenCalledWith('newLoginPin');
  });

  it('should update OTP when input changes', () => {
    component.onOtpInputChange('1234');
    expect(component.otp).toBe('1234');
  });

  it('should save new PIN and navigate when valid OTP is entered', () => {
    component.otp = '1234';
    component.createNewPin();
    expect(mockLocalStorageService.setItem).toHaveBeenCalledWith('newLoginPin', '1234');
    expect(mockRouter.navigate).toHaveBeenCalledWith(['/verify-new-login-pin']);
  });

  it('should show error when OTP is invalid', () => {
    component.otp = '12';
    component.createNewPin();
    // eslint-disable-next-line no-undef
    expect(component.errorMessage).toBe('Please enter a valid 4-digit PIN.');
  });
});
