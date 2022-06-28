import 'package:flutter/material.dart';
import 'package:flutter_app2/models/single_movie_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

navigateTo(context, Widget widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

navigateAndFinish(context, Widget widget) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => widget),
    (Route<dynamic> route) => false,
  );
}

/*
  * movieTitle1: [id, year, rating, image]
  * movieTitle2: [id, year, rating, image]
  * */
List<dynamic> sortList(List<dynamic> list, SingleMovieModel itemModel) {
  for (int i = 0; i < list.length; i++) {
    if (itemModel.title.compareTo(list[i]['title']![0]) == -1) {
      list.insert(i, {
        'title': [
          itemModel.title,
          itemModel.id,
          itemModel.year,
          itemModel.rating,
          itemModel.image
        ]
      });
      return list;
    }
  }
  list.add({
    'title': [
      itemModel.title,
      itemModel.id,
      itemModel.year,
      itemModel.rating,
      itemModel.image
    ]
  });
  return list;
}

List<dynamic> binarySearchRemoving(
    List<dynamic> list, int l, int r, String title) {
  if (l > r) return list;
  int mid = ((l + r) / 2).floor();
  if (list[mid]['title']![0] == title) {
    list.remove(list[mid]);
    return list;
  } else if (list[mid]['title']![0].compareTo(title) == -1)
    binarySearchRemoving(list, mid + 1, r, title);
  else
    binarySearchRemoving(list, l, mid - 1, title);
  throw Exception();
}

bool binarySearch(
    List<Map<String, List<String>>> list, int l, int r, String title) {
  if (l > r) return false;
  int mid = ((l + r) / 2).floor();
  if (list[mid]['title']![0] == title) {
    return true;
  } else if (list[mid]['title']![0].compareTo(title) == -1)
    binarySearchRemoving(list, mid + 1, r, title);
  else
    binarySearchRemoving(list, l, mid - 1, title);
  throw Exception();
}

FToast fToast = FToast();

showToast({required context, required String text, required Color color}) {
  fToast.init(context);
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: color,
    ),
    child: Text(text),
  );
  fToast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: Duration(seconds: 2),
  );
}

