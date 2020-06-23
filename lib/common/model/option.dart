class Option {
  int id;
  String title;
  bool isChecked;

  Option({
    this.id,
    this.title,
    this.isChecked,
  });

  Option copy() => Option(
    id: this.id,
    title: this.title,
    isChecked: this.isChecked,
  );

  String get debugDescription {
    return 'id: $id, title: $title, isChecked: $isChecked';
  }
}
