/* eslint-disable no-import-assign */
/* eslint-disable @typescript-eslint/no-unused-vars */
/* eslint-disable no-undef */
import { ComponentFixture, TestBed, fakeAsync, tick } from '@angular/core/testing';
import { HomePage } from './home.page';
import { ApiService } from '../services/api.service';
import { LoaderPagePage } from '../loader-page/loader-page.page';
import { LocalStorageService } from '../services/local-storage.service';
import { TranslateService, TranslateModule } from '@ngx-translate/core';
import { Platform } from '@ionic/angular';
import { Router } from '@angular/router';
import { ChangeDetectorRef } from '@angular/core';
import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';
import { of, throwError } from 'rxjs';
import { HttpClientModule } from '@angular/common/http';

import { FormsModule } from '@angular/forms';
// import { HttpClientTestingModule } from '@angular/common/http/testing';
import { CommonModule } from '@angular/common';


describe('HomePage', () => {
  let component: HomePage;
  let fixture: ComponentFixture<HomePage>;
  let apiService: jasmine.SpyObj<ApiService>;
  let loaderPage: jasmine.SpyObj<LoaderPagePage>;
  let storageService: jasmine.SpyObj<LocalStorageService>;
  let translateService: TranslateService;
  let platform: jasmine.SpyObj<Platform>;
  let router: jasmine.SpyObj<Router>;
  let cdr: jasmine.SpyObj<ChangeDetectorRef>;

  beforeEach(async () => {
    
    const apiServiceSpy = jasmine.createSpyObj('ApiService', ['getUserDevices', 'getTermsAndConditions']);
    const loaderPageSpy = jasmine.createSpyObj('LoaderPagePage', ['show', 'hide']);
    const storageServiceSpy = jasmine.createSpyObj('LocalStorageService', ['getItem', 'setItem']);
    const platformSpy = jasmine.createSpyObj('Platform', ['is', 'backButton']);
    const routerSpy = jasmine.createSpyObj('Router', ['navigate']);
    const cdrSpy = jasmine.createSpyObj('ChangeDetectorRef', ['detectChanges']);

    await TestBed.configureTestingModule({
      imports: [HttpClientModule, FormsModule, CommonModule, TranslateModule.forRoot(),HomePage,HttpClientTestingModule],
      declarations: [],
      providers: [
        { provide: ApiService, useValue: apiServiceSpy },
        { provide: ApiService, useValue: apiServiceSpy },
        { provide: LoaderPagePage, useValue: loaderPageSpy },
        { provide: LocalStorageService, useValue: storageServiceSpy },
        { provide: TranslateService, useClass: TranslateService },
        { provide: Platform, useValue: platformSpy },
        { provide: Router, useValue: routerSpy },
        { provide: ChangeDetectorRef, useValue: cdrSpy },
      ],
    }).compileComponents();

    fixture = TestBed.createComponent(HomePage);
   
    component = fixture.componentInstance;
    apiService = TestBed.inject(ApiService) as jasmine.SpyObj<ApiService>;
    apiService = TestBed.inject(ApiService) as jasmine.SpyObj<ApiService>;
    loaderPage = TestBed.inject(LoaderPagePage) as jasmine.SpyObj<LoaderPagePage>;
    storageService = TestBed.inject(LocalStorageService) as jasmine.SpyObj<LocalStorageService>;
    translateService = TestBed.inject(TranslateService) as unknown as TranslateService;
    platform = TestBed.inject(Platform) as jasmine.SpyObj<Platform>;
    router = TestBed.inject(Router) as jasmine.SpyObj<Router>;
    cdr = TestBed.inject(ChangeDetectorRef) as jasmine.SpyObj<ChangeDetectorRef>;

    // Mock platform backButton
    platform.backButton = of() as any;
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
  it('should handle sendSMS failure', async () => {
    component.selectedSim = { carrierName: 'Carrier', simSlotIndex: 1, subscriptionId: 1 };
    (component as any).SimBind = { sendSMS: () => Promise.reject('Error') };
    const result = await component.sendSMSToVmnList([{ vmn_number: '123', is_primary: true }]);
    expect(result).toBeFalse();
  });
  it('should handle onNextClick with mobile number fetch failure', fakeAsync(() => {
    // Spy on the alert function
    spyOn(window, 'alert');
  
    // Set up component state
    component.isSimSelected = true;
    component.selectedSim = { carrierName: 'Carrier', simSlotIndex: 1, subscriptionId: 1 };
  
    // Mock dependencies
    storageService.getItem.and.returnValue([{ vmn_number: '123', is_primary: true }]);
    spyOn(component, 'sendSMSToVmnList').and.returnValue(Promise.resolve(true));
    spyOn(component, 'fetchMobileNumberWithRetries').and.returnValue(Promise.resolve(false));
  
    // Trigger the method
    component.onNextClick();
    tick(); // Simulate the passage of time for async operations
  
    // Verify the results
    expect(component.isLoader).toBeFalse();
    expect(window.alert).toHaveBeenCalledWith(translateService.instant('ERROR.MOBILE_FETCH'));
  }));
  it('should change language', () => {
    spyOn(translateService, 'use');
    component.changeLanguage('es');
    expect(translateService.use).toHaveBeenCalledWith('es');
  });
  it('should handle onNextClick with no SIM selected', async () => {
    // Spy on the alert function
    spyOn(window, 'alert');
  
    // Set up component state
    component.isSimSelected = false;
  
    // Trigger the method
    await component.onNextClick();
  
    // Verify the results
    expect(component.isLoader).toBeFalse();
    expect(window.alert).toHaveBeenCalledWith(translateService.instant('ERROR.SELECT_SIM'));
  });
  it('should fetch mobile number with retries', fakeAsync(() => {
    spyOn(component, 'fetchMobileNumberFromAPI').and.returnValues(Promise.resolve(false), Promise.resolve(true));
    component.fetchMobileNumberWithRetries(2, 1000).then((result) => {
      expect(result).toBeTrue();
    });
    tick(2000);
  }));
  it('should get active VMN numbers', () => {
    const vmnList = [{ vmn_number: '123', is_primary: true }, { vmn_number: '456', is_primary: false }];
    const result = component.getActiveVmnNumbers(vmnList);
    expect(result).toEqual(['123']);
  });
  it('should handle web platform on getSimInfo', async () => {
    platform.is.and.returnValue(false);
    await component.getSimInfo();
    expect(component.errorMessage).toEqual(translateService.instant('ERROR.SIM_INFO'));
  });
  it('should handle onNextClick with SMS send failure', fakeAsync(() => {
    // Spy on the alert function
    spyOn(window, 'alert');
  
    // Set up component state
    component.isSimSelected = true;
    component.selectedSim = { carrierName: 'Carrier', simSlotIndex: 1, subscriptionId: 1 };
  
    // Mock dependencies
    storageService.getItem.and.returnValue([{ vmn_number: '123', is_primary: true }]);
    spyOn(component, 'sendSMSToVmnList').and.returnValue(Promise.resolve(false));
  
    // Trigger the method
    component.onNextClick();
    tick(); // Simulate the passage of time for async operations
  
    // Verify the results
    expect(component.isLoader).toBeFalse();
    expect(window.alert).toHaveBeenCalledWith(translateService.instant('ERROR.SMS_SEND'));
  }));
  
  it('should handle onNextClick with SIM selected', fakeAsync(() => {
    component.isSimSelected = true;
    component.selectedSim = { carrierName: 'Carrier', simSlotIndex: 1, subscriptionId: 1 };
    storageService.getItem.and.returnValue([{ vmn_number: '123', is_primary: true }]);
    spyOn(component, 'sendSMSToVmnList').and.returnValue(Promise.resolve(true));
    spyOn(component, 'fetchMobileNumberWithRetries').and.returnValue(Promise.resolve(true));
    component.onNextClick();
    tick();
    expect(component.isLoader).toBeFalse();
    expect(router.navigate).toHaveBeenCalledWith(['/account-selection']);
  }));
  it('should handle web platform on getSimInfo', async () => {
    platform.is.and.returnValue(false);
    await component.getSimInfo();
    expect(component.errorMessage).toEqual(translateService.instant('ERROR.SIM_INFO'));
  });
  it('should unsubscribe from back button on ngOnDestroy', () => {
    // Create a mock subscription
    const mockSubscription = jasmine.createSpyObj('Subscription', ['unsubscribe']);
  
    // Mock the BackButtonEmitter
    const mockBackButtonEmitter = jasmine.createSpyObj('BackButtonEmitter', ['subscribeWithPriority']);
    mockBackButtonEmitter.subscribeWithPriority.and.returnValue(mockSubscription);
  
    // Assign the mock BackButtonEmitter to platform.backButton
    platform.backButton = mockBackButtonEmitter;
  
    // Call ionViewDidEnter to subscribe to the backButton observable
    component.ionViewDidEnter();
  
    // Verify that subscribeWithPriority was called
    expect(platform.backButton.subscribeWithPriority).toHaveBeenCalledWith(
      9999,
      jasmine.any(Function) // Ensure the callback is a function
    );
  
    // Call ngOnDestroy to unsubscribe
    component.ngOnDestroy();
  
    // Verify that the subscription was unsubscribed
    expect(mockSubscription.unsubscribe).toHaveBeenCalled();
  });
  it('should create', () => {
    expect(component).toBeTruthy();
  });
  it('should close terms modal', () => {
    component.closeTermsModal();
    expect(component.isModalOpen).toBeFalse();
  });
  it('should unsubscribe from back button on ionViewWillLeave', () => {
    // Create a mock subscription
    const mockSubscription = jasmine.createSpyObj('Subscription', ['unsubscribe']);
  
    // Mock the BackButtonEmitter
    const mockBackButtonEmitter = jasmine.createSpyObj('BackButtonEmitter', ['subscribeWithPriority']);
    mockBackButtonEmitter.subscribeWithPriority.and.returnValue(mockSubscription);
  
    // Assign the mock BackButtonEmitter to platform.backButton
    platform.backButton = mockBackButtonEmitter;
  
    // Call ionViewDidEnter to subscribe to the backButton observable
    component.ionViewDidEnter();
  
    // Verify that subscribeWithPriority was called
    expect(platform.backButton.subscribeWithPriority).toHaveBeenCalledWith(
      9999,
      jasmine.any(Function) // Ensure the callback is a function
    );
  
    // Call ionViewWillLeave to unsubscribe
    component.ionViewWillLeave();
  
    // Verify that the subscription was unsubscribed
    expect(mockSubscription.unsubscribe).toHaveBeenCalled();
  });

  it('should handle error on getSimInfo', async () => {
    platform.is.and.returnValue(true);
    (component as any).SimBind = { getSimInfo: () => Promise.reject('Error') };
    await component.getSimInfo();
    expect(component.simInfo).toEqual({ cards: [] });
    expect(component.errorMessage).toEqual(translateService.instant('ERROR.SIM_INFO'));
  });
  it('should fetch SIM info on getSimInfo', async () => {
    const simInfo = { cards: [{ carrierName: 'Carrier', simSlotIndex: 1, subscriptionId: 1 }] };
    platform.is.and.returnValue(true);
    (component as any).SimBind = { getSimInfo: () => Promise.resolve(simInfo) };
    await component.getSimInfo();
    expect(component.simInfo).toEqual(simInfo);
  });
 
  
  it('should send SMS to VMN list', async () => {
    component.selectedSim = { carrierName: 'Carrier', simSlotIndex: 1, subscriptionId: 1 };
    (component as any).SimBind = { sendSMS: () => Promise.resolve({ status: 'SMS sent successfully.' }) };
    const result = await component.sendSMSToVmnList([{ vmn_number: '123', is_primary: true }]);
    expect(result).toBeTrue();
  });
  it('should open modal', () => {
    component.openModal();
    expect(component.isModalOpen).toBeTrue();
  });









  // it('should initialize with default values', () => {
  //   expect(component.simInfo).toEqual({ cards: [] });
  //   expect(component.errorMessage).toEqual('');
  //   expect(component.isTermsAccepted).toBeFalse();
  //   expect(component.isSimSelected).toBeFalse();
  //   expect(component.selectedSim).toBeNull();
  //   expect(component.isModalOpen).toBeFalse();
  //   expect(component.termsContent).toEqual('');
  //   expect(component.isLoader).toBeFalse();
  // });

 
  
  // it('should handle back button subscription on ionViewDidEnter', () => {
  //   component.ionViewDidEnter();
  //   expect(component.backButtonSubscription).toBeDefined();
  // });

  // it('should unsubscribe from back button on ionViewWillLeave', () => {
  //   component.ionViewDidEnter();
  //   component.ionViewWillLeave();
  //   expect(component.backButtonSubscription?.closed).toBeTrue();
  // });

  // it('should unsubscribe from back button on ngOnDestroy', () => {
  //   component.ionViewDidEnter();
  //   component.ngOnDestroy();
  //   expect(component.backButtonSubscription?.closed).toBeTrue();
  // });

  // it('should fetch SIM info on getSimInfo', async () => {
  //   const simInfo = { cards: [{ carrierName: 'Carrier', simSlotIndex: 1, subscriptionId: 1 }] };
  //   platform.is.and.returnValue(true);
  //   (component as any).SimBind = { getSimInfo: () => Promise.resolve(simInfo) };
  //   await component.getSimInfo();
  //   expect(component.simInfo).toEqual(simInfo);
  // });

  // it('should handle error on getSimInfo', async () => {
  //   platform.is.and.returnValue(true);
  //   (component as any).SimBind = { getSimInfo: () => Promise.reject('Error') };
  //   await component.getSimInfo();
  //   expect(component.simInfo).toEqual({ cards: [] });
  //   expect(component.errorMessage).toEqual(translateService.instant('ERROR.SIM_INFO'));
  // });

  // it('should handle web platform on getSimInfo', async () => {
  //   platform.is.and.returnValue(false);
  //   await component.getSimInfo();
  //   expect(component.errorMessage).toEqual(translateService.instant('ERROR.SIM_INFO'));
  // });

  // it('should handle onNextClick with no SIM selected', async () => {
  //   component.isSimSelected = false;
  //   await component.onNextClick();
  //   expect(component.isLoader).toBeFalse();
  //   expect(alert).toHaveBeenCalledWith(translateService.instant('ERROR.SELECT_SIM'));
  // });

  // it('should handle onNextClick with SIM selected', fakeAsync(() => {
  //   component.isSimSelected = true;
  //   component.selectedSim = { carrierName: 'Carrier', simSlotIndex: 1, subscriptionId: 1 };
  //   storageService.getItem.and.returnValue([{ vmn_number: '123', is_primary: true }]);
  //   spyOn(component, 'sendSMSToVmnList').and.returnValue(Promise.resolve(true));
  //   spyOn(component, 'fetchMobileNumberWithRetries').and.returnValue(Promise.resolve(true));
  //   component.onNextClick();
  //   tick();
  //   expect(component.isLoader).toBeFalse();
  //   expect(router.navigate).toHaveBeenCalledWith(['/account-selection']);
  // }));

  // it('should handle onNextClick with SMS send failure', fakeAsync(() => {
  //   component.isSimSelected = true;
  //   component.selectedSim = { carrierName: 'Carrier', simSlotIndex: 1, subscriptionId: 1 };
  //   storageService.getItem.and.returnValue([{ vmn_number: '123', is_primary: true }]);
  //   spyOn(component, 'sendSMSToVmnList').and.returnValue(Promise.resolve(false));
  //   component.onNextClick();
  //   tick();
  //   expect(component.isLoader).toBeFalse();
  //   expect(alert).toHaveBeenCalledWith(translateService.instant('ERROR.SMS_SEND'));
  // }));

  // it('should handle onNextClick with mobile number fetch failure', fakeAsync(() => {
  //   component.isSimSelected = true;
  //   component.selectedSim = { carrierName: 'Carrier', simSlotIndex: 1, subscriptionId: 1 };
  //   storageService.getItem.and.returnValue([{ vmn_number: '123', is_primary: true }]);
  //   spyOn(component, 'sendSMSToVmnList').and.returnValue(Promise.resolve(true));
  //   spyOn(component, 'fetchMobileNumberWithRetries').and.returnValue(Promise.resolve(false));
  //   component.onNextClick();
  //   tick();
  //   expect(component.isLoader).toBeFalse();
  //   expect(alert).toHaveBeenCalledWith(translateService.instant('ERROR.MOBILE_FETCH'));
  // }));

  // it('should fetch mobile number with retries', fakeAsync(() => {
  //   spyOn(component, 'fetchMobileNumberFromAPI').and.returnValues(Promise.resolve(false), Promise.resolve(true));
  //   component.fetchMobileNumberWithRetries(2, 1000).then((result) => {
  //     expect(result).toBeTrue();
  //   });
  //   tick(2000);
  // }));

  // it('should handle fetchMobileNumberFromAPI success', fakeAsync(() => {
  //   apiService.getUserDevices.and.returnValue(of({ code: 2000, mobile_number: '1234567890' }));
  //   component.fetchMobileNumberFromAPI().then((result) => {
  //     expect(result).toBeTrue();
  //     expect(storageService.setItem).toHaveBeenCalledWith('mobile_number', '1234567890');
  //   });
  //   tick();
  // }));

  // it('should handle fetchMobileNumberFromAPI failure', fakeAsync(() => {
  //   apiService.getUserDevices.and.returnValue(of({ code: 4000 }));
  //   component.fetchMobileNumberFromAPI().then((result) => {
  //     expect(result).toBeFalse();
  //   });
  //   tick();
  // }));

  // it('should handle fetchMobileNumberFromAPI error', fakeAsync(() => {
  //   apiService.getUserDevices.and.returnValue(throwError('Error'));
  //   component.fetchMobileNumberFromAPI().then((result) => {
  //     expect(result).toBeFalse();
  //   });
  //   tick();
  // }));

  // it('should send SMS to VMN list', async () => {
  //   component.selectedSim = { carrierName: 'Carrier', simSlotIndex: 1, subscriptionId: 1 };
  //   (component as any).SimBind = { sendSMS: () => Promise.resolve({ status: 'SMS sent successfully.' }) };
  //   const result = await component.sendSMSToVmnList([{ vmn_number: '123', is_primary: true }]);
  //   expect(result).toBeTrue();
  // });

  // it('should handle sendSMS failure', async () => {
  //   component.selectedSim = { carrierName: 'Carrier', simSlotIndex: 1, subscriptionId: 1 };
  //   (component as any).SimBind = { sendSMS: () => Promise.reject('Error') };
  //   const result = await component.sendSMSToVmnList([{ vmn_number: '123', is_primary: true }]);
  //   expect(result).toBeFalse();
  // });

  // it('should get active VMN numbers', () => {
  //   const vmnList = [{ vmn_number: '123', is_primary: true }, { vmn_number: '456', is_primary: false }];
  //   const result = component.getActiveVmnNumbers(vmnList);
  //   expect(result).toEqual(['123']);
  // });

  // it('should encode message', () => {
  //   storageService.getItem.and.returnValue('device123');
  //   const result = component.encodedMessage('sim123');
  //   expect(result).toBeDefined();
  //   expect(storageService.setItem).toHaveBeenCalledWith('encodedMessage', result);
  // });

  // it('should open terms modal', () => {
  //   apiService.getTermsAndConditions.and.returnValue(of({ code: 2000, message: 'Terms content' }));
  //   component.openTermsModal();
  //   expect(component.isModalOpen).toBeTrue();
  //   expect(component.termsContent).toEqual('Terms content');
  // });

  // it('should handle terms modal error', () => {
  //   apiService.getTermsAndConditions.and.returnValue(throwError('Error'));
  //   component.openTermsModal();
  //   expect(component.isModalOpen).toBeTrue();
  //   expect(component.termsContent).toEqual(translateService.instant('ERROR.TERMS_LOAD'));
  // });

  // it('should close terms modal', () => {
  //   component.closeTermsModal();
  //   expect(component.isModalOpen).toBeFalse();
  // });

  // it('should change language', () => {
  //   spyOn(translateService, 'use');
  //   component.changeLanguage('es');
  //   expect(translateService.use).toHaveBeenCalledWith('es');
  // });

  // it('should open modal', () => {
  //   component.openModal();
  //   expect(component.isModalOpen).toBeTrue();
  // });
});