import { importProvidersFrom } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IonicModule } from '@ionic/angular';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { TabBarComponent } from './tab-bar/tab-bar.component';

// Example reusable components

export const sharedModules = [
  CommonModule,
  IonicModule,
  FormsModule,
  ReactiveFormsModule,
  
];

export const sharedComponents = [
    TabBarComponent
  
];

export const sharedProviders = [
  importProvidersFrom(...sharedModules),
];