import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/note_model.dart';
import '../../../services/database_service.dart';

class NoteFormController extends GetxController {
  final DatabaseService _databaseService = Get.find<DatabaseService>();
  
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  
  final RxBool isLoading = false.obs;
  final RxBool isEditMode = false.obs;
  
  Note? _editingNote;

  @override
  void onInit() {
    super.onInit();
    final note = Get.arguments as Note?;
    if (note != null) {
      _editingNote = note;
      isEditMode.value = true;
      titleController.text = note.title;
      contentController.text = note.content;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    super.onClose();
  }

  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Title is required';
    }
    if (value.trim().length < 2) {
      return 'Title must be at least 2 characters';
    }
    return null;
  }

  String? validateContent(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Content is required';
    }
    if (value.trim().length < 5) {
      return 'Content must be at least 5 characters';
    }
    return null;
  }

  Future<void> saveNote() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;
      
      final now = DateTime.now();
      
      if (isEditMode.value && _editingNote != null) {
        final updatedNote = _editingNote!.copyWith(
          title: titleController.text.trim(),
          content: contentController.text.trim(),
          updatedAt: now,
        );
        
        await _databaseService.updateNote(updatedNote);
        Get.snackbar(
          'Success', 
          'Note updated successfully',
          duration: Duration(seconds: 2),
        );
      } else {
        final newNote = Note(
          title: titleController.text.trim(),
          content: contentController.text.trim(),
          createdAt: now,
          updatedAt: now,
        );
        
        await _databaseService.insertNote(newNote);
        Get.snackbar(
          'Success', 
          'Note created successfully',
          duration: Duration(seconds: 2),
        );
      }
      

      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save note: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void discardChanges() {
    if (_hasUnsavedChanges()) {
      Get.dialog(
        AlertDialog(
          title: Text('Discard Changes'),
          content: Text('You have unsaved changes. Are you sure you want to discard them?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Get.back(); 
                Get.back(); 
              },
              child: Text('Discard', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    } else {
      Get.back();
    }
  }

  bool _hasUnsavedChanges() {
    if (isEditMode.value && _editingNote != null) {
      return titleController.text.trim() != _editingNote!.title ||
             contentController.text.trim() != _editingNote!.content;
    } else {
      return titleController.text.trim().isNotEmpty ||
             contentController.text.trim().isNotEmpty;
    }
  }

  Future<bool> onWillPop() async {
    if (_hasUnsavedChanges()) {
      final result = await Get.dialog<bool>(
        AlertDialog(
          title: Text('Discard Changes'),
          content: Text('You have unsaved changes. Are you sure you want to go back?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: Text('Discard', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
      return result ?? false;
    }
    return true;
  }
}
