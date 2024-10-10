class HistoriqueCommunication {
  String date;
  String message;
  String reponse;

  HistoriqueCommunication(this.date, this.message, this.reponse);

  HistoriqueCommunication.fromJson(Map<String, dynamic> json)
      : date = json['date'],
        message = json['message'],
        reponse = json['reponse'];
}