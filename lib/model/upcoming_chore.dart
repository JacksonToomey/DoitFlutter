class UpcomingChore {
  String id;
  String name;
  String details;
  DateTime dueDate;

  UpcomingChore(this.id, this.name, this.details, this.dueDate);

  factory UpcomingChore.fromJson(Map<String, dynamic> jsonData) {
    return UpcomingChore(
      jsonData["id"],
      jsonData["name"],
      jsonData["details"],
      DateTime.parse(jsonData["dueDate"]),
    );
  }
}