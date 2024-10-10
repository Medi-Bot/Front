class Taille {
  String date;
  double taille;

  Taille(this.date, this.taille);

  Taille.fromJson(Map<String, dynamic> json)
      : date = json['date'],
        taille = json['taille'];

  Map<String, dynamic> toJson() {
    return {
      "date" : this.date,
      "taille" : this.taille.toStringAsFixed(2),
    };
  }
}