import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { Location } from '@angular/common'; // Import Location for back navigation
import { CommonModule } from '@angular/common';

import { FormsModule } from '@angular/forms';
import { TranslateService, TranslateModule } from '@ngx-translate/core';
import {
  IonContent,
  IonLabel,
  IonList,
  IonItem,
  IonRadio,
  IonRadioGroup,
} from '@ionic/angular/standalone';

@Component({
  selector: 'app-language-preference',
  templateUrl: './language-preference.page.html',
  styleUrls: ['./language-preference.page.scss'],
  standalone: true,
  imports: [
    IonItem,
    IonList,
    CommonModule,
    FormsModule,
    IonContent,
    IonLabel,
    IonRadio,
    IonRadioGroup,
    TranslateModule
],
})
export class LanguagePreferencePage {
  currentTab: string = 'language-preference'; // Default tab (Language Preference Tab)
  currentHeader: string = '< Language Preference'; // Default header text for language preference page
  selectedLanguage: string = 'english'; // Default selected language

  // Define languageMap as a class-level property
  private languageMap: { [key: string]: string } = {
    english: 'en',
    hindi: 'hi',
    kannada: 'kn',
  };

  constructor(private router: Router, private location: Location, private translate: TranslateService) {}

  switchLanguage(language: string): void {
    const langCode = this.languageMap[language] || 'en'; // Default to English if not found
    this.selectedLanguage = language; // Update the selected language
    console.log(`Language switched to: ${langCode}`);

    // Store the selected language in local storage
    localStorage.setItem('selectedLanguage', langCode);

    // Use TranslateService to update the app's language
    this.translate.use(langCode);
  }

  ngOnInit(): void {
    // Load the selected language from local storage
    const savedLanguage = localStorage.getItem('selectedLanguage') || 'en';

    // Find the corresponding language key in the languageMap
    this.selectedLanguage = Object.keys(this.languageMap).find(
      (key) => this.languageMap[key] === savedLanguage
    ) || 'english';

    // Use TranslateService to apply the saved language
    this.translate.use(savedLanguage);
  }

  goBack(): void {
    this.router.navigate(['settings']);
  }

  navigateBack(): void {
    this.location.back(); // Go back to the previous page
  }
}
