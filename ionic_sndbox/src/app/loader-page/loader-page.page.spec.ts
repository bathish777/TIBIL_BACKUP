import { ComponentFixture, TestBed } from '@angular/core/testing';
import { LoaderPagePage } from './loader-page.page';
import { Router } from '@angular/router';
import { ApiService } from '../services/api.service';
import { of } from 'rxjs';

describe('LoaderPagePage', () => {
  let component: LoaderPagePage;
  let fixture: ComponentFixture<LoaderPagePage>;
  let routerSpy: jasmine.SpyObj<Router>;
  let apiServiceSpy: jasmine.SpyObj<ApiService>;

  beforeEach(async () => {
    routerSpy = jasmine.createSpyObj('Router', ['navigate']);
    apiServiceSpy = jasmine.createSpyObj('ApiService', ['someApiCallMethod']);

    await TestBed.configureTestingModule({
      imports: [LoaderPagePage], // ✅ Import standalone component instead of declaring it
      providers: [
        { provide: Router, useValue: routerSpy },
        { provide: ApiService, useValue: apiServiceSpy }
      ]
    }).compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(LoaderPagePage);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create the component', () => {
    expect(component).toBeTruthy();
  });

  it('should initially show the loader', () => {
    expect(component.showLoader).toBeTrue();
  });

  it('should hide the loader when hide() is called', () => {
    component.hide();
    expect(component.showLoader).toBeFalse();
  });

  it('should show the loader when show() is called', () => {
    component.hide(); // Hide first
    component.show(); // Then show
    expect(component.showLoader).toBeTrue();
  });
});
