/* eslint-disable no-undef */
import { TestBed } from '@angular/core/testing';
import { LanguagePreferencePage } from './language-preference.page';
import { Router } from '@angular/router';
import { Location } from '@angular/common';
import { TranslateService } from '@ngx-translate/core';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { IonicModule } from '@ionic/angular';

describe('LanguagePreferencePage', () => {
  let component: LanguagePreferencePage;
  let routerSpy: jasmine.SpyObj<Router>;
  let locationSpy: jasmine.SpyObj<Location>;
  let translateSpy: jasmine.SpyObj<TranslateService>;

  beforeEach(async () => {
    routerSpy = jasmine.createSpyObj('Router', ['navigate']);
    locationSpy = jasmine.createSpyObj('Location', ['back']);
    translateSpy = jasmine.createSpyObj('TranslateService', ['use']);

    await TestBed.configureTestingModule({
      imports: [LanguagePreferencePage, FormsModule, CommonModule, IonicModule], // Importing instead of declaring
      providers: [
        { provide: Router, useValue: routerSpy },
        { provide: Location, useValue: locationSpy },
        { provide: TranslateService, useValue: translateSpy },
      ],
    }).compileComponents();

    const fixture = TestBed.createComponent(LanguagePreferencePage);
    component = fixture.componentInstance;
  });

  it('should create the component', () => {
    expect(component).toBeTruthy();
  });

  it('should initialize with default language or saved language', () => {
    spyOn(localStorage, 'getItem').and.returnValue('hi');
    component.ngOnInit();
    expect(component.selectedLanguage).toBe('hindi');
    expect(translateSpy.use).toHaveBeenCalledWith('hi');
  });

  it('should switch language and update TranslateService', () => {
    spyOn(localStorage, 'setItem');
    component.switchLanguage('kannada');
    expect(component.selectedLanguage).toBe('kannada');
    expect(localStorage.setItem).toHaveBeenCalledWith('selectedLanguage', 'kn');
    expect(translateSpy.use).toHaveBeenCalledWith('kn');
  });

  it('should navigate back to settings page', () => {
    component.goBack();
    expect(routerSpy.navigate).toHaveBeenCalledWith(['settings']);
  });

  it('should go back using location service', () => {
    component.navigateBack();
    expect(locationSpy.back).toHaveBeenCalled();
  });
});
