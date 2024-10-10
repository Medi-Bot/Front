import 'package:medibot/models/date_model.dart';

class Treatment{
  String name;
  DateModel startDate;
  String frequency;
  DateModel endDate;

  Treatment(this.name, this.startDate, this.frequency, this.endDate);
}