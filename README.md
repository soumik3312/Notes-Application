# 📝Offline Notes App

A **simple yet powerful offline note-taking application** built with **Flutter**, powered by **GetX** for state management, dependency injection, and routing, and using **SQLite** for persistent local storage. This app offers a smooth, reactive, and user-friendly experience — perfect for quickly jotting down ideas, tasks, or reminders anytime, anywhere.


## 📌 Features

✅ **Built with Flutter + Dart** using **GetX** for:
- State Management  
- Dependency Injection  
- Route Management  

✅ **SQLite Persistence**
- All notes stored locally using the `sqflite` package.
- Offline-first: no internet or cloud required.

✅ **Notes Structure**
- Each note contains:
  - `title`
  - `content`
  - `createdAt`
  - `updatedAt`

✅ **Home Screen**
- Displays a **searchable and sortable list** of notes.
- Sort by **title** or **created/updated date**.

✅ **Add/Edit Note Screen**
- Clean, intuitive form UI.
- Includes **validation** for non-empty title and content.

✅ **Delete with Swipe**
- Swipe-to-delete functionality.
- Confirmation dialog prevents accidental deletions.

✅ **Reactive UI**
- Built with GetX `RxList`, `RxString`, and other observables for smooth real-time updates.

✅ **Navigation**
- Seamless navigation using **GetX Named Routes** and **Bindings**.

✅ **Dark Mode Toggle**
- Theme management via GetX.
- Toggle between light and dark mode effortlessly.

---

## 🧠 Architecture
GetX Controllers: Manages business logic and state.

Service Layer: Handles all database operations with SQLite.

Bindings: Automatically initializes controllers when navigating.

Reactive Widgets: UI updates automatically on data changes.


