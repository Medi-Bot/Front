class Poids {
  String date;
  double poids;

  Poids(this.date, this.poids);

  Poids.fromJson(Map<String, dynamic> json)
      : date = json['date'],
        poids = json['poids'];
}