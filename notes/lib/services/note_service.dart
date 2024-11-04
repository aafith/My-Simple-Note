import '../models/note_model.dart';
import '../services/repository.dart';

class NoteService {
  final Repository _repository = Repository();

  // Save Note
  Future<void> saveNote(Note note) async {
    return await _repository.insertData('notes', note.noteMap());
  }

  // Read All Notes
  Future<List<Note>> readAllNotes() async {
    // Fetch the data from the repository
    final result = await _repository.readData('notes');

    // Convert the QueryResultSet to a List<Note>
    List<Note> notes = [];
    for (var item in result) {
      notes.add(Note.fromMap(
          item)); // Assuming you have a fromMap method in your Note model
    }

    return notes;
  }

  // Update Note
  Future<void> updateNote(Note note) async {
    return await _repository.updateData('notes', note.noteMap());
  }

  // Delete Note
  Future<void> deleteNote(int noteId) async {
    return await _repository.deleteData('notes', noteId);
  }
}
