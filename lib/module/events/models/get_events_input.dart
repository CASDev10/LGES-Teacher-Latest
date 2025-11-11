class GetEventsInput {
  final int ucLoginUserId;
  final int ucEntityId;
  final int month;
  final int year;
  final int schoolIdFk;

  GetEventsInput({
    required this.ucLoginUserId,
    required this.ucEntityId,
    required this.month,
    required this.year,
    required this.schoolIdFk,
  });

  factory GetEventsInput.fromJson(Map<String, dynamic> json) => GetEventsInput(
    ucLoginUserId: json["UC_LoginUserId"],
    ucEntityId: json["UC_EntityId"],
    month: json["Month"],
    year: json["Year"],
    schoolIdFk: json["SchoolIdFk"],
  );

  Map<String, dynamic> toJson() => {
    "UC_LoginUserId": ucLoginUserId,
    "UC_EntityId": ucEntityId,
    "Month": month,
    "Year": year,
    "SchoolIdFk": schoolIdFk,
  };
}
