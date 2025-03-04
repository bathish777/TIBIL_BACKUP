import { ComponentFixture, TestBed } from '@angular/core/testing';
import { MpinCreatePage } from './mpin-create.page';
import { ActivatedRoute, Router } from '@angular/router';
import { TranslateService } from '@ngx-translate/core';
import { LocalStorageService } from '../services/local-storage.service';
import { of } from 'rxjs';
import { NgOtpInputComponent } from 'ng-otp-input';
import { FormsModule } from '@angular/forms';
import { IonicModule } from '@ionic/angular';
import { CommonModule } from '@angular/common';

describe('MpinCreatePage', () => {
  let component: MpinCreatePage;
  let fixture: ComponentFixture<MpinCreatePage>;
  let routerSpy: jasmine.SpyObj<Router>;
  let translateSpy: jasmine.SpyObj<TranslateService>;
  let localStorageSpy: jasmine.SpyObj<LocalStorageService>;
  let activatedRouteSpy: jasmine.SpyObj<ActivatedRoute>;

  beforeEach(async () => {
    routerSpy = jasmine.createSpyObj('Router', ['navigate']);
    routerSpy.navigate.and.returnValue(Promise.resolve(true)); // ✅ Ensure it returns a Promise
  
    translateSpy = jasmine.createSpyObj('TranslateService', ['use', 'instant']);
    localStorageSpy = jasmine.createSpyObj('LocalStorageService', ['getItem', 'setItem']);
  
    activatedRouteSpy = jasmine.createSpyObj('ActivatedRoute', [], {
      queryParams: of({ action: 'create' })
    });
  
    await TestBed.configureTestingModule({
      imports: [IonicModule.forRoot(), FormsModule, CommonModule, MpinCreatePage, NgOtpInputComponent],
      declarations: [],
      providers: [
        { provide: Router, useValue: routerSpy },
        { provide: TranslateService, useValue: translateSpy },
        { provide: LocalStorageService, useValue: localStorageSpy },
        { provide: ActivatedRoute, useValue: activatedRouteSpy }
      ]
    }).compileComponents();
  
    fixture = TestBed.createComponent(MpinCreatePage);
    component = fixture.componentInstance;
  
    // Mock NgOtpInputComponent
    component.otpInput = jasmine.createSpyObj('NgOtpInputComponent', ['setValue']);
  });
  

  it('should create the component', () => {
    expect(component).toBeTruthy();
  });

  it('should retrieve action from query params', () => {
    component.ngOnInit();
    expect(component.action).toBe('create');
  });

  it('should set MPIN and navigate on success', () => {
    component.otp = '1234';
    component.isOtpValid = true;

    component.createMpin();

    expect(localStorageSpy.setItem).toHaveBeenCalledWith('createdMpin', '1234');
    expect(component.otpInput.setValue).toHaveBeenCalledWith('');
    expect(routerSpy.navigate).toHaveBeenCalledWith(['/verify-mpin']);
  });

  it('should not set MPIN if invalid', () => {
    component.otp = '12'; // Less than 4 digits
    component.isOtpValid = false;

    component.createMpin();

    expect(localStorageSpy.setItem).not.toHaveBeenCalled();
    expect(routerSpy.navigate).not.toHaveBeenCalled();
    expect(component.errorMessage).toBe(translateSpy.instant('ERROR.INVALID_PIN'));
  });

  it('should change the language', () => {
    component.changeLanguage('fr');
    expect(translateSpy.use).toHaveBeenCalledWith('fr');
  });
});
