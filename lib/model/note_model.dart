class NoteModel {
  int? noteId;
  String? date;
  String? note;
  bool? done;
  int? dietitianId;

  NoteModel({this.noteId, this.date, this.note, this.done, this.dietitianId});

  NoteModel.fromJson(Map<String, dynamic> json) {
    noteId = json['note_id'];
    date = json['date'];
    note = json['note'];
    done = json['done'];
    dietitianId = json['dietitian_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['note_id'] = this.noteId;
    data['date'] = this.date;
    data['note'] = this.note;
    data['done'] = this.done;
    data['dietitian_id'] = this.dietitianId;
    return data;
  }
}
