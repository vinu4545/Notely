class Validators {
  Validators._();

  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Give your note a memorable title.';
    }
    return null;
  }
}
