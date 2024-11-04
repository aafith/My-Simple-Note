import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/models/note_model.dart';
import 'package:notes/screens/edit_note_screen.dart';
import '../services/note_service.dart';
import '../screens/add_note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Note> _noteList = [];
  final _noteService = NoteService();

  getAllNoteDetails() async {
    var notes = await _noteService.readAllNotes();
    _noteList = <Note>[];

    notes.forEach((note) {
      setState(() {
        var noteModel = Note();
        noteModel.id = note.id;
        noteModel.title = note.title;
        noteModel.content = note.content;
        noteModel.dateTime = note.dateTime;
        _noteList.add(noteModel);
      });
    });
  }

  @override
  void initState() {
    getAllNoteDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              height: 40,
            ),
            const SizedBox(width: 10),
            const Text('My Simple Note'),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Search Notes',
                labelStyle: TextStyle(color: Colors.black), // Added this line
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  if (value.isEmpty) {
                    getAllNoteDetails();
                  } else {
                    _noteList = _noteList.where((note) {
                      return note.title!
                              .toLowerCase()
                              .contains(value.toLowerCase()) ||
                          note.content!
                              .toLowerCase()
                              .contains(value.toLowerCase());
                    }).toList();
                  }
                });
              },
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: _noteList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditNoteScreen(note: _noteList[index]),
                        ),
                      );
                      getAllNoteDetails();
                    },
                    child: Card(
                      color: const Color(0xFFF6F6F6),
                      elevation: 0,
                      child: GridTile(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _noteList[index].title != null &&
                                              _noteList[index].title!.length >
                                                  19
                                          ? '${_noteList[index].title!.substring(0, 19)}...'
                                          : _noteList[index].title ??
                                              'No Title',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      _noteList[index].content != null &&
                                              _noteList[index].content!.length >
                                                  80
                                          ? '${_noteList[index].content!.substring(0, 80)}...'
                                          : _noteList[index].content ??
                                              'No Content',
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      _noteList[index].dateTime != null
                                          ? DateFormat('dd/MM/yyyy hh:mm a')
                                              .format(DateTime.parse(
                                                  _noteList[index].dateTime!))
                                          : 'No Date',
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNoteScreen()),
          );
          getAllNoteDetails();
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      backgroundColor: Colors.white,
    );
  }
}
