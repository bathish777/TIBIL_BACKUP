import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { TranslateService, TranslateModule } from '@ngx-translate/core';
import { IonHeader, IonToolbar, IonTitle, IonContent, IonButton, IonRadio, IonItem, IonLabel, IonRadioGroup } from '@ionic/angular/standalone';
import { ApiService } from '../services/api.service';
import { LocalStorageService } from '../services/local-storage.service'; // Import LocalStorageService

interface VPA {
  id: string;
  name: string;
}

@Component({
  selector: 'app-vpa-selection',
  templateUrl: './vpa-selection.page.html',
  styleUrls: ['./vpa-selection.page.scss'],
  standalone: true,
  imports: [
    IonRadio, IonLabel, IonItem, IonRadioGroup, IonButton, IonTitle, IonContent,
    IonHeader, IonToolbar, CommonModule, FormsModule, TranslateModule
  ],
})
export class VpaSelectionPage implements OnInit {
  vpas: VPA[] = [];
  errorMessage: string = '';
  selectedVpaId: string | null = null;
  mobile: string = '';
  customerName: string = '';
  customerVpa: string = '';
  base64QrCode: string | null = null;

  constructor(
    private apiService: ApiService,
    private router: Router,
    public translate: TranslateService,
    private localStorageService: LocalStorageService // Inject LocalStorageService
  ) { }

  async ngOnInit() {
    await this.getMobileNumberFromStorage();
    await this.fetchUpiQrCode();

    const storedQrCode = this.localStorageService.getItem('base64QrCode');
    if (storedQrCode) {
      this.base64QrCode = storedQrCode; // The full data URL with the base64 encoded image
    } else {
      console.error('QR code not found in localStorage.');
    }
  }

  // Get Mobile Number from LocalStorage using LocalStorageService
  // getMobileNumberFromStorage() {
  //   const userDevices = JSON.parse(this.localStorageService.getItem('userDevices') || '{}');
  //   console.log('Retrieved userDevices from localStorage:', userDevices);
  //   if (userDevices?.mobile_number) {
  //     this.mobile = userDevices.mobile_number;
  //     console.log('Retrieved mobile number:', this.mobile);
  //   } else {
  //     this.errorMessage = 'No valid mobile number found in user devices.';
  //     console.error(this.errorMessage);
  //   }
  // }

  getMobileNumberFromStorage() {
    try {
      const userDevices = JSON.parse(this.localStorageService.getItem('userDevices') || '{}');
      console.log('Retrieved userDevices from localStorage:', userDevices);
  
      if (userDevices?.mobile_number) {
        this.mobile = userDevices.mobile_number;
        console.log('Retrieved mobile number:', this.mobile);
      } else {
        this.errorMessage = 'No valid mobile number found in user devices.';
        console.error(this.errorMessage);
      }
    } catch (error) {
      console.error('Error parsing userDevices from localStorage:', error);
      this.errorMessage = 'Invalid data in storage.';
    }
  }
  
  fetchUpiQrCode() {
    if (!this.mobile) {
      this.errorMessage = 'Mobile number is required to fetch the UPI QR code.';
      return;
    }
  
    console.log('Requesting UPI QR code for mobile number:', this.mobile);
  
    this.apiService.getUpiQrCode(this.mobile).subscribe(
      (response: any) => {
        console.log('API Response:', response);
        if (response.code === 2000) {
          // Assuming response.data contains an array of VPAs
          this.vpas = response.data.map((upiData: any) => ({
            id: upiData.customer_vpa,
            name: upiData.customer_name || 'Unknown',
          }));
  
          // If you want to set the first item as selected by default
          if (this.vpas.length > 0) {
            this.selectedVpaId = this.vpas[0].id;
          }
  
          // Store the first VPA details in localStorage (if needed)
          this.customerName = this.vpas[0]?.name || 'Unknown';
          this.customerVpa = this.vpas[0]?.id || 'Unavailable';
          this.base64QrCode = response.data[0].base64Qrcode || null;
  
          this.localStorageService.setItem('customerVpa', this.customerVpa);
          if (this.base64QrCode) {
            this.localStorageService.setItem('base64QrCode', `data:image/png;base64,${this.base64QrCode}`);
            this.localStorageService.setItem('customerName', this.customerName);
          }
        } else {
          this.errorMessage = response.message || 'Failed to fetch UPI QR code.';
        }
      },
      (error) => {
        console.error('Error fetching UPI QR code:', error);
        this.errorMessage = 'Error fetching UPI QR code. Please try again.';
      }
    );
  }
  

  changeLanguage(language: string) {
    this.translate.use(language);
  }

  
  onVpaSelected(vpaId: string) {
    this.selectedVpaId = vpaId;
    
    // Find the selected VPA object
    const selectedVpa = this.vpas.find(vpa => vpa.id === vpaId);
    const selectedVpaName = selectedVpa ? selectedVpa.name : 'Unknown';
  
    // Store the selected VPA details in local storage
    this.localStorageService.setItem('customerVpa', vpaId);
    this.localStorageService.setItem('customerName', selectedVpaName);
  
    console.log(`Stored VPA ID: ${vpaId} with Name: ${selectedVpaName}`);
  }
  
  navigateToVerification() {
    if (this.selectedVpaId) {
      this.router.navigate(['/verification'], {
        queryParams: { vpaId: this.selectedVpaId },
      });
    } else {
      this.errorMessage = 'Please select a VPA before proceeding.';
    }
  }
}
