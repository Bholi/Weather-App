class Current {
  double tempC;
  Condition condition;
  Current({required this.tempC, required this.condition});

  factory Current.fromJson(Map<String, dynamic> json) {
    return Current(
        tempC: json["temp_c"],
        condition: Condition.fromJson(json['condition']));
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['temp_c'] = tempC;
    data['condition'] = condition;
    return data;
  }
}

class Condition {
  String text;
  String icon;

  Condition({
    required this.text,
    required this.icon,
  });
  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(text: json["text"], icon: json["icon"]);
  }
}
