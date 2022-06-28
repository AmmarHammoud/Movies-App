class UserModel {
  late String uId;
  late String? userName;
  late String email;
  late String password;

  /*
  * movieTitle1: [id, year, rating, image]
  * movieTitle2: [id, year, rating, image]
  * */
  late List<dynamic> favMovies = [];

  UserModel(
      {required this.uId,
      this.userName,
      required this.email,
      required this.password});

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'userName': userName,
      'email': email,
      'password': password,
      'favMovies': favMovies,
    };
  }

  List<dynamic> fromJson(List<dynamic> list) {
    List<dynamic> l = [];
    /*
    0 {title : []}
    1 {title : []}
    2 {title : []}
    3 {title : []}
     */
    for (int i = 0; i < list.length; i++) l.add(list[i]);
    return l;
  }
}
