class DateModel{
  int year ;
  int month ;
  int day ;
  int hour;
  int minute;
  int second;

  DateModel(this.year, this.month, this.day, this.hour, this.minute, this.second);

  DateModel.zero():
        this.year = 0,
        this.month = 0,
        this.day = 0,
        this.hour = 0,
        this.minute = 0,
        this.second = 0;

  static DateModel fromTimestamp(String timestamp){
    if(timestamp == ""){
      return DateModel(0, 0, 0, 0, 0, 0);
    }
    var firstCut = timestamp.split("-");
    var secondCut = firstCut[2].split(' ');
    var thirdCut = secondCut[1].split(':');
    var forthCut = thirdCut[2].split('.');
    return DateModel(int.parse(firstCut[0]),
        int.parse(firstCut[1]),
        int.parse(secondCut[0]),
        int.parse(thirdCut[0]),
        int.parse(thirdCut[1]),
        int.parse(forthCut[0]));
  }

  bool earlierThan(DateModel other){
    if(year < other.year){
      return true;
    }
    if(month < other.month){
      return true;
    }
    if(day < other.day){
      return true;
    }
    if(hour < other.hour){
      return true;
    }
    if(minute < other.minute){
      return true;
    }
    if(second < other.second){
      return true;
    }
    return false;
  }

  int toInt(){
    DateTime date = DateTime(year, month, day, hour, minute, second);
    return date.difference(DateTime(1970)).inSeconds;
  }

  String toString(){
    return '${this.day}/${this.month}/${this.year}';
  }

  String toTimestamp(){
    return '${this.year}-${this.month > 9 ? this.month : "0${this.month}"}-${this.day > 9 ? this.day : "0${this.day}"} ${this.hour > 9 ? this.hour : "0${this.hour}"}:${this.minute > 9 ? this.minute : "0${this.minute}"}:${this.second > 9 ? this.second : "0${this.second}"}.0';
  }
}