import { ComponentFixture, TestBed } from '@angular/core/testing';
import { TabBarComponent } from './tab-bar.component';
import { Router } from '@angular/router';
import { CommonServiceService } from 'src/app/services/common-service.service';
import { TranslateService } from '@ngx-translate/core';
import { of } from 'rxjs';
import { FormsModule } from '@angular/forms';
import { IonicModule } from '@ionic/angular';
import { CommonModule } from '@angular/common';

describe('TabBarComponent', () => {
  let component: TabBarComponent;
  let fixture: ComponentFixture<TabBarComponent>;
  let router: jasmine.SpyObj<Router>;
  let commonService: jasmine.SpyObj<CommonServiceService>;
  let translate: jasmine.SpyObj<TranslateService>;

  beforeEach(async () => {
    const routerSpy = jasmine.createSpyObj('Router', ['navigate']);
    const commonServiceSpy = jasmine.createSpyObj('CommonServiceService', ['selectedTab']);
    const translateSpy = jasmine.createSpyObj('TranslateService', ['use']);

    await TestBed.configureTestingModule({
      declarations: [],
      imports: [IonicModule.forRoot(), FormsModule, CommonModule,TabBarComponent],
      providers: [
        { provide: Router, useValue: routerSpy },
        { provide: CommonServiceService, useValue: commonServiceSpy },
        { provide: TranslateService, useValue: translateSpy },
      ],
    }).compileComponents();

    fixture = TestBed.createComponent(TabBarComponent);
    component = fixture.componentInstance;
    router = TestBed.inject(Router) as jasmine.SpyObj<Router>;
    commonService = TestBed.inject(CommonServiceService) as jasmine.SpyObj<CommonServiceService>;
    translate = TestBed.inject(TranslateService) as jasmine.SpyObj<TranslateService>;
  });

  it('should create the component', () => {
    expect(component).toBeTruthy();
  });

  it('should fetch the default header text on initialization', () => {
    expect(component.currentTab).toBe('dashboard');
    expect(component.currentHeader).toBe('Dashboard');
  });

  it('should select a tab and update the header text and navigate to the tab', () => {
    const tab = 'transactions';
    component.selectTab(tab);

    expect(commonService.selectedTab).toBe(tab);
    expect(component.currentHeader).toBe('Transactions');
    expect(router.navigate).toHaveBeenCalledWith(['/' + tab], { replaceUrl: true });
  });

  // it('should handle invalid tab selection and set an error message', () => {
  //   component.selectTab('');
  //   expect(component.errorMessage).toBe('Please select a valid tab.');
  // });

  it('should update header text correctly for different tabs', () => {
    component.updateHeaderText('transactions');
    expect(component.currentHeader).toBe('Transactions');

    component.updateHeaderText('settings');
    expect(component.currentHeader).toBe('Settings');

    component.updateHeaderText('unknown');
    expect(component.currentHeader).toBe('Dashboard');
  });

  // it('should call changeLanguage and change language', () => {
  //   component.changeLanguage('fr');
  //   expect(translate.use).toHaveBeenCalledWith('fr');
  // });

  it('should return the current header when getCurrentHeader is called', () => {
    expect(component.getCurrentHeader()).toBe(component.currentHeader);
  });
});
