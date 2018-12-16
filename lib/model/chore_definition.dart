class ChoreDefinition {
  final String id;
  final String name;
  final String details;
  final int frequencyAmount;
  final String frequencyType;

  ChoreDefinition(
      this.id,
      this.name,
      this.details,
      this.frequencyAmount,
      this.frequencyType,
      );

  factory ChoreDefinition.fromJson(Map<String, dynamic> jsonData) {
    return ChoreDefinition(
      jsonData["id"],
      jsonData["name"],
      jsonData["details"],
      jsonData["frequencyAmount"],
      jsonData["frequencyType"],
    );
  }
}