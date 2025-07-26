# Jano AI School — Codebase Structure Plan

This document outlines a modular, scalable, and maintainable Flutter codebase structure for Jano AI School.

---

## 📁 Recommended Directory Structure (inside `lib/`)

```
lib/
  ├── app/                # App entry, global config, theming, routing
  ├── dashboard/          # Main dashboard/home page and navigation
  ├── auth/               # Login, registration, authentication flows
  ├── welcome/            # Welcome guide, onboarding, intro screens
  ├── database/           # Database/backend integration (Supabase, etc.)
  ├── ai/                 # AI logic, Gemini API integration, chat, helpers
  ├── models/             # Data models, DTOs
  ├── services/           # Business logic, API services, utilities
  ├── widgets/            # Reusable UI components
  ├── constants/          # App-wide constants, colors, text styles
  ├── images/             # App images and asset files
  └── main.dart           # App entry point
```

---

## 🧩 Folder Descriptions

- **app/**: App-wide configuration, theming, routing, dependency injection.
- **dashboard/**: Main dashboard, navigation bar, and core user experience after login.
  - `dashboard_screen.dart`: Main dashboard screen after login, showing user info, navigation, and feature cards.
  - `my_ai_school_card.dart`: Widget displaying a summary card for "My AI School" with app highlights and a call-to-action.
  - `navbar.dart`: Bottom navigation bar widget for dashboard navigation (Home, AI School, AI Teacher, Profile).
- **auth/**: Login, registration, password reset, and authentication logic.
  - `signin_screen.dart`: UI and logic for user sign-in, including form, validation, and integration with Supabase authentication.
  - `signup_screen.dart`: UI and logic for user registration, including form, validation, and integration with Supabase for account creation.
  - `supabase_service.dart`: Service class for handling Supabase authentication (sign in, sign up, email check) and initialization.
- **welcome/**: Welcome guide, onboarding, and first-time user flows.
  - `welcome_screen.dart`: Welcome/onboarding screen with options to sign up or sign in, and app introduction.
- **database/**: All backend/database logic (e.g., Supabase integration, queries, data sync).
- **ai/**: AI features, Gemini API integration, chat UI, and helpers for AI interactions.
- **models/**: Dart classes for data models, API responses, and DTOs.
- **services/**: Business logic, API clients, utility functions, and app services.
- **widgets/**: Reusable UI components (buttons, cards, dialogs, etc.).
- **constants/**: Colors, text styles, app-wide constants, and configuration values.
- **images/**: App images, icons, and other asset files.
- **main.dart**: The main entry point of the app.

---

## 🛠️ Best Practices
- Keep folders focused and modular.
- Use clear naming conventions.
- Separate UI, business logic, and data layers.
- Make it easy to add new features or update existing ones.
- Use widgets/ for all reusable UI components.
- Store all theme/colors/fonts in constants/.
- Store all app images and assets in images/.

---

## 🏗️ Example: Adding a New Feature
To add a new feature (e.g., a quiz module):
- Create a new folder: `lib/quiz/`
- Add screens, logic, and widgets related to quizzes inside this folder.
- Register routes in `app/` as needed.

---

## 🔄 Updating & Scaling
- New features = new folders.
- Keep business logic in services/ and models/.
- Keep UI clean and separated from logic.
- Store all new images/assets in images/.

---

## 📚 References
- [Flutter Best Practices](https://docs.flutter.dev/development/data-and-backend/state-mgmt/simple)
- [Modular Flutter Architecture](https://medium.com/flutter/structuring-your-flutter-project-2d3e9112b3a1) 