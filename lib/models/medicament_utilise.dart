class MedicamentUtilise {
  String dateDebut;
  String nom;
  String frequence;
  String dateFin;

  MedicamentUtilise(this.dateDebut, this.nom, this.frequence, this.dateFin);

  MedicamentUtilise.fromJson(Map<String, dynamic> json)
      : dateDebut = json["id"]['dateDebut'],
        nom = json["id"]['nom'],
        frequence = json['frequence'],
        dateFin = json['dateFin'];
}