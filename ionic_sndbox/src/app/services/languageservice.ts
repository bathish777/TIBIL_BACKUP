// import { Injectable } from '@angular/core';

// import { StorageService } from 'src/app/services/storage.service';

// import { LangChangeEvent, TranslateService } from '@ngx-translate/core';
// import { Observable } from 'rxjs';

// @Injectable({
//   providedIn: 'root',
// })
// export class LanguageService {
//   defaultLanguage: string = 'en';
//   languageChange$: Observable<LangChangeEvent> = this.translateService.onLangChange;

//   constructor(private storageService: StorageService, private translateService: TranslateService) {}

//   getLanguage(): string {
//     return this.translateService.currentLang;
//   }

//   setDefaultLanguage(): void {
//     /* const defaultLanguage =
//       this.storageService.getFromStorage('local', StorageTokens.language) ??
//        this.defaultLanguage; */
//     const { defaultLanguage } = this;
//     this.translateService.setDefaultLang(defaultLanguage);
//     this.setLanguage(defaultLanguage);
//   }

//   setLanguage(language: string): void {
//     this.translateService.use(language);
//     this.storageService.setStorage('language', language);
//   }
// }