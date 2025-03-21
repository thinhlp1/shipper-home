# Shipper Home

<p align="center">
  <img src="/assets/shipper_home.png" alt="App Icon" width="250">
</p>


Shipper Home is a mobile app designed for shippers to manage their customers efficiently. It can help you remember all your customers, their phone numbers, names, addresses, google map locations, their hobbies and even their pictures.

## ✨ Features

- **Manage Customers**: Manage a list of customers: CRUD, mark as favorites, change postion.
- **Call**: Call customers with number phone, don't need find in phonebook.
- **Connect to Google Map**: Get customer position in google map, quickly find customers
- **Connect to Phone Book**: Connect with your phonebook, move it to my app now.

# 📥 Download My App

<p align="center">
  <a href="">
    <img src="https://upload.wikimedia.org/wikipedia/commons/7/78/Google_Play_Store_badge_EN.svg" height="60" alt="Get it on Google Play">
  </a>

  </a>
</p>

---

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Libraries Used

### Call API
- [Retrofit](https://pub.dev/packages/retrofit)
- [Convert JSON to Dart Class](https://javiercbk.github.io/json_to_dart/)

### Dependency Injection
- [get_it](https://pub.dev/packages/get_it)
- [injectable](https://pub.dev/packages/injectable)

### Global Store
- [provider](https://pub.dev/packages/provider)

## Development

To run the project in development mode, execute the following commands:

```sh
flutter clean
flutter pub get
flutter packages pub run build_runner watch --delete-conflicting-outputs
flutter pub run build_runner build
flutter run