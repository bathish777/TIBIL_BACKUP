import { Component, EventEmitter, Output } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { TranslateModule, TranslateService } from '@ngx-translate/core';
import {
  IonFooter,
  IonTabBar,
  IonTabButton,
  IonLabel,
  IonIcon, IonContent, IonText, IonList, IonItem
} from '@ionic/angular/standalone';

import { NavigationEnd, Router } from '@angular/router';
import { CommonServiceService } from 'src/app/services/common-service.service';

@Component({
  selector: 'app-tab-bar',
  templateUrl: './tab-bar.component.html',
  styleUrls: ['./tab-bar.component.scss'],
  standalone: true,
  imports: [
    IonItem, IonList, IonText, IonContent, 
    IonFooter,
    IonTabBar,
    IonTabButton,
    IonLabel,
    IonIcon,
    CommonModule,
    FormsModule,
    TranslateModule,
  ],
})
export class TabBarComponent {
  @Output() tabChange: EventEmitter<string> = new EventEmitter();
  errorMessage: string = ''; 
  currentTab: string = 'dashboard'; // Default tab
  currentHeader: string = 'Dashboard'; // Default header text
  translate: any;
  constructor(private route:Router,public cs:CommonServiceService, private translateService: TranslateService){}
  

  ngOnInit(): void {
    this.route.events.subscribe((event) => {
      if (event instanceof NavigationEnd) {
        if (event.url === '/dashboard') {
          this.cs.selectedTab = 'dashboard'; // Set selectedTab to 'dashboard'
        }
      }
    });
    // Perform initialization logic here, if needed
    console.log('TabBarComponent initialized');
  }
  selectTab(tab: string): void {
  this.cs.selectedTab = tab;
  this.updateHeaderText(tab);
  this.route.navigate(['/' + tab], { replaceUrl: true }); // Use replaceUrl to avoid adding a new entry in the browser history
}

  public updateHeaderText(tab: string): void {
    const headerMap: { [key: string]: string } = {
      dashboard: 'Dashboard',
      transactions: 'Transactions',
      settings: 'Settings',
      'my-profile': 'My Profile',
    };

    this.currentHeader = headerMap[tab] || 'Dashboard'; // Fallback to Dashboard
  }

  changeLanguage(language: string) {
    this.translate.use(language);
  }

  getCurrentHeader(): string {
    return this.currentHeader;
  }
}              