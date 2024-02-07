class Companions {
  int? id;
  String companion;
  String phonenumber;
  int? tripId;

  Companions(
      {required this.companion,
      required this.phonenumber,
      this.id,
      required this.tripId});

  Map<String, dynamic> toMap(Companions companion) {
    return {
      'companion': companion.companion,
      'phonenumber': companion.phonenumber,
      'tripId': companion.tripId,
    };
  }
}