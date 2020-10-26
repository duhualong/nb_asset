class Option {
  int id;
  String title;
  bool isChecked;
  bool isReverse;

  Option({
    this.id,
    this.title,
    this.isChecked,
    this.isReverse,
  });

  Option copy() => Option(
    id: this.id,
    title: this.title,
    isChecked: this.isChecked,
    isReverse: this.isReverse,
  );

  String get debugDescription {
    return 'id: $id, title: $title, isChecked: $isChecked,isReverse:$isReverse';
  }
}
