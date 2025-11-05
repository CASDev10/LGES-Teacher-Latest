class RelieverListElement {
  int relieverId;
  String relieverName;

  RelieverListElement({
    required this.relieverId,
    required this.relieverName,
  });

  factory RelieverListElement.fromJson(Map<String, dynamic> json) =>
      RelieverListElement(
        relieverId: json["RelieverId"],
        relieverName: json["RelieverName"],
      );

  Map<String, dynamic> toJson() => {
        "RelieverId": relieverId,
        "RelieverName": relieverName,
      };
}
