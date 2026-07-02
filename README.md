# ShopEase

ShopEase is a mini e-commerce application built using Flutter, Firebase, and BLoC. It includes a storefront for customers and a management dashboard for admins.

---

## Getting Started

### Prerequisites

Make sure you have these installed:
* Flutter SDK (version 3.5.0 or higher)
* Dart SDK (version 3.0.0 or higher)
* JDK 17 (for Android)

---

## Installation and Setup

Follow these simple steps to run the app locally:

1. Clone the repository:
   ```bash
   git clone https://github.com/Anuragvenugopal/ShopEase.git
   cd ShopEase
   ```

2. Get project dependencies:
   ```bash
   flutter pub get
   ```

3. Generate the dependency injection files:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. Run the application:
   ```bash
   flutter run
   ```

---

## Default Login Credentials

Use these details to access the admin features in the app:

* Email: admin@shopease.com
* Password: Admin@123

---

## Firebase Configuration Guide

Follow these steps to connect the app to your own Firebase project:

### 1. Enable Firebase Services
Go to the Firebase Console, create a new project, and enable these services:
* Authentication: Enable the Email/Password sign-in provider.
* Cloud Firestore: Enable Firestore Database.
* Storage: Enable Firebase Storage to save images.

### 2. Add Platform Config Files

* For Android:
  1. Add an Android app in your Firebase project settings using package name: com.shopease.shopease
  2. Download the google-services.json file.
  3. Save it to: android/app/google-services.json

* For iOS:
  1. Add an iOS app in your Firebase project settings using bundle ID: com.shopease.shopease
  2. Download the GoogleService-Info.plist file.
  3. Save it to: ios/Runner/GoogleService-Info.plist

### 3. Setup Firestore Collections
Add these basic collections to start:

* categories Collection:
  * Add a document with field: name (String) and subcategories (Array of Strings).

* products Collection:
  * Add a document with fields: title, description, price, category, subcategory, stock, sku, barcode, imageUrl, isActive, rating, reviewsCount, reviews.

---

## Project Structure

* lib/core: App theme, routing setup, and shared widgets.
* lib/data: API callers, models, and repository implementations.
* lib/domain: Entities and repository interface contracts.
* lib/features: App pages divided into admin and user folders.
* lib/presentation: BLoC logic for state management.
