// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'database_models.dart';

ValueNotifier<int> totalExpenses = ValueNotifier(0);
ValueNotifier<int> balanceNotifire = ValueNotifier(0);
ValueNotifier<List<Expenses>> expenseNotifier =
    ValueNotifier<List<Expenses>>([]);

UserModelClass? user;

class DatabaseHelper {
  final String _databaseName = 'database.db';
  final String _userTable = 'usertable';
  final String _tripTable = 'trip_table';
  final String _companionTable = 'companion_table';
  final String _tripExpenses = 'trip_expenses';
  final String _tripImages = 'trip_images';

  List<UserModelClass> userList = [];
  Database? _database;
  late bool available;

  late bool isEndDateAvailable;
  late bool isStartDateAvailable;

  late bool startDateAvailable;
  late bool endDateAvailable;
  late bool isTripAvailable;

  DatabaseHelper._();

  Future<Database> getDatabase() async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDb();
    return _database!;
  }

  static final DatabaseHelper instance = DatabaseHelper._();

  initDb() async {
    return await openDatabase(
      _databaseName,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''CREATE TABLE $_userTable(
          id INTEGER PRIMARY KEY ,
          username TEXT ,
          password TEXT ,
          imagepath TEXT , 
          islogedin INTEGER, 
          email TEXT)''');
        await db.execute('''CREATE TABLE $_tripTable
           (id INTEGER PRIMARY KEY ,
            userId INTEGER, 
           fileImage TEXT ,
           assetImgIdx INTEGER, 
           destination TEXT , 
           startDate TEXT , 
           endDate TEXT , 
           purpose TEXT , 
           transport INTEGER ,
           budget INTEGER,
           notes TEXT,
           FOREIGN KEY(userId) REFERENCES $_userTable (id) ON DELETE CASCADE
           ) ''');
        await db.execute('''CREATE TABLE $_companionTable  (
           id INTEGER PRIMARY KEY, 
           tripId INTEGER ,
           companion TEXT , 
           phonenumber TEXT,
           FOREIGN KEY(tripId) REFERENCES $_tripTable (id) ON DELETE CASCADE)''');
        await db.execute(''' CREATE TABLE $_tripExpenses(
           id INTEGER PRIMARY KEY ,
           tripId INTEGER ,
           totalexpense INTEGER ,
           balance INTEGER,
           food INTEGER ,
           transport INTEGER ,
           hotel INTEGER ,
           other INTEGER ,
           FOREIGN KEY(tripId) REFERENCES $_tripTable (id) ON DELETE CASCADE
           )''');
        await db.execute('''CREATE TABLE $_tripImages (
              id INTEGER PRIMARY KEY , 
              tripId INTEGER , images TEXT , 
              FOREIGN KEY(tripId) REFERENCES $_tripTable (id) ON DELETE CASCADE)''');
      },
      onConfigure: (Database db) async {
        await db.execute('PRAGMA foreign_keys = ON;');
      },
    );
  }

  ///////////////////////////////////////////////* tripDatabase Oprations*//////////////////////////////////////////

  //////////// adding trips to database///////////
  addTrip(Trips trip) async {
    int tripId = await _database!.rawInsert(
      '''INSERT INTO $_tripTable  
          (  userId,fileImage,destination,startDate,endDate,purpose,transport,budget,notes,assetImgIdx) VALUES(?,?,?,?,?,?,?,?,?,?) ''',
      [
        trip.userId,
        trip.fileImage,
        trip.destination,
        trip.startingDate,
        trip.endingDate,
        trip.purpose,
        trip.transport,
        trip.budget,
        trip.notes,
        trip.assetImgIdx
      ],
    );
    ////////////// adding companions ///////////////
    if (trip.companions != null) {
      addCompanion(trip.companions!, tripId);
    }
    // adding expenses
    final expense = Expenses(
        balance: trip.budget,
        food: 0,
        transport: 0,
        hotel: 0,
        other: 0,
        tripId: tripId,
        totalexpense: 0);
    initExpense(expense);
  }
  //////////// geting the uncompleted trips ///////////////

  Future<List<Trips>> getUpcomingTrips(int userId) async {
    final currentDate = DateTime.now();
    final formatedDate = DateFormat('yyyy-MM-dd').format(currentDate);

    final List<Map<String, dynamic>> mapList = await _database!.query(
        _tripTable,
        where: 'startDate > ? AND userId = ?',
        whereArgs: [formatedDate, userId]);

    final tripList = List.generate(
        mapList.length,
        (index) => Trips(
            id: mapList[index]['id'],
            destination: mapList[index]['destination'],
            startingDate: mapList[index]['startDate'],
            endingDate: mapList[index]['endDate'],
            transport: mapList[index]['transport'],
            purpose: mapList[index]['purpose'],
            budget: mapList[index]['budget'],
            notes: mapList[index]['notes'],
            fileImage: mapList[index]['fileImage'],
            assetImgIdx: mapList[index]['assetImgIdx'],
            userId: userId));
    return tripList;
  }

  ////////////  Geting the completed Trips  /////////////////

  Future<List<Trips>> getCompletedTrips(int userId) async {
    final currentDate = DateTime.now();
    final formatedString = DateFormat('yyyy-MM-dd').format(currentDate);
    List<Map<String, dynamic>> mapList = await _database!.query(_tripTable,
        where: 'endDate < ? AND userId = ?',
        whereArgs: [formatedString, userId]);
    final tripList = List.generate(
        mapList.length,
        (index) => Trips(
            id: mapList[index]['id'],
            destination: mapList[index]['destination'],
            startingDate: mapList[index]['startDate'],
            endingDate: mapList[index]['endDate'],
            transport: mapList[index]['transport'],
            purpose: mapList[index]['purpose'],
            budget: mapList[index]['budget'],
            notes: mapList[index]['notes'],
            fileImage: mapList[index]['fileImage'],
            assetImgIdx: mapList[index]['assetImgIdx'],
            userId: userId));
    return tripList;
  }

////////  Geting ongoing Trip////////

  Future<List<Trips>> getCurrentTrip(int userId) async {
    List<Trips> trips = [];
    final currentDate = DateTime.now();
    final formatedDate = DateFormat('yyyy-MM-dd').format(currentDate);
    //  currentDate.toIso8601String();
    final List<Map<String, dynamic>> mapList = await _database!.query(
        _tripTable,
        where: 'startDate <= ? AND endDate >= ? AND userId=?',
        whereArgs: [formatedDate, formatedDate, userId]);
    trips = List.generate(
        mapList.length,
        (index) => Trips(
            id: mapList[index]['id'],
            destination: mapList[index]['destination'],
            startingDate: mapList[index]['startDate'],
            endingDate: mapList[index]['endDate'],
            transport: mapList[index]['transport'],
            purpose: mapList[index]['purpose'],
            budget: mapList[index]['budget'],
            notes: mapList[index]['notes'],
            fileImage: mapList[index]['fileImage'],
            assetImgIdx: mapList[index]['assetImgIdx'],
            userId: userId));

    return trips;
  }

///////// geting all the Trips  /////////////
  Future<List<Trips>> getUserTrips(int userId) async {
    List<Map<String, dynamic>> mapList = await _database!.query(_tripTable,
        where: 'userId = ?', whereArgs: [userId], orderBy: 'startDate ASC');

    final tripList = List.generate(
        mapList.length,
        (index) => Trips(
            id: mapList[index]['id'],
            destination: mapList[index]['destination'],
            startingDate: mapList[index]['startDate'],
            endingDate: mapList[index]['endDate'],
            transport: mapList[index]['transport'],
            purpose: mapList[index]['purpose'],
            budget: mapList[index]['budget'],
            notes: mapList[index]['notes'],
            fileImage: mapList[index]['fileImage'],
            assetImgIdx: mapList[index]['assetImgIdx'],
            userId: userId));
    return tripList;
  }

  //////////// Date validation //////////////

  isDateAvailable(
      {required String dateToCheck,
      required bool isStart,
      required int userId,
      int? editTripId}) async {
    if (dateToCheck.isEmpty) return;

    final date = DateTime.parse(dateToCheck);
    bool dateAvailable = true;
    final trips = await getUserTrips(userId);
    if (trips.isEmpty) {
      isEndDateAvailable = true;
      isStartDateAvailable = true;
      return;
    }

    for (Trips trip in trips) {
      final startingDate = DateTime.parse(trip.startingDate);
      final endingDate = DateTime.parse(trip.endingDate);

      if (editTripId != null) {
        if (isAtSameDay(date1: date, date2: startingDate)) {
          dateAvailable = true;
          break;
        } else if (isAtSameDay(date1: date, date2: endingDate)) {
          dateAvailable = true;
          break;
        }
      }
      if (isAtSameDay(date1: date, date2: startingDate)) {
        dateAvailable = false;
        break;
      } else if (isAtSameDay(date1: date, date2: endingDate)) {
        dateAvailable = false;
        break;
      } else if (date.isAfter(startingDate) && date.isBefore(endingDate)) {
        dateAvailable = false;
        break;
      }
    }
    isStart
        ? isStartDateAvailable = dateAvailable
        : isEndDateAvailable = dateAvailable;
  }

// checking is there any other trip on the inputed date range//
  tripAvailable(String start, String end, int userId, int? tripId) async {
    if (start.isEmpty || end.isEmpty) return;
    final trips = await DatabaseHelper.instance.getUserTrips(userId);
    if (trips.isEmpty) {
      isTripAvailable = true;
      return;
    }
    bool flag = true;
    final startDate = DateTime.parse(start);
    final endDate = DateTime.parse(end);
    for (Trips trip in trips) {
      final startingDate = DateTime.parse(trip.startingDate);
      final endingDate = DateTime.parse(trip.endingDate);
      if (trip.id != null) {
        if (trip.id == tripId &&
                isAtSameDay(date1: startingDate, date2: endDate) ||
            isAtSameDay(date1: endDate, date2: endingDate)) {
          isTripAvailable = true;
          flag = true;
          break;
        } else if (endDate.isBefore(endingDate)) {
          isTripAvailable = true;
          flag = true;
          break;
        }
      }
      if (isAtSameDay(date1: startingDate, date2: startDate) ||
          isAtSameDay(date1: endingDate, date2: endDate)) {
        flag = false;
        break;
      }
      if (startDate.isBefore(startingDate) && endDate.isAfter(endingDate)) {
        flag = false;
        break;
      }
    }
    isTripAvailable = flag;
    return flag;
  }

  bool isAtSameDay({required DateTime date1, required DateTime date2}) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // isDateAvilable({required isStart}) {
  //   return isStart ? startDateAvailable : endDateAvailable;
  // }

//////////////// Getting a single trip ///////////////////
  Future<Trips> getATrip(int id) async {
    List<Map<String, dynamic>> mapList =
        await _database!.query(_tripTable, where: 'id = ?', whereArgs: [id]);
    final map = mapList.first;
    final trip = Trips(
        destination: map['destination'],
        startingDate: map['startDate'],
        endingDate: map['endDate'],
        transport: map['transport'],
        purpose: map['purpose'],
        budget: map['budget'],
        fileImage: map['fileImage'],
        userId: map['userId'],
        notes: map['notes'],
        assetImgIdx: map['assetImgIdx'],
        id: map['id']);

    return trip;
  }

  //////// /////////// Update Trips (Edit)///////////////////
  updateTrip(Trips trip) async {
    final Map<String, dynamic> row = {
      'destination': trip.destination,
      'startDate': trip.startingDate,
      'endDate': trip.endingDate,
      'transport': trip.transport,
      'purpose': trip.purpose,
      'budget': trip.budget,
      'fileImage': trip.fileImage,
      'assetImgIdx': trip.assetImgIdx
    };
    await _database!
        .update(_tripTable, row, where: 'id = ?', whereArgs: [trip.id]);

    //updating companions in case of new companion or deleting companion
    await _database!
        .delete(_companionTable, where: 'tripId = ?', whereArgs: [trip.id]);
    if (trip.companions != null) {
      addCompanion(trip.companions!, trip.id!);
    }
    // updating expenses incase of budget change
    final expList = await getExpense(trip.id!);
    final exp = expList[0];
    final expense = Expenses(
        balance: trip.budget - exp.totalexpense!,
        food: exp.food,
        transport: exp.transport,
        hotel: exp.hotel,
        other: exp.other,
        tripId: trip.id,
        totalexpense: exp.totalexpense!);
    updateExpense(trip.id!, expense);
  }

  //////////////// delete trips ////////////////
  deleteTrip(Trips trip) async {
    await _database!.delete(_tripTable, where: 'id = ?', whereArgs: [trip.id]);
  }

  ////////// Delete all the trip //////////
  deleteAllTrips(int userId) async {
    await _database!
        .delete(_tripTable, where: 'userId = ?', whereArgs: [userId]);
  }

  ////////// Adding Trip Note/////////
  addNote(Trips trip, String note) async {
    await _database!.update(_tripTable, {'notes': note},
        where: 'id = ?', whereArgs: [trip.id]);
  }

  ///////////////////////////////////* Image Database Functions*////////////////////////////////////////////

  //////////////add Images to Database////////////

  addTripImages({required String imagePath, required int tripId}) async {
    await _database!.rawInsert(
        '''INSERT INTO $_tripImages (tripId , images) VALUES(?,?) ''',
        [tripId, imagePath]);
  }
/////////////Get  Images from database/////////////

  Future<List<Map<String, dynamic>>> getallImages(int tripId) async {
    return await _database!
        .query(_tripImages, where: 'tripId = ?', whereArgs: [tripId]);
  }
/////////////// Delete images from database////////////

  deleteImage(int id) async {
    await _database!.delete(_tripImages, where: 'id = ?', whereArgs: [id]);
  }

  //////////////////////////////* Expense Database Functions*////////////////////////////////////////////////
  ///
  ///
  ///
  //////////// to Store the expense in first time adding //////////
  initExpense(Expenses expense) async {
    await _database!.rawInsert(
        '''INSERT INTO $_tripExpenses (totalexpense,balance,food,transport,hotel,other,tripId) VALUES(?,?,?,?,?,?,?)''',
        [
          expense.totalexpense,
          expense.balance,
          expense.food,
          expense.transport,
          expense.hotel,
          expense.other,
          expense.tripId
        ]);
    balanceNotifire.value = expense.balance ?? 0;
    balanceNotifire.notifyListeners();
  }

////////////////// to add Expenses //////////////////
  addExpences(
      {required String expType,
      required int newExp,
      required int tripId,
      required int oldExp,
      required int balance,
      required int fieldExp}) async {
    final totalExp = oldExp + newExp;

    final totalBal = balance - newExp;
    await _database!.update(_tripExpenses,
        {expType: fieldExp, 'totalexpense': totalExp, 'balance': totalBal},
        where: 'tripId = ?', whereArgs: [tripId]);

    getExpense(tripId);
    // totalExpenses = total;
  }

  /////////// To get all the expenses ////////////////
  Future<List<Expenses>> getExpense(int tripId) async {
    expenseNotifier.value.clear();
    totalExpenses.value = 0;
    balanceNotifire.value = 0;
    List<Map<String, dynamic>> map = await _database!
        .query(_tripExpenses, where: 'tripId = ?', whereArgs: [tripId]);
    expenseNotifier.value.addAll(List.generate(
      map.length,
      (index) => Expenses(
          tripId: map[index]['tripId'] as int,
          food: map[index]['food'] as int,
          hotel: map[index]['hotel'] as int,
          transport: map[index]['transport'] as int,
          other: map[index]['other'] as int,
          totalexpense: map[index]['totalexpense'] as int,
          balance: map[index]['balance'] as int),
    ));
    if (map.isNotEmpty) {
      totalExpenses.value = map[0]['totalexpense'] as int;
      totalExpenses.notifyListeners();
      balanceNotifire.value = map[0]['balance'] as int;
      balanceNotifire.notifyListeners();
    }

    expenseNotifier.notifyListeners();
    return expenseNotifier.value;
  }

  /////////////// To update Expense for edited Trips//////////////
  updateExpense(int tripId, Expenses exp) async {
    Map<String, dynamic> row = {
      'food': exp.food,
      'hotel': exp.hotel,
      'transport': exp.transport,
      'other': exp.other,
      'totalexpense': exp.totalexpense,
      'balance': exp.balance
    };

    final map = await _database!
        .update(_tripExpenses, row, where: 'tripId = ?', whereArgs: [tripId]);
    getExpense(tripId);
    return map;
  }

  ///////////////////////////////* Companion Database Function*/////////////////////////////////////////////

////////////////// add Companion to data base/////////////
  addCompanion(List<PhoneContact> companions, int tripId) {
    final companionList = companions.map((contact) {
      return Companions(
          companion: contact.fullName!,
          phonenumber: contact.phoneNumber!.number.toString(),
          tripId: tripId);
    }).toList();
    for (Companions companion in companionList) {
      _database!.insert(_companionTable, companion.toMap(companion));
    }
  }

/////////////// Get all Companions ////////////////
  Future<List<Companions>> getAllCompanions(int tripId) async {
    List<Companions> compList = [];
    List<Map<String, dynamic>> map = await _database!
        .query(_companionTable, where: 'tripId = ?', whereArgs: [tripId]);
    compList.addAll(
      List.generate(
        map.length,
        (index) => Companions(
          companion: map[index]['companion'],
          phonenumber: map[index]['phonenumber'],
          tripId: map[index]['tripId'],
          id: map[index]['id'],
        ),
      ),
    );
    return compList;
  }

////////////////////////////////* *user database functions*/////////////////////////////////////////////
  ///
  ///
  ///

///////////// add a user to database //////////////
  Future<void> adduser(UserModelClass user) async {
    await _database!.rawInsert(
        'INSERT INTO $_userTable (username,password,imagepath,islogedin,email) VALUES(?,?,?,?,?)',
        [
          user.username,
          user.password,
          user.imagepath,
          user.isLogedin,
          user.email
        ]);
    getLoggeduser();
  }

////////////// getting all users from database//////////////
  Future<void> getalluser() async {
    final values = await _database!.rawQuery('SELECT * FROM $_userTable');
    userList.clear();
    for (var map in values) {
      final user = UserModelClass.frommap(map);
      userList.add(user);
    }
  }

  ///////////////validations//////////////////
  Future<bool> validating(String username, String password) async {
    await getalluser();
    for (UserModelClass user in userList) {
      if (username == user.username && user.password == password) {
        return true;
      }
    }

    return false;
  }

/////////////check if the user name is taken or not////////////
  usernameAvailable(String username) async {
    final db = await openDatabase('database.db');
    final List<Map<String, dynamic>> users = await db
        .query(_userTable, where: 'username = ?', whereArgs: [username]);
    available = users.isEmpty;
  }

  isUsernameAvailable(String username) {
    return available;
  }

///////////user Login updation to database//////////
  Future<UserModelClass> authentication(String username) async {
    final Database db = await openDatabase('database.db');
    await db.update(_userTable, {'islogedin': 1},
        where: 'username = ?', whereArgs: [username]);
    return await getLoggeduser();
  }

//////////////Check if a user is already loged in or not//////////
  checkLogin() async {
    final Database db = await openDatabase('database.db');
    final List<Map<String, dynamic>> results =
        await db.query(_userTable, where: 'islogedin = 1');
    return results.isNotEmpty;
  }

  //////////To get a Loged profile////////////////
  Future<UserModelClass> getLoggeduser() async {
    final Database db = await openDatabase('database.db');
    UserModelClass? logedUser;
    List<Map<String, dynamic>> result = await db.query(
      _userTable,
      where: 'islogedin = 1',
    );
    for (Map map in result) {
      logedUser = UserModelClass.frommap(map);
    }
    user = logedUser;
    return user!;
  }

  Future<Map<String, dynamic>> getLogedProfile() async {
    List<Map<String, dynamic>> map =
        await _database!.query(_userTable, where: 'islogedin = 1');
    return map.first;
  }

///////////// update user details //////////////
  updateUserInfo(String columnName, String data, int id) async {
    await _database!.update(_userTable, {columnName: data},
        where: 'id = ?', whereArgs: [id]);
  }

//////////////Logout user from database//////////////
  Future<void> logoutUser() async {
    final Database db = await openDatabase('database.db');
    await db.update(
      _userTable,
      {'islogedin': 0},
      where: 'islogedin = 1',
    );
  }
}
