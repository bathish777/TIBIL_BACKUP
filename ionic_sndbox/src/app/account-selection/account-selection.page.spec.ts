import { ComponentFixture, TestBed } from '@angular/core/testing';
import { AccountSelectionPage } from './account-selection.page';
import { Router } from '@angular/router';
import { ApiService } from '../services/api.service';
import { TranslateService, TranslateModule } from '@ngx-translate/core';
import { LocalStorageService } from '../services/local-storage.service';
import { of, throwError } from 'rxjs';
import { FormsModule } from '@angular/forms';
import { IonicModule } from '@ionic/angular';
import { CommonModule } from '@angular/common';

describe('AccountSelectionPage', () => {
  let component: AccountSelectionPage;
  let fixture: ComponentFixture<AccountSelectionPage>;
  let apiService: jasmine.SpyObj<ApiService>;
  let router: jasmine.SpyObj<Router>;
  let translate: jasmine.SpyObj<TranslateService>;
  let localStorageService: jasmine.SpyObj<LocalStorageService>;

  beforeEach(async () => {
    const apiSpy = jasmine.createSpyObj('ApiService', ['getAccounts']);
    const routerSpy = jasmine.createSpyObj('Router', ['navigate']);
    const translateSpy = jasmine.createSpyObj('TranslateService', ['setDefaultLang', 'use']);
    const localStorageSpy = jasmine.createSpyObj('LocalStorageService', ['getItem', 'setItem']);

    await TestBed.configureTestingModule({
      imports: [IonicModule.forRoot(), FormsModule, CommonModule, TranslateModule],
      providers: [
        { provide: ApiService, useValue: apiSpy },
        { provide: Router, useValue: routerSpy },
        { provide: TranslateService, useValue: translateSpy },
        { provide: LocalStorageService, useValue: localStorageSpy },
      ],
    }).compileComponents();

    fixture = TestBed.createComponent(AccountSelectionPage);
    component = fixture.componentInstance;
    apiService = TestBed.inject(ApiService) as jasmine.SpyObj<ApiService>;
    router = TestBed.inject(Router) as jasmine.SpyObj<Router>;
    translate = TestBed.inject(TranslateService) as jasmine.SpyObj<TranslateService>;
    localStorageService = TestBed.inject(LocalStorageService) as jasmine.SpyObj<LocalStorageService>;
  });

  it('should create the component', () => {
    expect(component).toBeTruthy();
  });

  it('should fetch accounts on initialization', () => {
    localStorageService.getItem.and.returnValue('9876543210'); // Mock mobile number
    const mockAccounts = {
      code: 2000,
      data: {
        accounts: [
          { accountId: '1', customerFullName: 'John Doe', customerId: '12345', accountType: 'Savings', IFSCCode: 'ABC123' },
        ],
      },
    };

    apiService.getAccounts.and.returnValue(of(mockAccounts));

    component.ngOnInit();

    expect(apiService.getAccounts).toHaveBeenCalledWith('9876543210');
    expect(component.accounts.length).toBe(1);
    expect(localStorageService.setItem).toHaveBeenCalledWith('accounts', JSON.stringify(component.accounts));
  });

  it('should handle error when fetching accounts fails due to API error', () => {
    // Mock mobile number
    component.mobile = '9876543210'; // Set the mobile number directly
    localStorageService.getItem.and.returnValue('9876543210'); // Mock localStorage to return the mobile number
  
    // Mock API error
    apiService.getAccounts.and.returnValue(throwError('Error fetching accounts'));
  
    // Call the method
    component.fetchAccounts();
  
    // Verify the error message
    expect(component.errorMessage).toBe('Error fetching accounts. Please try again.');
  });
  it('should set error message if mobile number is missing', () => {
    localStorageService.getItem.and.returnValue(null); // No mobile number

    component.fetchAccounts();

    expect(component.errorMessage).toBe('Mobile number is required to fetch accounts.');
  });

  it('should select an account and store it in local storage', () => {
    component.onAccountSelected('1');
    expect(component.selectedAccountId).toBe('1');
    expect(localStorageService.setItem).toHaveBeenCalledWith('selectedAccountId', '1');
  });

  it('should toggle account details visibility', () => {
    component.accounts = [{ id: '1', name: 'John', number: '12345', type: 'Savings', showDetails: false }];
    component.toggleAccountDetails('1');
    expect(component.accounts[0].showDetails).toBeTrue();
    expect(component.isExpanded).toBeTrue();
  });
  it('should navigate to VPA selection if an account is selected', () => {
    // Mock the router.navigate method to return a resolved Promise
    router.navigate.and.returnValue(Promise.resolve(true));
  
    // Set the selected account ID
    component.selectedAccountId = '1';
  
    // Call the method
    component.navigateToVpaSelection();
  
    // Verify that router.navigate was called with the correct arguments
    expect(router.navigate).toHaveBeenCalledWith(['/vpa-selection'], {
      queryParams: { accountId: '1' },
    });
  });

  it('should show an error if no account is selected before navigation', () => {
    component.selectedAccountId = null;
    component.navigateToVpaSelection();
    expect(component.errorMessage).toBe('Please select an account before proceeding.');
  });

  it('should change the language', () => {
    component.changeLanguage('fr');
    expect(translate.use).toHaveBeenCalledWith('fr');
  });

  it('should handle error when fetching accounts fails due to missing mobile number', () => {
    localStorageService.getItem.and.returnValue(null); // No mobile number

    component.fetchAccounts();

    expect(component.errorMessage).toBe('Mobile number is required to fetch accounts.');
  });

  it('should handle error when fetching accounts fails due to API error', () => {
    // Mock mobile number
    component.mobile = '9876543210'; // Set the mobile number directly
    localStorageService.getItem.and.returnValue('9876543210'); // Mock localStorage to return the mobile number
  
    // Mock API error
    apiService.getAccounts.and.returnValue(throwError('API Error'));
  
    // Call the method
    component.fetchAccounts();
  
    // Verify the error message
    expect(component.errorMessage).toBe('Error fetching accounts. Please try again.');
  });
  it('should handle error when fetching accounts returns a non-2000 code', () => {
    // Mock mobile number
    component.mobile = '9876543210'; // Set the mobile number directly
    localStorageService.getItem.and.returnValue('9876543210'); // Mock localStorage to return the mobile number
  
    // Mock API response with a non-2000 code
    const mockAccounts = {
      code: 4000,
      message: 'Failed to fetch accounts.',
    };
    apiService.getAccounts.and.returnValue(of(mockAccounts));
  
    // Call the method
    component.fetchAccounts();
  
    // Verify the error message
    expect(component.errorMessage).toBe('Failed to fetch accounts.');
  });

  it('should set default language on initialization', () => {
    component.ngOnInit();
    expect(translate.setDefaultLang).toHaveBeenCalledWith('en');
  });

  it('should handle error when mobile number is not found in storage', () => {
    localStorageService.getItem.and.returnValue(null); // No mobile number

    component.getMobileNumberFromStorage();

    expect(component.errorMessage).toBe('Mobile number is not found in storage.');
  });

  it('should retrieve mobile number from storage', () => {
    localStorageService.getItem.and.returnValue('9876543210'); // Mock mobile number

    component.getMobileNumberFromStorage();

    expect(component.mobile).toBe('9876543210');
  });
});