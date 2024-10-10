class Informations {
  int id;
  String dateDeNaissance;

  Informations(this.id, this.dateDeNaissance);

  Informations.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        dateDeNaissance = json['dateDeNaissance'];
}