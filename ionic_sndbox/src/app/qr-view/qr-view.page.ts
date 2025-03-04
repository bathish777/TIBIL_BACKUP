import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { TranslateService, TranslateModule } from '@ngx-translate/core';
import {
  IonContent,
  IonLabel,
  IonText,
} from '@ionic/angular/standalone';
import { LocalStorageService } from '../services/local-storage.service';

@Component({
  selector: 'app-qr-view',
  templateUrl: './qr-view.page.html',
  styleUrls: ['./qr-view.page.scss'],
  standalone: true,
  imports: [
    IonContent,
    IonLabel,
    IonText,
    CommonModule,
    TranslateModule,
    FormsModule,
  ],
})
export class QrViewPage implements OnInit {
  base64QrCode: string | null = null;
  customerName: string | null = null;

  constructor(
    private router: Router,
    private translate: TranslateService,
    private localStorageService: LocalStorageService
  ) {}

  ngOnInit() {
    const storedQrCode = this.localStorageService.getItem('base64QrCode');
    if (storedQrCode) {
      this.base64QrCode = storedQrCode.startsWith('data:image/png;base64,')
        ? storedQrCode
        : `data:image/png;base64,${storedQrCode}`;
    } else {
      console.error('No QR code found in local storage.');
    }

    this.customerName = this.localStorageService.getItem('customerName') || 'User';
  }
  changeLanguage(language: string) {
    this.translate.use(language);
  }
  // Navigate to the dashboard (normal navigation)
  navigateToDashboard() {
    this.router.navigate(['/dashboard']);
  }

  // Cancel and replace the current page with the dashboard
  cancelAndShowDashboard() {
    this.router.navigate(['/dashboard'], { replaceUrl: true });
  }
}