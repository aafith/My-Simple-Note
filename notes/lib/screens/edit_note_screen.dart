import 'package:flutter/material.dart';
import 'package:notes/models/note_model.dart';
import 'package:notes/services/note_service.dart';

class EditNoteScreen extends StatefulWidget {
  final Note note;
  const EditNoteScreen({required this.note, super.key});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  bool _titleValidate = false;
  bool _contentValidate = false;

  var noteService = NoteService();

  @override
  void initState() {
    setState(() {
      _titleController.text = widget.note.title ?? '';
      _contentController.text = widget.note.content ?? '';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
        backgroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) async {
              if (result == 'delete') {
                bool? confirmDelete = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm Delete'),
                      content: const Text(
                          'Are you sure you want to delete this note?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                      backgroundColor: Colors.white,
                    );
                  },
                );

                if (confirmDelete == true && widget.note.id != null) {
                  await noteService.deleteNote(widget.note.id!);
                  if (!mounted) return;
                  Navigator.pop(context);
                }
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.black),
                    SizedBox(width: 8),
                    Text('Delete'),
                  ],
                ),
              ),
            ],
            color: const Color(0xFFF6F6F6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Edit Title',
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
              onPressed: () async {
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
                  note.id = widget.note.id;
                  note.title = _titleController.text;
                  note.content = _contentController.text;
                  note.dateTime = DateTime.now().toString();

                  await noteService.updateNote(note);

                  //print(
                  //'Note Saved: Title: ${note.title}, Content: ${note.content}, DateTime: ${note.dateTime}');
                  if (!mounted) return;
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Border radius
                ),
              ),
              child: const Text('Edit Note'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
