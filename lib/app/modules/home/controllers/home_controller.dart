import 'package:get/get.dart';
import '../../../data/models/note_model.dart';
import '../../../services/database_service.dart';

enum SortOption { dateDesc, dateAsc, titleAsc, titleDesc }

class HomeController extends GetxController {
  final DatabaseService _databaseService = Get.find<DatabaseService>();
  
  final RxList<Note> notes = <Note>[].obs;
  final RxList<Note> filteredNotes = <Note>[].obs;
  final RxString searchQuery = ''.obs;
  final Rx<SortOption> currentSort = SortOption.dateDesc.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotes();
    debounce(searchQuery, (_) => _filterNotes(), time: Duration(milliseconds: 300));
  }

  Future<void> loadNotes() async {
    try {
      isLoading.value = true;
      final notesList = await _databaseService.getAllNotes();
      notes.value = notesList;
      _filterNotes();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load notes: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _filterNotes() {
    List<Note> filtered = notes.toList();
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((note) =>
        note.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        note.content.toLowerCase().contains(searchQuery.value.toLowerCase())
      ).toList();
    }
    _sortNotes(filtered);
    
    filteredNotes.value = filtered;
  }

  void _sortNotes(List<Note> notesList) {
    switch (currentSort.value) {
      case SortOption.dateDesc:
        notesList.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        break;
      case SortOption.dateAsc:
        notesList.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
        break;
      case SortOption.titleAsc:
        notesList.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case SortOption.titleDesc:
        notesList.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
        break;
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void changeSortOption(SortOption option) {
    currentSort.value = option;
    _filterNotes();
  }

  Future<void> deleteNote(Note note) async {
    try {
      await _databaseService.deleteNote(note.id!);
      notes.removeWhere((n) => n.id == note.id);
      _filterNotes();
      Get.snackbar('Success', 'Note deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete note: $e');
    }
  }

  void navigateToAddNote() {
    Get.toNamed('/add-note')?.then((_) => loadNotes());
  }

  void navigateToEditNote(Note note) {
    Get.toNamed('/edit-note', arguments: note)?.then((_) => loadNotes());
  }

  String getSortOptionText(SortOption option) {
    switch (option) {
      case SortOption.dateDesc:
        return 'Date (Newest)';
      case SortOption.dateAsc:
        return 'Date (Oldest)';
      case SortOption.titleAsc:
        return 'Title (A-Z)';
      case SortOption.titleDesc:
        return 'Title (Z-A)';
    }
  }
}
