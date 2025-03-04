import { TestBed, discardPeriodicTasks, fakeAsync, tick } from '@angular/core/testing';
import { NotificationHandlerService } from './notification-handler.service';
import { ApiService } from './api.service';
import { FcmService } from './fcm.service';
import { of, throwError } from 'rxjs';

describe('NotificationHandlerService', () => {
  let service: NotificationHandlerService;
  let apiServiceSpy: jasmine.SpyObj<ApiService>;
  let fcmServiceSpy: jasmine.SpyObj<FcmService>;

  beforeEach(() => {
    const apiSpy = jasmine.createSpyObj('ApiService', ['getAllPayments']);
    const fcmSpy = jasmine.createSpyObj('FcmService', ['showNotification', 'announceUpdate']);

    TestBed.configureTestingModule({
      providers: [
        NotificationHandlerService,
        { provide: ApiService, useValue: apiSpy },
        { provide: FcmService, useValue: fcmSpy },
      ],
    });

    service = TestBed.inject(NotificationHandlerService);
    apiServiceSpy = TestBed.inject(ApiService) as jasmine.SpyObj<ApiService>;
    fcmServiceSpy = TestBed.inject(FcmService) as jasmine.SpyObj<FcmService>;
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  it('should start polling', fakeAsync(() => {
    spyOn(service as any, 'checkForNewPayments');
    service.startPolling();
  
    tick(30000); // Simulate 30 seconds passing
    expect((service as any).checkForNewPayments).toHaveBeenCalled();
  
    discardPeriodicTasks(); // Cleans up the pending interval timer
  }));
  

  it('should process new payments and trigger notifications', fakeAsync(async () => {
    localStorage.setItem('lastPaymentId', '0');
    const payments = [{ pid: 1, amount: 100 }, { pid: 2, amount: 200 }];
    apiServiceSpy.getAllPayments.and.returnValue(of({ code: 2000, data: { payments } }));
    fcmServiceSpy.showNotification.and.returnValue(Promise.resolve());
    fcmServiceSpy.announceUpdate.and.returnValue(Promise.resolve());

    await (service as any).checkForNewPayments();

    expect(fcmServiceSpy.showNotification).toHaveBeenCalledTimes(2);
    expect(fcmServiceSpy.announceUpdate).toHaveBeenCalledTimes(2);
    expect(localStorage.getItem('lastPaymentId')).toBe('2');
  }));

  it('should handle API errors gracefully', fakeAsync(async () => {
    apiServiceSpy.getAllPayments.and.returnValue(throwError(() => new Error('API Error')));
    spyOn(console, 'error');

    await (service as any).checkForNewPayments();

    expect(console.error).toHaveBeenCalledWith('Error checking for new payments:', jasmine.any(Error));
  }));

  it('should not process already processed payments', fakeAsync(async () => {
    localStorage.setItem('lastPaymentId', '1');
    const payments = [{ pid: 1, amount: 100 }, { pid: 2, amount: 200 }];
    apiServiceSpy.getAllPayments.and.returnValue(of({ code: 2000, data: { payments } }));
    fcmServiceSpy.showNotification.and.returnValue(Promise.resolve());
    fcmServiceSpy.announceUpdate.and.returnValue(Promise.resolve());

    await (service as any).checkForNewPayments();

    expect(fcmServiceSpy.showNotification).toHaveBeenCalledTimes(1);
    expect(fcmServiceSpy.announceUpdate).toHaveBeenCalledTimes(1);
    expect(localStorage.getItem('lastPaymentId')).toBe('2');
  }));
});
