import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { TranslateModule } from '@ngx-translate/core';
// import { sharedModules } from './../shared/shared.module';

import {
  IonContent,
  IonFooter, IonRouterOutlet, IonItem } from '@ionic/angular/standalone';
import { TabBarComponent } from '../shared/tab-bar/tab-bar.component';
import { SettingsMenuComponent } from "../settings-menu/settings-menu.component";

@Component({
  selector: 'app-settings',
  templateUrl: './settings.page.html',
  styleUrls: ['./settings.page.scss'],
  standalone: true,
  imports: [IonItem,
    IonRouterOutlet,
    IonContent,
    CommonModule,
    FormsModule,
    TranslateModule, // Import TranslateModule here
    TabBarComponent,
    IonFooter, 
    // sharedModules,
    SettingsMenuComponent],
})
export class SettingsComponent  {
  currentHeader: string = 'Settings';
  constructor() { }

  
}
