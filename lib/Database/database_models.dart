import 'package:fluttercontactpicker/fluttercontactpicker.dart';

// User Model Class

class UserModelClass {
  int? id;
  String username;
  String email;
  String password;
  String imagepath;
  int isLogedin;

  UserModelClass(
      {required this.username,
      required this.password,
      required this.imagepath,
      required this.email,
      this.isLogedin = -0,
      this.id});

// to convert map into usermodel obj
  static UserModelClass frommap(Map map) {
    int id = map['id'] as int;
    String username = map['username'] as String;
    String password = map['password'] as String;
    String imagepath = map['imagepath'] as String;
    String email = map['email'] as String;
    int islogedin = map['islogedin'];

    return UserModelClass(
        id: id,
        username: username,
        email: email,
        password: password,
        imagepath: imagepath,
        isLogedin: islogedin);
  }
}

// Trip Model Class

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

// Companion Model Class
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

///Expense Model class///

class Expenses {
  int? totalexpense;
  int? balance;
  int? tripId;
  int? food;
  int? transport;
  int? hotel;
  int? other;
  Expenses(
      {this.totalexpense,
      this.food,
      this.hotel,
      this.other,
      this.transport,
      this.balance,
      this.tripId});

  Map<String, dynamic> toMap(Expenses expense) {
    return {
      'totalexpense': expense.totalexpense,
      'tripId': expense.tripId,
      'food': expense.food,
      'transport': expense.transport,
      'hotel': expense.hotel,
      'other': expense.other,
      'balance': expense.balance,
    };
  }
}


