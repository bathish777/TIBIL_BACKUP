import { ComponentFixture, TestBed, fakeAsync, tick } from '@angular/core/testing';
import { TransactionsComponent } from './transactions.page';
import { ApiService } from '../services/api.service';
import { Router } from '@angular/router';
import { TranslateModule, TranslateService, TranslateStore } from '@ngx-translate/core';
import { of, throwError } from 'rxjs';
import { IonicModule } from '@ionic/angular';
import { FormsModule } from '@angular/forms';
import { ChangeDetectorRef } from '@angular/core';
import { LocalStorageService } from '../services/local-storage.service';
import { FcmService } from '../services/fcm.service';
import { NotificationHandlerService } from '../services/notification-handler.service';

describe('TransactionsComponent', () => {
  let component: TransactionsComponent;
  let fixture: ComponentFixture<TransactionsComponent>;
  let apiService: jasmine.SpyObj<ApiService>;
  let router: jasmine.SpyObj<Router>;
  let localStorageService: jasmine.SpyObj<LocalStorageService>;
  let fcmService: jasmine.SpyObj<FcmService>;
  let notificationHandler: jasmine.SpyObj<NotificationHandlerService>;
  let cdr: ChangeDetectorRef;

  beforeEach(async () => {
    const apiServiceSpy = jasmine.createSpyObj('ApiService', ['getAllPayments', 'getPaymentSummary']);
    const routerSpy = jasmine.createSpyObj('Router', ['navigate']);
    const localStorageSpy = jasmine.createSpyObj('LocalStorageService', ['getItem']);
    const fcmServiceSpy = jasmine.createSpyObj('FcmService', ['initPush']);
    const notificationHandlerSpy = jasmine.createSpyObj('NotificationHandlerService', ['startPolling']);

    await TestBed.configureTestingModule({
      declarations: [],
      imports: [
        IonicModule.forRoot(),
        FormsModule,
        TranslateModule.forRoot(),
      ],
      providers: [
        { provide: ApiService, useValue: apiServiceSpy },
        { provide: Router, useValue: routerSpy },
        { provide: LocalStorageService, useValue: localStorageSpy },
        { provide: FcmService, useValue: fcmServiceSpy },
        { provide: NotificationHandlerService, useValue: notificationHandlerSpy },
        TranslateService,
        TranslateStore,
        ChangeDetectorRef,
      ],
    }).compileComponents();

    fixture = TestBed.createComponent(TransactionsComponent);
    component = fixture.componentInstance;
    apiService = TestBed.inject(ApiService) as jasmine.SpyObj<ApiService>;
    router = TestBed.inject(Router) as jasmine.SpyObj<Router>;
    localStorageService = TestBed.inject(LocalStorageService) as jasmine.SpyObj<LocalStorageService>;
    fcmService = TestBed.inject(FcmService) as jasmine.SpyObj<FcmService>;
    notificationHandler = TestBed.inject(NotificationHandlerService) as jasmine.SpyObj<NotificationHandlerService>;
    cdr = TestBed.inject(ChangeDetectorRef);

    // Mock localStorage.getItem
    localStorageService.getItem.and.returnValue('mock-value');
  });

  it('should create the component', () => {
    expect(component).toBeTruthy();
  });

  it('should initialize with default values', () => {
    expect(component.totalTransactions).toBe(0);
    expect(component.totalAmount).toBe(0);
    expect(component.transactionList.length).toBe(0);
    expect(component.offset).toBe(0);
    expect(component.limit).toBe(10);
    expect(component.hasMore).toBeTrue();
    expect(component.showBanner).toBeTrue();
    expect(component.isLoading).toBeFalse();
  });

  // it('should set language from localStorage on ngOnInit', () => {
  //   localStorageService.getItem.and.returnValue('fr');
  //   component.ngOnInit();
  //   expect(component.selectedLanguage).toBe('fr');
  // });

  it('should initialize FCM and notification polling on ngOnInit', () => {
    component.ngOnInit();
    expect(fcmService.initPush).toHaveBeenCalled();
    expect(notificationHandler.startPolling).toHaveBeenCalled();
  });

  it('should reset data on ionViewWillEnter', () => {
    spyOn(component, 'resetData');
    spyOn(component, 'fetchPaymentSummary');
    spyOn(component, 'fetchTransactions');

    component.ionViewWillEnter();

    expect(component.resetData).toHaveBeenCalled();
    expect(component.fetchPaymentSummary).toHaveBeenCalled();
    expect(component.fetchTransactions).toHaveBeenCalled();
  });

  it('should reset transaction list, offset, and flags', () => {
    component.transactionList = [{ name: 'Test' }];
    component.offset = 50;
    component.hasMore = false;
    component.isLoading = true;

    component.resetData();

    expect(component.transactionList.length).toBe(0);
    expect(component.offset).toBe(0);
    expect(component.hasMore).toBeTrue();
    expect(component.isLoading).toBeFalse();
  });

  // it('should fetch and set payment summary data', () => {
  //   const mockSummary = { data: { transactionCount: 5, totalAmount: 2000 } };
  //   apiService.getPaymentSummary.and.returnValue(of(mockSummary));

  //   component.fetchPaymentSummary();

  //   expect(apiService.getPaymentSummary).toHaveBeenCalled();
  //   expect(component.totalTransactions).toBe(5);
  //   expect(component.totalAmount).toBe(2000);
  // });

  it('should handle payment summary API errors gracefully', () => {
    apiService.getPaymentSummary.and.returnValue(throwError(() => new Error('API Error')));

    component.fetchPaymentSummary();

    expect(component.totalTransactions).toBe(0);
    expect(component.totalAmount).toBe(0);
  });

  // it('should fetch transactions and update the list', () => {
  //   const mockTransactions = {
  //     code: 2000,
  //     data: { payments: [{ name: 'Test Transaction' }] },
  //   };

  //   apiService.getAllPayments.and.returnValue(of(mockTransactions));

  //   component.fetchTransactions();

  //   expect(apiService.getAllPayments).toHaveBeenCalled();
  //   expect(component.transactionList.length).toBe(1);
  //   expect(component.transactionList[0].name).toBe('Test Transaction');
  // });

  it('should handle transaction API errors gracefully', () => {
    apiService.getAllPayments.and.returnValue(throwError(() => new Error('API Error')));

    component.fetchTransactions();

    expect(component.transactionList.length).toBe(0);
  });

  // it('should complete infinite scroll event on fetching transactions', () => {
  //   const event = {
  //     target: {
  //       complete: jasmine.createSpy('complete'),
  //     },
  //   };

  //   apiService.getAllPayments.and.returnValue(of({
  //     code: 2000,
  //     data: { payments: [{ name: 'Transaction' }] },
  //   }));

  //   component.fetchTransactions(event);

  //   expect(event.target.complete).toHaveBeenCalled();
  // });

  // it('should disable infinite scroll if no more transactions are available', () => {
  //   const event = {
  //     target: {
  //       complete: jasmine.createSpy('complete'),
  //       disabled: false,
  //     },
  //   };

  //   apiService.getAllPayments.and.returnValue(of({
  //     code: 2000,
  //     data: { payments: [] },
  //   }));

  //   component.fetchTransactions(event);

  //   expect(event.target.disabled).toBeTrue();
  // });

  it('should navigate to QR view', () => {
    component.navigateTo();
    expect(router.navigate).toHaveBeenCalledWith(['/qr-view'], { replaceUrl: true });
  });

  it('should dismiss the notification banner', () => {
    component.dismissNotification();
    expect(component.showBanner).toBeFalse();
  });

  it('should return a valid hex color', () => {
    const color = component.getRandomColor();
    expect(color).toMatch(/^#[0-9A-F]{6}$/);
  });

  // it('should set language from localStorage or default to English', () => {
  //   localStorageService.getItem.and.returnValue(null);
  //   component.setLanguage();
  //   expect(component.selectedLanguage).toBe('en');
  // });

  it('should handle missing authToken, uuid, or vpa in fetchPaymentSummary', () => {
    localStorageService.getItem.and.returnValue(null);
    component.fetchPaymentSummary();
    expect(apiService.getPaymentSummary).not.toHaveBeenCalled();
  });
  
});

