# ShopEase - Machine Test Submission

ShopEase is a Flutter mini e-commerce application built for a technical machine test. It uses Firebase for back-end services and BLoC for clean state management.

---

## Features Implemented

### User Module
* Authentication (Sign In, Sign Up, Sign Out, Forgot Password)
* Storefront Home Screen (Sliders, Categories, Trending products)
* Product Details Screen (Reviews, specs, Stock indicators, Add to Cart/Wishlist)
* Shopping Cart & Checkout Flow (Calculates totals and place order)
* Wishlist (Add, remove, and move-to-cart shortcuts)
* Dynamic Catalog Search (Search by name, SKU, or barcode)

### Admin Module
* Secure Admin Login (Using designated admin account)
* Analytics Dashboard (Displays total products, users, pending orders, and low-stock items)
* Inventory CRUD (Add, Edit, and Delete products with active/inactive toggles)
* Barcode & QR Stock Scanner (Camera-based stock lookup and addition)
* Manual SKU Stock Search (Backup stock replenishment without camera)
* Auto SKU/Barcode Generator (Creates unique codes for new items)
* Category Management (Create/Edit categories and add subcategories)
* Registered Users Directory (Segments admins and customer listings in full screen)
* Order Management (View and update order delivery statuses)

### Extra Capabilities
* Firestore Query Pagination (Loads products in pages of 10 items)
* Bottom Scroll Loading Spinner (Circular progress indicator on pagination)
* Pull-to-Refresh (On storefront and inventory lists)
* System Brightness Adaptive Dark Mode
* Reusable widgets, validation inputs, and responsive layouts

---

## Tech Stack
* State Management: BLoC (Flutter BLoC package)
* Dependency Injection: Get It & Injectable
* Backend: Firebase Auth, Cloud Firestore, Firebase Storage
* Scanner: Mobile Scanner

---

## Running the Project Locally

Follow these steps to run the application on your local machine:

1. Clone the project:
   ```bash
   git clone https://github.com/Anuragvenugopal/ShopEase.git
   cd ShopEase
   ```

2. Download the dependencies:
   ```bash
   flutter pub get
   ```

3. Run code generation for dependency injection:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. Launch the application:
   ```bash
   flutter run
   ```

---

## Admin Credentials

Use these details to access the administrative dashboard:
* Email: admin@shopease.com
* Password: Admin@123

---

## Firebase Configuration

To link your own Firebase database instance to this project:

1. Create a Firebase project in your Firebase Console.
2. Enable these services in your console:
   * Authentication: Turn on Email/Password sign-in.
   * Cloud Firestore: Create database in test mode.
   * Firebase Storage: Create default storage bucket.
3. Register your app client on Firebase with package name `com.shopease.shopease`.
4. Download the platform settings files and save them to:
   * Android: `android/app/google-services.json`
   * iOS: `ios/Runner/GoogleService-Info.plist`
