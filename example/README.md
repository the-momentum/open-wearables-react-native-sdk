# Example App

This is a minimal Expo application demonstrating how to use the open-wearables React Native SDK.

The app shows how to:

- Request HealthKit permissions
- Configure the SDK
- Authenticate a user
- Start background health data synchronization
- Manual health data synchronization
- Listen for SDK events

---

# Requirements

- Node.js 18+
- Xcode 15+
- iOS 15.1+
- Expo CLI

---

# iOS Bundle Identifier

The example project contains a default `bundleIdentifier` that may already be registered on another Apple Developer account.  
If you encounter a signing error when building the project, update the bundle identifier to a unique value.

You can change it in: example/app.json → "expo" → "ios" → "bundleIdentifier".

Then regenerate the native project (from the /example directory):

```sh
npx expo prebuild --clean
```

---

# Running the example

1. Install SDK dependencies from the repository root:

```sh
npm install
```

2. Install example app dependencies:

```sh
cd example
npm install
```

The example imports the SDK directly from the local repository so changes to the SDK can be tested immediately.

3. Run the app:

### iOS

```sh
npx expo run:ios
```

The app will launch in the iOS simulator or on a connected device.

### Android (testing with Maven Local)

Prerequisite: the Expo native project must already be generated.

```sh
npx expo prebuild
```

Steps to test the Android SDK using `mavenLocal`:

1. Clone the Android SDK repository:

```sh
git clone https://github.com/the-momentum/open_wearables_android_sdk
cd open_wearables_android_sdk
```

2. From the root of that repository, publish the SDK to Maven Local:

```sh
git checkout v0.11.1
./gradlew publishToMavenLocal
```

3. In this example project, add `mavenLocal()` under `allprojects` → `repositories` (it must be first!) in:

```
example/android/build.gradle
```

Example:

```gradle
allprojects {
  repositories {
    mavenLocal()
    ...
  }
}
```

Run the Android app (from the /example directory):

```sh
npx expo run:android
```
