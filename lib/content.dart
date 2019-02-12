class Content {
  String title;
  String description;
  bool checked;

  Content(this.title, this.description, this.checked);

  String getTitle() {
    return this.title;
  }

  String getDescription() {
    return this.description;
  }

  void setChecked() {
    if (this.checked) {
      this.checked = false;
    } else {
      this.checked = true;
    }
  }
}
