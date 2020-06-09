class Option {
  int id;
  String title;
  bool isChecked;
  int value;

  Option({
    this.id,
    this.title,
    this.isChecked,
    this.value,
  });

  Option copy() => Option(
    id: this.id,
    title: this.title,
    isChecked: this.isChecked,
    value: this.value,
  );

  String get debugDescription {
    return 'id: $id, title: $title, isChecked: $isChecked';
  }
}
