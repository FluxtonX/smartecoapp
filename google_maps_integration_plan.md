# Google Maps SDK Integration Plan

## Overview
This plan outlines the integration of the `google_maps_flutter` package into the SmartEco Flutter application, replacing static UI placeholders with live interactive maps on the pickup scheduling and tracking screens.

## Step 1: Install Dependency
Add the `google_maps_flutter` package to the project via `pubspec.yaml` (Completed).

## Step 2: Configure Android Setup
Modify `android/app/src/main/AndroidManifest.xml` by inserting the Google Maps API Key meta-data within the `<application>` tag.
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
```

## Step 3: Configure iOS Setup
Modify `ios/Runner/AppDelegate.swift` to import `GoogleMaps` and initialize it with the API key inside `application(_:didFinishLaunchingWithOptions:)`.
```swift
import GoogleMaps
...
GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
```

## Step 4: Implement `GoogleMap` in Flutter Views
Update UI files currently holding generic containers:
1. **`lib/views/schedule_pickup/schedule_pickup_screen.dart`**
   - Replace the `Container` placeholder showing the grey `Icons.map` with `GoogleMap()`.
   - Setup a default `initialCameraPosition` pointing to Kigali, Rwanda.
   - Use mock coordinates: LatLng(-1.9441, 30.0619).

2. **`lib/views/pickup_scheduling/pickup_scheduling_screen.dart`**
   - In `_buildAddressSelection()`, replace `CustomPaint(_MapGridPainter())` + Map Icon with `GoogleMap()`.
   - Setup a default `initialCameraPosition` for Kigali.

## Step 5: Testing
- After applying the API Key, ensure maps load correctly on both the iOS Simulator / Android Emulator.
- Verify basic touch inputs (pan, zoom) work correctly without causing layout overflows.
