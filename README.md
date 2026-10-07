# Anime App

The Login and Register screens use Firebase Authentication with email and password.

## One-time Firebase setup

1. Create or select a project in the [Firebase console](https://console.firebase.google.com/).
2. In **Authentication → Sign-in method**, enable **Email/Password**.
3. Install the FlutterFire CLI and run this command from the project folder:

   ```powershell
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```

   Select the Firebase project and every platform that you intend to run. This creates `lib/firebase_options.dart` and adds platform configuration files such as `android/app/google-services.json`. The app is already set up to initialize Firebase with these generated options.
4. Run `flutter run` and register with an email address and password of at least six characters.

The app includes sign-in, new-account registration, password-reset emails, and sign-out. Do not commit Firebase service-account credentials; the mobile/web configuration files created by FlutterFire are the intended client configuration.

## Third-party sign-in setup

The login screen supports Google, Facebook, and GitHub. Enable each provider that you want to use in **Firebase Console → Authentication → Sign-in method**.

- **Google:** Enable Google, then add the Android app's SHA-1 fingerprint in Firebase project settings. This is required for Google login on Android.
- **Facebook:** Create a Facebook Login app, enter its App ID and App Secret in Firebase, and follow the `flutter_facebook_auth` Android/iOS setup guide to add the Facebook app ID and URL scheme. For web, add Firebase's OAuth redirect URL to the Facebook app's Valid OAuth Redirect URIs.
- **GitHub:** Create a GitHub OAuth App, paste its Client ID and Client Secret into Firebase, and use Firebase's displayed callback URL as the OAuth app's Authorization callback URL.

Each provider also needs the Firebase app configuration from `flutterfire configure`. A provider that is not enabled or fully configured will show its error instead of signing the user in.


## Per-account data (Cloud Firestore)

Home, Search and Profile read and write data under the signed-in account's
`uid`, so every account has its own favorites, posts, profile and recent
searches:

```
users/{uid}                  name, bio, avatar, recent searches
users/{uid}/favorites/{id}   favorited anime (doc id = anime id)
users/{uid}/posts/{id}       posts written by this account
```

One-time setup:

1. In the Firebase console open **Build -> Firestore Database -> Create database**.
2. Deploy the rules in `firestore.rules` (only the owner of `users/{uid}` can
   read or write it). Either paste them in **Firestore -> Rules**, or run
   `firebase deploy --only firestore:rules`.
3. Run `flutter pub get`.
