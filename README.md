# Notely

A polished Flutter note-taking app with local SQLite persistence, archive/trash workflows, intelligent filtering, and modern UI behavior.

---

## 🚀 Overview

Notely is a feature-first Flutter application built to manage notes with a clean and responsive experience. It stores all note data locally using SQLite through the `sqflite` package, so notes remain available offline and across app launches.

---

## ✨ Key Features

- Create, edit, and save notes
- Pin important notes for quick access
- Mark notes as favorites
- Archive notes to keep the main workspace focused
- Soft delete notes with a trash workflow
- Restore archived or deleted notes
- Search notes by title, content, or category
- Filter notes using live category tags
- Auto-seed sample notes on first launch
- Reactive UI updates with `ChangeNotifier`

---

## 🗄️ Database

This app uses a local SQLite database via the `sqflite` package.

Database helper files:
- `lib/core/database/database_helper.dart`
- `lib/core/database/database_service.dart`

### Notes table schema

This is the most important part of the project, and it is the table used to store every note:

```sql
CREATE TABLE notes(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  category TEXT NOT NULL,
  isPinned INTEGER NOT NULL,
  isFavorite INTEGER NOT NULL,
  isArchived INTEGER NOT NULL,
  isDeleted INTEGER NOT NULL,
  createdAt INTEGER NOT NULL,
  updatedAt INTEGER NOT NULL
)
```

### Database details

- Database file: `notely.db`
- Table name: `notes`
- Persistence handled by: `sqflite`
- Notes and metadata are stored locally on the device

---

## 🧠 Core Note Behaviors

The note lifecycle in Notely includes:

- Adding new notes with metadata like category, pin, favorite, and timestamps
- Updating notes while tracking `updatedAt`
- Archiving notes instead of deleting them immediately
- Soft deleting notes so they can be recovered from trash
- Permanently deleting notes from the database

---

## 📁 Project Structure

- `lib/main.dart` — app entry point
- `lib/core/database/` — SQLite setup and CRUD services
- `lib/features/notes/` — note models, provider, and list UI
- `lib/features/editor/` — note creation and editing screen
- `lib/features/archive/` — archive screen for stored notes
- `lib/features/trash/` — trash screen for deleted notes
- `lib/features/search/` — search screen

---

## 🔧 Dependencies

- `flutter`
- `sqflite`
- `path_provider`
- `path`
- `shared_preferences`

---

## ▶️ Setup

```bash
flutter pub get
flutter run
```

---

## 💡 Why Notely

Notely is not just a starter app. It is a complete local note management solution with a solid SQLite-backed persistence layer and a strong focus on note organization, archive/trash handling, and smooth state-driven behavior.
