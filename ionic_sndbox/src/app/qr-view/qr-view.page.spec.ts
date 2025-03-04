import { ComponentFixture, TestBed } from '@angular/core/testing';
import { Router } from '@angular/router';
import { TranslateService } from '@ngx-translate/core';
import { LocalStorageService } from '../services/local-storage.service';
import { QrViewPage } from './qr-view.page';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { TranslateModule } from '@ngx-translate/core';
import { IonContent, IonLabel, IonText } from '@ionic/angular/standalone';
import { RouterTestingModule } from '@angular/router/testing';

describe('QrViewPage', () => {
  let component: QrViewPage;
  let fixture: ComponentFixture<QrViewPage>;
  let router: Router;
  let translateService: TranslateService;
  let localStorageService: jasmine.SpyObj<LocalStorageService>;

  beforeEach(async () => {
    const localStorageSpy = jasmine.createSpyObj('LocalStorageService', ['getItem']);

    await TestBed.configureTestingModule({
      imports: [
        CommonModule,
        FormsModule,
        TranslateModule.forRoot(),
        RouterTestingModule.withRoutes([]),
        IonContent,
        IonLabel,
        IonText,
        QrViewPage
      ],
      declarations: [],
      providers: [
        { provide: LocalStorageService, useValue: localStorageSpy },
      ]
    }).compileComponents();

    fixture = TestBed.createComponent(QrViewPage);
    component = fixture.componentInstance;
    router = TestBed.inject(Router);
    translateService = TestBed.inject(TranslateService);
    localStorageService = TestBed.inject(LocalStorageService) as jasmine.SpyObj<LocalStorageService>;
  });

  it('should create the component', () => {
    expect(component).toBeTruthy();
  });

  it('should retrieve QR code from local storage', () => {
    localStorageService.getItem.and.returnValue('someBase64String');
    component.ngOnInit();
    expect(component.base64QrCode).toBe('data:image/png;base64,someBase64String');
  });

  it('should handle missing QR code in local storage', () => {
    localStorageService.getItem.and.returnValue(null);
    spyOn(console, 'error');
    component.ngOnInit();
    expect(console.error).toHaveBeenCalledWith('No QR code found in local storage.');
  });

  it('should retrieve customer name from local storage', () => {
    localStorageService.getItem.and.returnValue('John Doe');
    component.ngOnInit();
    expect(component.customerName).toBe('John Doe');
  });

  it('should default to "User" if customer name is not found', () => {
    localStorageService.getItem.and.returnValue(null);
    component.ngOnInit();
    expect(component.customerName).toBe('User');
  });

  it('should navigate to dashboard when navigateToDashboard is called', () => {
    spyOn(router, 'navigate');
    component.navigateToDashboard();
    expect(router.navigate).toHaveBeenCalledWith(['/dashboard']);
  });
});
