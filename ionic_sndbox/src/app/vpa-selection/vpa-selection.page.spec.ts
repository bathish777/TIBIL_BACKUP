import { TestBed, ComponentFixture } from '@angular/core/testing';
import { VpaSelectionPage } from './vpa-selection.page';
import { ApiService } from '../services/api.service';
import { Router } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { TranslateModule, TranslateService, TranslateStore } from '@ngx-translate/core';
import { of, throwError } from 'rxjs';
import { LocalStorageService } from '../services/local-storage.service';
import { IonicModule } from '@ionic/angular';

describe('VpaSelectionPage', () => {
  let component: VpaSelectionPage;
  let fixture: ComponentFixture<VpaSelectionPage>;
  let apiServiceSpy: jasmine.SpyObj<ApiService>;
  let routerSpy: jasmine.SpyObj<Router>;
  let localStorageServiceSpy: jasmine.SpyObj<LocalStorageService>;

  beforeEach(async () => {
    // Create spy objects
    apiServiceSpy = jasmine.createSpyObj('ApiService', ['getUpiQrCode']);
    routerSpy = jasmine.createSpyObj('Router', ['navigate']);
    localStorageServiceSpy = jasmine.createSpyObj('LocalStorageService', ['getItem', 'setItem']);

    await TestBed.configureTestingModule({
      imports: [IonicModule.forRoot(), FormsModule, TranslateModule.forRoot(), VpaSelectionPage],
      providers: [
        { provide: ApiService, useValue: apiServiceSpy },
        { provide: LocalStorageService, useValue: localStorageServiceSpy },
        { provide: Router, useValue: routerSpy },
        TranslateService,
        TranslateStore, // ✅ Required to resolve TranslateService dependency
      ],
    }).compileComponents();

    // Component creation inside `beforeEach`
    fixture = TestBed.createComponent(VpaSelectionPage);
    component = fixture.componentInstance;
  });
  it('should set selected VPA and store details in local storage', () => {
    // Arrange
    const mockVpaId = 'johndoe@upi';
    const mockVpaName = 'John Doe';
    component.vpas = [
      { id: 'johndoe@upi', name: 'John Doe' },
      { id: 'janedoe@upi', name: 'Jane Doe' },
    ];
  
    // Act
    component.onVpaSelected(mockVpaId);
  
    // Assert
    expect(component.selectedVpaId).toBe(mockVpaId);
    expect(localStorageServiceSpy.setItem).toHaveBeenCalledWith('customerVpa', mockVpaId);
    expect(localStorageServiceSpy.setItem).toHaveBeenCalledWith('customerName', mockVpaName);
  });

  it('should create the component', () => {
    expect(component).toBeTruthy();
  });

  it('should fetch and set customer data on successful API response', async () => {
    const mockResponse = {
      code: 2000,
      data: [
        {
          customer_name: 'John Doe',
          customer_vpa: 'johndoe@upi',
          base64Qrcode: 'mockBase64QrCode',
        },
      ],
    };

    apiServiceSpy.getUpiQrCode.and.returnValue(of(mockResponse));
    localStorageServiceSpy.setItem.and.callFake(() => {}); // Mock setItem

    component.mobile = '1234567890';
    await component.ngOnInit();

    expect(apiServiceSpy.getUpiQrCode).toHaveBeenCalledWith('1234567890');
    expect(component.customerName).toBe('John Doe');
    expect(component.customerVpa).toBe('johndoe@upi');
    expect(localStorageServiceSpy.setItem).toHaveBeenCalledWith('base64QrCode', jasmine.any(String));
  });

  it('should handle API errors gracefully', async () => {
    apiServiceSpy.getUpiQrCode.and.returnValue(throwError(() => new Error('API error')));

    component.mobile = '1234567890';
    await component.ngOnInit();

    expect(component.errorMessage).toBe('Error fetching UPI QR code. Please try again.');
  });

  it('should navigate to the verification page when VPA is selected', () => {
    component.selectedVpaId = 'johndoe@upi';
    component.navigateToVerification();

    expect(routerSpy.navigate).toHaveBeenCalledWith(['/verification'], {
      queryParams: { vpaId: 'johndoe@upi' },
    });
  });
  

  it('should show an error if no VPA is selected', () => {
    component.selectedVpaId = null;
    component.navigateToVerification();

    expect(component.errorMessage).toBe('Please select a VPA before proceeding.');
    expect(routerSpy.navigate).not.toHaveBeenCalled();
  });

  it('should retrieve and set stored QR code from local storage', async () => {
    localStorageServiceSpy.getItem.and.returnValue('mockBase64QrCodeData');
    await component.ngOnInit();
    expect(component.base64QrCode).toBe('mockBase64QrCodeData');
  });

  it('should log error if QR code is not found in local storage', async () => {
    spyOn(console, 'error');
    localStorageServiceSpy.getItem.and.returnValue(null);
    await component.ngOnInit();
    expect(console.error).toHaveBeenCalledWith('QR code not found in localStorage.');
  });

  it('should change language using translate service', () => {
    spyOn(component.translate, 'use');
    component.changeLanguage('fr');
    expect(component.translate.use).toHaveBeenCalledWith('fr');
  });
});
