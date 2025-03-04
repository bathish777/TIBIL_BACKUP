import { ComponentFixture, TestBed } from '@angular/core/testing';
import { Router } from '@angular/router';
import { TranslateService } from '@ngx-translate/core';
import { ApiService } from '../services/api.service';
import { DashboardPage } from './dashboard.page';
import { of, throwError } from 'rxjs';
import { IonicModule } from '@ionic/angular';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { TabBarComponent } from '../shared/tab-bar/tab-bar.component';
import { HttpClientTestingModule } from '@angular/common/http/testing';

describe('DashboardPage', () => {
  let component: DashboardPage;
  let fixture: ComponentFixture<DashboardPage>;
  let routerSpy: jasmine.SpyObj<Router>;
  let apiServiceSpy: jasmine.SpyObj<ApiService>;
  let translateServiceSpy: jasmine.SpyObj<TranslateService>;

  beforeEach(() => {
    routerSpy = jasmine.createSpyObj('Router', ['navigate']);
    apiServiceSpy = jasmine.createSpyObj('ApiService', ['getPaymentSummary']);
    translateServiceSpy = jasmine.createSpyObj('TranslateService', ['use', 'get']);

    TestBed.configureTestingModule({
      declarations: [],
      imports: [
        IonicModule,
        CommonModule,
        FormsModule,
        DashboardPage, TabBarComponent,
        HttpClientTestingModule
      ],
      providers: [
        { provide: Router, useValue: routerSpy },
        { provide: ApiService, useValue: apiServiceSpy },
        { provide: TranslateService, useValue: translateServiceSpy }
      ]
    }).compileComponents();

    fixture = TestBed.createComponent(DashboardPage);
    component = fixture.componentInstance;
  });

  it('should create the component', () => {
    expect(component).toBeTruthy();
  });

  it('should load the selected language from local storage', () => {
    localStorage.setItem('selectedLanguage', 'fr');
    component.ngOnInit();
    expect(translateServiceSpy.use).toHaveBeenCalledWith('fr');
  });

  it('should use default language if none is stored', () => {
    localStorage.removeItem('selectedLanguage');
    component.ngOnInit();
    expect(translateServiceSpy.use).toHaveBeenCalledWith('en');
  });

  it('should call fetchPaymentSummary on init', () => {
    const fetchPaymentSummarySpy = spyOn(component, 'fetchPaymentSummary');
    component.ngOnInit();
    expect(fetchPaymentSummarySpy).toHaveBeenCalled();
  });

  it('should toggle pink container visibility', () => {
    expect(component.pinkContainerVisible).toBeFalse();
    component.togglePinkContainer();
    expect(component.pinkContainerVisible).toBeTrue();
    component.togglePinkContainer();
    expect(component.pinkContainerVisible).toBeFalse();
  });

  it('should update the header text based on selected tab', () => {
    translateServiceSpy.get.and.returnValue(of('Transactions'));
    component.selectTab('transactions');
    expect(routerSpy.navigate).toHaveBeenCalledWith(['transactions']);
    expect(component.currentHeader).toBe('Transactions');
  });

  it('should update the header text when switching tabs', () => {
    translateServiceSpy.get.and.returnValue(of('Settings'));
    component.selectTab('settings');
    expect(component.currentHeader).toBe('Settings');
  });

  it('should dismiss the notification banner', () => {
    component.dismissNotification();
    expect(component.showBanner).toBeFalse();
  });

  // it('should fetch payment summary successfully', () => {
  //   const mockSummary = { data: { transactionCount: 10, totalAmount: 1000 } };
  //   apiServiceSpy.getPaymentSummary.and.returnValue(of(mockSummary));
  //   component.fetchPaymentSummary();
  //   expect(component.totalTransactions).toBe(10);
  //   expect(component.totalAmount).toBe(1000);
  // });

  it('should handle payment summary fetch error', () => {
    apiServiceSpy.getPaymentSummary.and.returnValue(throwError('Error'));
    component.fetchPaymentSummary();
    expect(component.totalTransactions).toBe(0);
    expect(component.totalAmount).toBe(0);
  });

  it('should switch languages and store it in localStorage', () => {
    component.switchLanguage('fr');
    expect(translateServiceSpy.use).toHaveBeenCalledWith('fr');
    expect(localStorage.getItem('selectedLanguage')).toBe('fr');
  });

  it('should navigate to QR view', () => {
    component.navigateTo();
    expect(routerSpy.navigate).toHaveBeenCalledWith(['/qr-view']);
  });
});
