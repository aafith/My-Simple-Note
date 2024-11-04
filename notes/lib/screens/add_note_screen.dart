import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/note_service.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  bool _titleValidate = false;
  bool _contentValidate = false;

  var noteService = NoteService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
                errorText: _titleValidate ? 'Value Can\'t Be Empty' : null,
                hintStyle:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              maxLines: null,
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: 'Start Typing',
                  border: InputBorder.none,
                  errorText: _contentValidate ? 'Value Can\'t Be Empty' : null,
                ),
                maxLines: null,
                expands: true,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _titleController.text.isEmpty
                      ? _titleValidate = true
                      : _titleValidate = false;
                  _contentController.text.isEmpty
                      ? _contentValidate = true
                      : _contentValidate = false;
                });
                if (_titleValidate == false && _contentValidate == false) {
                  var note = Note();
                  note.title = _titleController.text;
                  note.content = _contentController.text;
                  note.dateTime = DateTime.now().toString();

                  var result = noteService.saveNote(note);

                  //print(
                  //'Note Saved: Title: ${note.title}, Content: ${note.content}, DateTime: ${note.dateTime}');
                  Navigator.pop(context, result);
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Border radius
                ),
              ),
              child: const Text('Save Note'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
