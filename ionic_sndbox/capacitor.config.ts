import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.soundbox.app', // Unique App Identifier
  appName: 'Mobile Soundbox', // App Name
  webDir: 'www', // Build Output Directory
  plugins: {
    SplashScreen: {
      launchShowDuration: 3000, // Duration for splash screen display
      showSpinner: false, // Disable spinner on splash screen
      androidSpinnerStyle: 'large', // Android spinner style
      iosSpinnerStyle: 'small', // iOS spinner style
      splashFullScreen: true, // Enable fullscreen splash
      splashImmersive: true, // Enable immersive splash mode
    },
    PushNotifications: {
      presentationOptions: ["badge", "sound", "alert"],
    },
  },
};

export default config;
