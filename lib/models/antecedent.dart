class Antecedent {
  String date;
  String description;

  Antecedent(this.date, this.description);

  Antecedent.fromJson(Map<String, dynamic> json)
      : date = json['date'],
        description = json['description'];

  Map<String, dynamic> toJson() {
    return {
      "date" : this.date,
      "description" : this.description,
    };
  }
}