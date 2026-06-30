import 'package:flutter/material.dart';

import '../../../core/database/database_service.dart';
import '../models/note_model.dart';

class NoteProvider extends ChangeNotifier {
  NoteProvider() {
    _service = DatabaseService.instance;
  }

  late final DatabaseService _service;
  List<Note> _notes = [];
  bool isLoading = true;
  String activeCategory = 'All';

  List<Note> get notes => [..._notes];

  List<Note> get activeNotes => _notes.where((note) => !note.isDeleted && !note.isArchived).toList();

  List<Note> get pinnedNotes => activeNotes.where((note) => note.isPinned).toList();

  List<Note> get favoriteNotes => activeNotes.where((note) => note.isFavorite).toList();

  List<Note> get archivedNotes => _notes.where((note) => note.isArchived && !note.isDeleted).toList();

  List<Note> get trashNotes => _notes.where((note) => note.isDeleted).toList();

  List<String> get categories {
    return [
      'All',
      ...{...activeNotes.map((note) => note.category)}
    ];
  }

  Future<void> initialize() async {
    await _service.ensureSampleNotes();
    await loadNotes();
  }

  Future<void> loadNotes() async {
    isLoading = true;
    notifyListeners();
    _notes = await _service.fetchNotes();
    isLoading = false;
    notifyListeners();
  }

  Future<void> saveNote(Note note) async {
    final now = DateTime.now();
    if (note.id == null) {
      await _service.createNote(note.copyWith(updatedAt: now));
    } else {
      await _service.updateNote(note.copyWith(updatedAt: now));
    }
    await loadNotes();
  }

  Future<void> deleteNote(Note note) async {
    final updated = note.copyWith(isDeleted: true, isArchived: false, updatedAt: DateTime.now());
    await _service.updateNote(updated);
    await loadNotes();
  }

  Future<void> archiveNote(Note note) async {
    final updated = note.copyWith(isArchived: true, updatedAt: DateTime.now());
    await _service.updateNote(updated);
    await loadNotes();
  }

  Future<void> restoreNote(Note note) async {
    final updated = note.copyWith(isDeleted: false, isArchived: false, updatedAt: DateTime.now());
    await _service.updateNote(updated);
    await loadNotes();
  }

  Future<void> toggleFavorite(Note note) async {
    final updated = note.copyWith(isFavorite: !note.isFavorite, updatedAt: DateTime.now());
    await _service.updateNote(updated);
    await loadNotes();
  }

  Future<void> togglePin(Note note) async {
    final updated = note.copyWith(isPinned: !note.isPinned, updatedAt: DateTime.now());
    await _service.updateNote(updated);
    await loadNotes();
  }

  Future<void> deletePermanently(Note note) async {
    if (note.id == null) return;
    await _service.deleteNotePermanently(note.id!);
    await loadNotes();
  }

  List<Note> search(String query) {
    final normalized = query.toLowerCase();
    return activeNotes.where((note) {
      return note.title.toLowerCase().contains(normalized) ||
          note.content.toLowerCase().contains(normalized) ||
          note.category.toLowerCase().contains(normalized);
    }).toList();
  }

  List<Note> filteredNotes() {
    if (activeCategory == 'All') return activeNotes;
    return activeNotes.where((note) => note.category == activeCategory).toList();
  }

  void selectCategory(String category) {
    activeCategory = category;
    notifyListeners();
  }

  String greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String statusText() {
    final count = activeNotes.length;
    return '$count notes waiting for your next idea';
  }
}
