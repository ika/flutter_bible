// BookMark Model

class BmModel {
  int id;
  String title;
  String subtitle;
  int version; // version book number
  int book; // book number
  int chapter; // chapter number
  int verse; // verse number

  BmModel(
      {this.id,
      this.title,
      this.subtitle,
      this.version,
      this.book,
      this.chapter,
      this.verse});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'version': version,
      'book': book,
      'chapter': chapter,
      'verse': verse
    };
  }
}
