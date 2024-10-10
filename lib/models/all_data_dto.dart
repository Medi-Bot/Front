import 'package:medibot/models/antecedent.dart';
import 'package:medibot/models/date_model.dart';
import 'package:medibot/models/poids.dart';
import 'package:medibot/models/taille.dart';
import 'historique_communication.dart';
import 'informations.dart';
import 'medicament_utilise.dart';

class AllDataDto {
  List<Antecedent> antecedents;
  List<HistoriqueCommunication> historiqueCommunications;
  List<Informations> informations;
  List<MedicamentUtilise> medicamentUtilises;
  List<Poids> poids;
  List<Taille> tailles;

  AllDataDto(this.antecedents, this.historiqueCommunications, this.informations, this.medicamentUtilises, this.poids, this.tailles);

  /*listImages.map((e) => getImageFromJson(e)).toList();*/

  AllDataDto.fromJson(Map<String, dynamic> json)
      : antecedents = json['antecedents'].map<Antecedent>((e) => Antecedent.fromJson(e)).toList(),
        historiqueCommunications = json['historiqueCommunications'].map<HistoriqueCommunication>((e) => HistoriqueCommunication.fromJson(e)).toList(),
        informations = json['informations'].map<Informations>((e) => Informations.fromJson(e)).toList(),
        medicamentUtilises = json['medicamentUtilises'].map<MedicamentUtilise>((e) => MedicamentUtilise.fromJson(e)).toList(),
        poids = json['poids'].map<Poids>((e) => Poids.fromJson(e)).toList(),
        tailles = json['tailles'].map<Taille>((e) => Taille.fromJson(e)).toList();

  Antecedent getLastAntecedent(){
    return antecedents.isNotEmpty ? antecedents[antecedents.length-1] : Antecedent(DateModel.zero().toTimestamp(), "");
  }

  HistoriqueCommunication getLastHistoriqueCommunication(){
    return historiqueCommunications.isNotEmpty ? historiqueCommunications[historiqueCommunications.length-1] : HistoriqueCommunication(DateModel.zero().toTimestamp(), "", "");
  }

  Taille getLastTaille(){
    return tailles.isNotEmpty ? tailles[tailles.length-1] : Taille(DateModel.zero().toTimestamp(), 0);
  }

  Poids getLastPoids(){
    return poids.isNotEmpty ? poids[poids.length-1] : Poids(DateModel.zero().toTimestamp(), 0);
  }

  Informations getLastInformations(){
    return informations.isNotEmpty ? informations[informations.length-1] : Informations(0, DateTime.now().toString());
  }
}