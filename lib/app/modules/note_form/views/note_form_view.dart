import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/note_form_controller.dart';

class NoteFormView extends GetView<NoteFormController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: controller.onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Obx(() => Text(
            controller.isEditMode.value ? 'Edit Note' : 'Add Note'
          )),
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: controller.discardChanges,
          ),
          actions: [
            Obx(() => controller.isLoading.value
              ? Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
              : TextButton(
                  onPressed: controller.saveNote,
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ),
          ],
        ),
        body: Form(
          key: controller.formKey,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Title Field
                TextFormField(
                  controller: controller.titleController,
                  validator: controller.validateTitle,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    hintText: 'Enter note title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                
                SizedBox(height: 16),
                
                // Content Field
                Expanded(
                  child: TextFormField(
                    controller: controller.contentController,
                    validator: controller.validateContent,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      labelText: 'Content',
                      hintText: 'Write your note here...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignLabelWithHint: true,
                    ),
                    style: TextStyle(fontSize: 16),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                
                SizedBox(height: 16),
                
                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value ? null : controller.saveNote,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: controller.isLoading.value
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          controller.isEditMode.value ? 'Update Note' : 'Save Note',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
