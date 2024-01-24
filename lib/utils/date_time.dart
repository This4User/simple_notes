DateTime? parseDateOrNull(String? dateString) {
  if (dateString == null) return null;

  return DateTime.tryParse(dateString);
}
