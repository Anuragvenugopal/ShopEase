# ShopEase 🛍️

ShopEase is a production-ready, feature-rich mini e-commerce application built using **Flutter**, **Firebase**, and **BLoC** state management. The app consists of a clean, responsive Storefront for customers and an Administrative Console for inventory and order management.

---

## 🚀 Getting Started

### Prerequisites

Ensure you have the following installed on your local environment:
* **Flutter SDK:** `^3.5.0` or higher
* **Dart SDK:** `^3.0.0` or higher
* **Java Development Kit (JDK):** Version 17 (required for Android builds)
* **Cocoapods:** (Optional, for iOS builds)

---

## 🛠️ Local Installation & Setup

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/Anuragvenugopal/ShopEase.git
   cd ShopEase
   ```

2. **Retrieve Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Generate DI & Injectables:**
   This project uses `get_it` and `injectable` for Dependency Injection. Generate the registration file:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Launch the Application:**
   ```bash
   flutter run
   ```

---

## 🔑 Default Credentials

### Admin Console Access
* **Email:** `admin@shopease.com`
* **Password:** `Admin@123`

---

## 🔥 Firebase Setup Guide

Follow these steps to connect your own Firebase instance:

### 1. Register Your App on Firebase
1. Open the [Firebase Console](https://console.firebase.google.com/).
2. Create a new project named **ShopEase**.
3. Enable the following services in your Firebase Console:
   * **Firebase Authentication:** Enable **Email/Password** sign-in method.
   * **Cloud Firestore:** Start in Test Mode or configure security rules.
   * **Firebase Storage:** Enable rules for hosting images.

### 2. Configure Platforms

#### Android Setup
1. Add an Android app inside your Firebase Project Settings.
2. Register the Package Name: `com.shopease.shopease`.
3. Download the `google-services.json` file.
4. Place it in the directory: `android/app/google-services.json`.

#### iOS Setup
1. Add an iOS app inside your Firebase Project Settings.
2. Register the Bundle ID: `com.shopease.shopease`.
3. Download the `GoogleService-Info.plist` file.
4. Place it in the directory: `ios/Runner/GoogleService-Info.plist`.

### 3. Initialize Firestore Collections
To populate your app with categories and products, initialize these collections:

* **`categories`** (Collection)
  * Document: *(Auto ID)*
    * `name`: `Electronics`
    * `subcategories`: `['Mobile Phones', 'Laptops']`
* **`products`** (Collection)
  * Document: *(Auto ID)*
    * `title`: `Premium Wireless Headset`
    * `description`: `Active Noise-Cancelling Headphones`
    * `price`: `149.99`
    * `category`: `Electronics`
    * `subcategory`: `Accessories`
    * `stock`: `15`
    * `sku`: `ELEC-WHEAD-001`
    * `barcode`: `880975871235`
    * `imageUrl`: `https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500`
    * `isActive`: `true`
    * `rating`: `4.5`
    * `reviewsCount`: `0`
    * `reviews`: `[]`

---

## 📂 Project Architecture

```
lib/
 ├── core/              # Theme, routes, dependencies injection, and reusable base widgets
 ├── data/              # Data models, API wrappers, and repository implementations
 ├── domain/            # Domain entities, value models, and repository interfaces
 ├── features/          # App features divided into Admin and User scopes
 │    ├── admin/        # Admin Dashboard, Inventory CRUD, Category CRUD, and Scanner
 │    └── user/         # Auth, Storefront, Details, Cart, Wishlist, Search, and Orders
 └── presentation/      # App BLoC layers mapping actions to UI states
```
