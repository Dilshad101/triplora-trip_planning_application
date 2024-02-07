
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