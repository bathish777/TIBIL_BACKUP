import { ComponentFixture, TestBed, fakeAsync, tick } from '@angular/core/testing';
import { SettingsMenuComponent } from './settings-menu.component';
import { Router } from '@angular/router';
import { TranslateService, TranslateModule } from '@ngx-translate/core';
import { LocalStorageService } from '../services/local-storage.service';
import { of } from 'rxjs';
import { FormsModule } from '@angular/forms';
import { IonicModule } from '@ionic/angular';
import { CommonModule } from '@angular/common';

describe('SettingsMenuComponent', () => {
  let component: SettingsMenuComponent;
  let fixture: ComponentFixture<SettingsMenuComponent>;
  let router: jasmine.SpyObj<Router>;
  let translate: jasmine.SpyObj<TranslateService>;
  let localStorageService: jasmine.SpyObj<LocalStorageService>;

  beforeEach(async () => {
    const routerSpy = jasmine.createSpyObj('Router', ['navigate']);
    const translateSpy = jasmine.createSpyObj('TranslateService', ['setDefaultLang', 'use', 'get']);
    translateSpy.get.and.returnValue(of('Mocked Translation'));  // Mock the get method
    const localStorageSpy = jasmine.createSpyObj('LocalStorageService', ['getItem', 'setItem','removeItem']);

    await TestBed.configureTestingModule({
      imports: [
        SettingsMenuComponent,
        IonicModule.forRoot(),
        FormsModule,
        CommonModule,
        TranslateModule.forRoot(), // Include the TranslateModule for translation functionality
      ],
      declarations: [], // Declare the component directly since it's standalone
      providers: [
        { provide: Router, useValue: routerSpy },
        { provide: TranslateService, useValue: translateSpy },
        { provide: LocalStorageService, useValue: localStorageSpy },
      ],
    }).compileComponents();

    fixture = TestBed.createComponent(SettingsMenuComponent);
    component = fixture.componentInstance;
    router = TestBed.inject(Router) as jasmine.SpyObj<Router>;
    translate = TestBed.inject(TranslateService) as jasmine.SpyObj<TranslateService>;
    localStorageService = TestBed.inject(LocalStorageService) as jasmine.SpyObj<LocalStorageService>;

    // Simulate translation setup if needed
    translate.setDefaultLang('en');
  });

  it('should create the component', () => {
    expect(component).toBeTruthy();
  });

  // it('should switch language and save to localStorage', () => {
  //   spyOn(localStorage, 'setItem');
  //   component.switchLanguage('fr');
  //   expect(translate.use).toHaveBeenCalledWith('fr');
  //   expect(localStorage.setItem).toHaveBeenCalledWith('selectedLanguage', 'fr');
  // });

  it('should navigate to the correct page when setCurrentPage is called with profile', () => {
    component.setCurrentPage('profile');
    expect(router.navigate).toHaveBeenCalledWith(['settings/my-profile']);
  });

  it('should navigate to the correct page when setCurrentPage is called with qr-code', () => {
    component.setCurrentPage('qr-code');
    expect(router.navigate).toHaveBeenCalledWith(['settings/my-qr-code']);
  });

  it('should navigate to the correct page when setCurrentPage is called with language-preference', () => {
    component.setCurrentPage('language-preference');
    expect(router.navigate).toHaveBeenCalledWith(['settings/language-preference']);
  });

  // it('should navigate to splash-screen for an unknown tab', () => {
  //   component.setCurrentPage('somePage');
  //   expect(router.navigate).toHaveBeenCalledWith(['/splash-screen']);
  // });
  

  it('should toggle mute and show confirmation modal', () => {
    spyOn(localStorage, 'setItem');
    component.toggleMute();
    expect(localStorage.setItem).toHaveBeenCalledWith('isMuted', jasmine.any(String));
    expect(component.isMuteAnnouncementModalOpen).toBeTrue();
  });

  it('should close sign-out modal', () => {
    component.isSignOutModalOpen = true;
    component.closeSignOutModal();
    expect(component.isSignOutModalOpen).toBeFalse();
  });

  // it('should sign out and navigate to splash-screen', fakeAsync(() => {
  //   // Call the signOut method
  //   component.signOut();

  //   // Simulate the passage of time to allow the setTimeout to complete
  //   tick(100);  // You can adjust this value if needed

  //   // Verify that the navigation happened
  //   expect(router.navigate).toHaveBeenCalledWith(['/splash-screen']);
  // }));

  // it('should initialize with saved language from local storage', () => {
  //   spyOn(localStorage, 'getItem').and.returnValue('es');
  //   component.ngOnInit();
  //   expect(translate.use).toHaveBeenCalledWith('es');
  // });
  // it('should sign out the user and navigate to the splash screen', fakeAsync(() => {
  //   // Set initial state
  //   component.isSignOutModalOpen = true;
  
  //   // Call the method
  //   component.signOut();
  
  //   // Verify localStorage.removeItem was called with 'userCredential'
    
  //   // Verify the modal is closed
  //   expect(component.isSignOutModalOpen).toBeFalse();
  
  //   // Advance the timer by 100ms
  //   tick(100);
  
  //   // Verify navigation to the splash screen
  //   expect(router.navigate).toHaveBeenCalledWith(['/splash-screen']);
  // }));

  it('should default to English if no language is saved in local storage', () => {
    spyOn(localStorage, 'getItem').and.returnValue(null);
    component.ngOnInit();
    expect(translate.use).toHaveBeenCalledWith('en');
  });

  it('should confirm mute toggle and close modal', () => {
    component.isMuteAnnouncementModalOpen = true;
    component.confirmMuteToggle();
    expect(component.isMuteAnnouncementModalOpen).toBeFalse();
  });

  it('should navigate to forgot MPIN verification page', () => {
    component.navigateToForgotMpin();
    expect(router.navigate).toHaveBeenCalledWith(['/verification'], {
      queryParams: { action: 'forgot-mpin' },
    });
  });

  it('should navigate to verification page for MPIN reset', fakeAsync(() => {
    component.navigateToVerification();
    tick(100);
    expect(router.navigate).toHaveBeenCalledWith(['/verification'], {
      queryParams: { action: 'forgot-mpin' },
    });
  }));

  it('should open reset MPIN modal', () => {
    component.confirmResetMpin();
    expect(component.isResetMpinModalOpen).toBeTrue();
  });

  it('should reset MPIN successfully', () => {
    localStorageService.getItem.and.returnValue('1234');
    component.newMpin = '5678';
    component.resetMpin();
    expect(localStorageService.setItem).toHaveBeenCalledWith('createdMpin', '5678');
    expect(component.resetMpinError).toBe('');
    expect(component.isResetMpinModalOpen).toBeFalse();
  });

  it('should show error if new MPIN is the same as stored MPIN', () => {
    localStorageService.getItem.and.returnValue('1234');
    component.newMpin = '1234';
    component.resetMpin();
    expect(component.resetMpinError).toBe('You cannot use the same MPIN again. Please choose a different MPIN.');
  });

  it('should close reset MPIN modal and clear error', () => {
    component.isResetMpinModalOpen = true;
    component.resetMpinError = 'Some error';
    component.closeResetMpinModal();
    expect(component.isResetMpinModalOpen).toBeFalse();
    expect(component.resetMpinError).toBe('');
  });

  it('should open sign-out modal', () => {
    component.openSignOutModal();
    expect(component.isSignOutModalOpen).toBeTrue();
  });

  it('should close mute announcement modal', () => {
    component.isMuteAnnouncementModalOpen = true;
    component.closeMuteAnnouncementModal();
    expect(component.isMuteAnnouncementModalOpen).toBeFalse();
  });
});