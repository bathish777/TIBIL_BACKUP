/* eslint-disable @angular-eslint/component-class-suffix */
/* eslint-disable @typescript-eslint/no-unused-vars */
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { Share } from '@capacitor/share';
import { Filesystem, Directory } from '@capacitor/filesystem';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { IonContent, IonText, IonButton, IonImg, IonLabel } from '@ionic/angular/standalone';
import { TranslateService, TranslateModule } from '@ngx-translate/core';
import { LocalStorageService } from '../services/local-storage.service';

@Component({
  selector: 'app-my-qr-code',
  templateUrl: './my-qr-code.page.html',
  styleUrls: ['./my-qr-code.page.scss'],
  standalone: true,
  imports: [IonLabel, IonImg,
    CommonModule,
    FormsModule,
    IonContent,
    IonText,
    IonButton,
    TranslateModule],
})
export class MyQrCodePage implements OnInit {
  currentTab: string = 'qr-code';
  currentHeader: string = '<    My QR Code';
  base64QrCode: string | null = null;
  mobileNumber: string | null = null;
  customerName: string | null = null;
  fullDate: string = new Date().toLocaleDateString('en-GB', {
    weekday: 'long',
    day: '2-digit',
    month: 'short',
    year: 'numeric',
  });
  showNotification: boolean = true;

  constructor(
    private router: Router,
    private translate: TranslateService,
    private localStorageService: LocalStorageService
  ) {}

  ngOnInit(): void {
    this.base64QrCode = this.localStorageService.getItem('base64QrCode');
    if (this.base64QrCode && !this.base64QrCode.startsWith('data:image/png;base64,')) {
      this.base64QrCode = `data:image/png;base64,${this.base64QrCode}`;
    }

    this.mobileNumber = this.localStorageService.getItem('mobileNumber');
    this.customerName = this.localStorageService.getItem('customerName');
  }

  changeLanguage(language: string) {
    this.translate.use(language);
  }

  async shareQrCode(): Promise<void> {
    if (this.base64QrCode) {
      try {
        const base64Data = this.base64QrCode.split(',')[1];
        const filePath = await this.saveQrCodeFile(base64Data);

        if (filePath) {
          await Share.share({
            title: 'My QR Code',
            text: 'Check out my QR Code!',
            files: [filePath],
            dialogTitle: 'Share QR Code',
          });
        }
      } catch (error) {
        console.error('Error sharing QR code:', error);
      }
    } else {
      console.error('No QR code available to share.');
    }
  }

  goBack(): void {
    this.router.navigate(['settings']);
  }

  private async saveQrCodeFile(base64Data: string): Promise<string | null> {
    const fileName = `qr-code-${new Date().getTime()}.png`;
    try {
      await Filesystem.writeFile({
        path: `Download/${fileName}`,
        data: base64Data,
        directory: Directory.ExternalStorage,
      });

      const fileUri = await Filesystem.getUri({
        path: `Download/${fileName}`,
        directory: Directory.ExternalStorage,
      });
      return fileUri.uri;
    } catch (error) {
      console.error('Error saving file:', error);
      return null;
    }
  }

  dismissNotification(): void {
    this.showNotification = false;
  }
}
