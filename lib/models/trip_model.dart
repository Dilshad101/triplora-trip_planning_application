
import 'package:fluttercontactpicker/fluttercontactpicker.dart';

class Trips {
  int? id;
  int userId;
  String destination;
  String? fileImage;
  int? assetImgIdx;
  String startingDate;
  String endingDate;
  String purpose;
  String? notes;
  int transport;
  int budget;
  List<PhoneContact>? companions;

  Trips(
      {required this.destination,
      required this.startingDate,
      required this.endingDate,
      required this.transport,
      required this.purpose,
      required this.budget,
       this.fileImage,
       this.assetImgIdx,
      required this.userId,
      this.notes,
      this.companions,
      this.id});

  static Trips fromMap(Map<String,dynamic> map) {
    int id = map['id'];
    String startdate = map['startDate'] ;
    String endDate = map['endDate'] ;
    String destination = map['destination'] ;
    String purpose = map['purpose'] ;
    String fileImage = map['fileImage'];
    String notes = map['notes'];
    int transport = map['transport'] ;
    int budget = map['budget'];
    int userId = map['userId'] ;
    int assetImgIdx=map['assetImgIdx'] ;

    return Trips(
      id: id,
      notes: notes,
      userId: userId,
      destination: destination,
      startingDate: startdate,
      endingDate: endDate,
      transport: transport,
      purpose: purpose,
      budget: budget,
      fileImage: fileImage,
      assetImgIdx: assetImgIdx
    );
  }
}