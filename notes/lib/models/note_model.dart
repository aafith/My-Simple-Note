class Note {
  int? id;
  String? title;
  String? content;
  String? dateTime;

  Note({this.id, this.title, this.content, this.dateTime});

  Map<String, dynamic> noteMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'dateTime': dateTime,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      dateTime: map['dateTime'],
    );
  }

  static Note empty() {
    return Note(
      id: 0,
      title: '',
      content: '',
      dateTime: '',
    );
  }
}
