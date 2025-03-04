import { Routes } from '@angular/router';

export const routes: Routes = [
  {
    path: '',
    redirectTo: 'splash-screen',
    pathMatch: 'full',
  },
  {
    path: 'splash-screen',
    loadComponent: () => import('./splash-screen/splash-screen.component').then((m) => m.SplashScreenComponent),
  },
  {
    path: 'home',
    loadComponent: () => import('./home/home.page').then((m) => m.HomePage),
  },
  {
    path: 'account-selection',
    loadComponent: () => import('./account-selection/account-selection.page').then((m) => m.AccountSelectionPage),
  },
  {
    path: 'vpa-selection',
    loadComponent: () => import('./vpa-selection/vpa-selection.page').then((m) => m.VpaSelectionPage),
  },
  {
    path: 'verification',
    loadComponent: () => import('./verification/verification.page').then((m) => m.VerificationPage),
  },
  {
    path: 'mpin-create',
    loadComponent: () => import('./mpin-create/mpin-create.page').then((m) => m.MpinCreatePage),
  },
  {
    path: 'verify-mpin',
    loadComponent: () => import('./verify-mpin/verify-mpin.page').then((m) => m.VerifyMpinPage),
  },
  {
    path: 'qr-view',
    loadComponent: () => import('./qr-view/qr-view.page').then(m => m.QrViewPage),
  },
  {
    path: 'dashboard',
    loadComponent: () => import('./dashboard/dashboard.page').then(m => m.DashboardPage),
  },
  {
    path: 'transactions',
    loadComponent: () => import('./transactions/transactions.page').then(m => m.TransactionsComponent),
  },
  {
    path: 'settings',
    loadComponent: () => import('./settings/settings.page').then((m) => m.SettingsComponent),
    loadChildren: () => [
      {
        path: 'settings-menu',
        loadComponent: () => import('./settings-menu/settings-menu.component').then(m => m.SettingsMenuComponent),
      },
      {
        path: 'my-profile',
        loadComponent: () => import('./my-profile/my-profile.page').then(m => m.ProfilePage),
      },
      {
        path: 'my-qr-code',
        loadComponent: () => import('./my-qr-code/my-qr-code.page').then(m => m.MyQrCodePage),
      },
      {
        path: 'language-preference',
        loadComponent: () => import('./language-preference/language-preference.page').then(m => m.LanguagePreferencePage),
      },
      {
        path: '',
        redirectTo: 'settings-menu',
        pathMatch: 'full',
      },
    ]
  },
    {
    path: 'loader-page',
    loadComponent: () => import('./loader-page/loader-page.page').then(m => m.LoaderPagePage),
  },
  

  {
    path: 'loader-page',
    loadComponent: () => import('./loader-page/loader-page.page').then(m => m.LoaderPagePage),
  },
  {
    path: 'forgot-mpin',
    loadComponent: () => import('./forgot-mpin/forgot-mpin.page').then((m) => m.ForgotMpinPage),
  },
  {
    path: 'create-new-login-pin',
    loadComponent: () => import('./create-new-login-pin/create-new-login-pin.page').then(m => m.CreateNewLoginPage),
  },
  {
    path: 'verify-new-login-pin',
    loadComponent: () => import('./verify-new-login-pin/verify-new-login-pin.page').then(m => m.VerifyNewLoginPage),
  },
  
];
