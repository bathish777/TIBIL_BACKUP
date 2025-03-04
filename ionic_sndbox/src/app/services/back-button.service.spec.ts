import { TestBed } from '@angular/core/testing';
import { BackButtonService } from './back-button.service';
import { Platform } from '@ionic/angular';
import { Subscription } from 'rxjs';

describe('BackButtonService', () => {
  let service: BackButtonService;
  let platformSpy: jasmine.SpyObj<Platform>;
  let backButtonSubscriptionSpy: jasmine.SpyObj<Subscription>;

  beforeEach(() => {
    backButtonSubscriptionSpy = jasmine.createSpyObj('Subscription', ['unsubscribe']);
    platformSpy = jasmine.createSpyObj('Platform', [], { 
      backButton: { subscribeWithPriority: jasmine.createSpy().and.returnValue(backButtonSubscriptionSpy) } 
    });

    TestBed.configureTestingModule({
      providers: [
        BackButtonService,
        { provide: Platform, useValue: platformSpy },
      ],
    });

    service = TestBed.inject(BackButtonService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  it('should disable the back button', () => {
    service.disableBackButton();
    expect(platformSpy.backButton.subscribeWithPriority).toHaveBeenCalledWith(9999, jasmine.any(Function));
  });

  it('should enable the back button', () => {
    service.disableBackButton(); // First disable it
    service.enableBackButton(); // Then enable it

    expect(backButtonSubscriptionSpy.unsubscribe).toHaveBeenCalled();
    expect(service['backButtonSubscription']).toBeNull();
  });

  it('should not throw error if enabling back button when no subscription exists', () => {
    expect(() => service.enableBackButton()).not.toThrow();
  });
});
