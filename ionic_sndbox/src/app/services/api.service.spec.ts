import { TestBed } from '@angular/core/testing';
import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';
import { ApiService } from './api.service';
import { environment } from 'src/environments/environment';

describe('ApiService', () => {
  let service: ApiService;
  let httpMock: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [HttpClientTestingModule],
      providers: [ApiService]
    });
    service = TestBed.inject(ApiService);
    httpMock = TestBed.inject(HttpTestingController);
  });

  afterEach(() => {
    httpMock.verify();
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  it('should send a ping request', () => {
    service.ping().subscribe(response => {
      expect(response).toBeTruthy();
    });

    const req = httpMock.expectOne(`${environment.SERVER_URL}/ping`);
    expect(req.request.method).toBe('GET');
    req.flush({});
  });

  it('should send a getUserInit request', () => {
    service.getUserInit().subscribe(response => {
      expect(response).toBeTruthy();
    });

    const req = httpMock.expectOne(`${environment.SERVER_URL}/user/init/get`);
    expect(req.request.method).toBe('POST');
    req.flush({});
  });

  it('should send a getTermsAndConditions request', () => {
    service.getTermsAndConditions().subscribe(response => {
      expect(response).toBeTruthy();
    });

    const req = httpMock.expectOne(`${environment.SERVER_URL}/user/tnc/get`);
    expect(req.request.method).toBe('POST');
    req.flush({});
  });

  it('should send a getUserDevices request', () => {
    const vmnCode = '12345';
    service.getUserDevices(vmnCode).subscribe(response => {
      expect(response).toBeTruthy();
    });

    const req = httpMock.expectOne(`${environment.SERVER_URL}/user/devices`);
    expect(req.request.method).toBe('POST');
    expect(req.request.body).toEqual({ vmn_code: vmnCode });
    req.flush({});
  });

  it('should send a getAccounts request', () => {
    const mobile = '1234567890';
    service.getAccounts(mobile).subscribe(response => {
      expect(response).toBeTruthy();
    });

    const req = httpMock.expectOne(`${environment.SERVER_URL}/user/accounts/get`);
    expect(req.request.method).toBe('POST');
    expect(req.request.body).toEqual({ mobile });
    req.flush({});
  });

  it('should send a getUpiQrCode request', () => {
    const mobile = '1234567890';
    service.getUpiQrCode(mobile).subscribe(response => {
      expect(response).toBeTruthy();
    });

    const req = httpMock.expectOne(`${environment.SERVER_URL}/user/account/upi/get`);
    expect(req.request.method).toBe('POST');
    expect(req.request.body).toEqual({ mobile });
    req.flush({});
  });

  it('should send a getOtp request', () => {
    const mobile = '1234567890';
    service.getOtp(mobile).subscribe(response => {
      expect(response).toBeTruthy();
    });

    const req = httpMock.expectOne(`${environment.SERVER_URL}/user/otp`);
    expect(req.request.method).toBe('POST');
    expect(req.request.body).toEqual({ mobile });
    req.flush({});
  });

  it('should send an updateOtp request', () => {
    const body = { otp: 123456, mobile_number: '1234567890', device_id: 'device123', identification: 'id123' };
    service.updateOtp(body).subscribe(response => {
      expect(response).toBeTruthy();
    });

    const req = httpMock.expectOne(`${environment.SERVER_URL}/user/otp`);
    expect(req.request.method).toBe('PATCH');
    expect(req.request.body).toEqual(body);
    req.flush({});
  });

  it('should send a getSecrets request', () => {
    const mobile_number = '1234567890';
    const mpin = '1234';
    service.getSecrets(mobile_number, mpin).subscribe(response => {
      expect(response).toBeTruthy();
    });

    const req = httpMock.expectOne(`${environment.SERVER_URL}/user/secrets`);
    expect(req.request.method).toBe('POST');
    expect(req.request.body).toEqual({ mobile_number, mpin });
    req.flush({});
  });

  it('should send an updatePreferences request', () => {
    service.updatePreferences().subscribe(response => {
      expect(response).toBeTruthy();
    });

    const req = httpMock.expectOne(`${environment.SERVER_URL}/user/preferences`);
    expect(req.request.method).toBe('PUT');
    req.flush({});
  });

  // it('should send a getAllPayments request', () => {
  //   const authToken = 'token123';
  //   const uuid = 'uuid123';
  //   const vpa = 'vpa123';
  //   const options = { fromDateTime: '2023-01-01', toDateTime: '2023-01-31', offset: 0, limit: 10, lastPid: 1 };
  //   service.getAllPayments(uuid, vpa, options).subscribe(response => {
  //     expect(response).toBeTruthy();
  //   });

  //   const req = httpMock.expectOne(`${environment.SERVER_URL}/payment/get`);
  //   expect(req.request.method).toBe('POST');
  //   expect(req.request.headers.get('Authorization')).toBe(`Bearer ${authToken}`);
  //   expect(req.request.body).toEqual({ uuid, vpa, date: jasmine.any(String), ...options });
  //   req.flush({});
  // });

  // it('should send a getPaymentSummary request', () => {
  //   const authToken = 'token123';
  //   const uuid = 'uuid123';
  //   const vpa = 'vpa123';
  //   const date = '2023-01-01';
  //   service.getPaymentSummary( uuid, vpa, date).subscribe(response => {
  //     expect(response).toBeTruthy();
  //   });

  //   const req = httpMock.expectOne(`${environment.SERVER_URL}/payment/summary/get`);
  //   expect(req.request.method).toBe('POST');
  //   expect(req.request.headers.get('Authorization')).toBe(`Bearer ${authToken}`);
  //   expect(req.request.body).toEqual({ uuid, vpa, date });
  //   req.flush({});
  // });
});