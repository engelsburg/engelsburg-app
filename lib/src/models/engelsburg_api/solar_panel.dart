class SolarPanel {
  SolarPanel({
    this.date,
    this.energy,
    this.co2Avoidance,
    this.payment,
    this.text
  });

  final String? date;
  final String? energy;
  final String? co2Avoidance;
  final String? payment;
  final String? text;

  factory SolarPanel.fromJson(Map<String, dynamic> json) => SolarPanel(
        date: json["date"],
        energy: json["energy"],
        co2Avoidance: json["co2avoidance"],
        payment: json["payment"],
        text: json["text"]
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "energy": energy,
        "co2avoidance": co2Avoidance,
        "payment": payment,
        "text": text
      };
}
