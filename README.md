# Eyego News

A Flutter mobile app that fetches and displays news articles from a public REST API, with Firebase Authentication, category filtering, and search.

## Features

- Email/Password Authentication (Sign Up, Login, Logout, persistent session)
- News feed from a public REST API (Noozra)
- Category filtering (General, World, Politics, Sports, Entertainment, Health, Science, AI, Finance)
- Search functionality
- Article detail screen with "Read Full Article" link
- State management using BLoC/Cubit
- Dark, responsive UI

## Tech Stack

- Flutter / Dart
- flutter_bloc (Cubit) for state management
- Firebase Authentication
- REST API (Noozra News API)
- http package for networking
- cached_network_image for image loading
- url_launcher for opening articles

## Project Structure

lib/
  core/
    app_colors.dart

  features/
    auth/
      data/
        auth_repository.dart
      cubit/
        auth_cubit.dart
        auth_state.dart
      presentation/
        login_screen.dart
        sign_up_screen.dart

    news/
      data/
        news_article.dart
        news_repository.dart
      cubit/
        news_cubit.dart
        news_state.dart
      presentation/
        home_screen.dart
        article_detail_screen.dart

  main.dart

## Setup Instructions

1. Clone the repository:

   git clone https://github.com/negro703/eyego-news.git
   cd eyego-news

2. Install dependencies:

   flutter pub get

3. Firebase setup:
   - This project uses Firebase Authentication.
   - lib/firebase_options.dart and android/app/google-services.json are excluded from version control.
   - To regenerate them, install the FlutterFire CLI and run:

     dart pub global activate flutterfire_cli
     flutterfire configure

   - Select or create a Firebase project, and enable Email/Password sign-in under Authentication in the Firebase Console.

4. Run the app:

   flutter run

## Implementation Approach

**Why did you split the project into features (auth, news)?**
So each part of the app (login, news) stays independent from the other. If someone wants to add a new feature later (like notifications), it gets its own folder without touching the auth or news code at all. Each feature follows the same pattern (data/cubit/presentation), so the code stays predictable and easy for anyone to navigate.

**Why did you choose Cubit?**
It's simpler than full BLoC (no separate events) and enough for the size of this project. It lets me separate the business logic (like login or fetching news) from the UI — the screen just displays whatever state the Cubit emits (Loading/Success/Error) and doesn't know the details of how the data arrives.

**Why Noozra, and how did you convert the JSON?**
I chose it because it's a real, open REST API that doesn't need an API key or registration, which saved setup time. I created a NewsArticle class with a fromJson factory constructor that safely converts the JSON response into a Dart object, handling values that could come back as null (like image_url in some articles).

**How did you implement auto-login?**
Firebase Auth provides a stream called authStateChanges() that emits the current user as soon as the app opens if there's a saved session, or null if there isn't. The AuthCubit subscribes to this stream from the moment it's created, and based on that determines the state (Authenticated/Unauthenticated). In main.dart I created a widget called AuthGate that listens to this state and automatically decides whether to show HomeScreen or LoginScreen, with no manual navigation needed.

**What was the biggest challenge you faced and how did you solve it?**
I ran into an Android build issue caused by a Kotlin incremental compilation conflict (the project was on drive D while the cache was on drive C), and solved it by disabling kotlin.incremental in gradle.properties. I also discovered that the category names I assumed (like "technology") weren't the actual names the API supports, so I went back to the API documentation and corrected the values.

## Demo Video

<!-- [Add the link here after uploading the video](https://drive.google.com/file/d/1K79vmb5LDvwJ-A6YAyhSnktTPXQiDqWA/view?usp=drivesdk) -->
