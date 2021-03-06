import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nhkeasynews/models/NewsDetail.dart';
import 'package:nhkeasynews/models/NewsList.dart';
import 'package:scoped_model/scoped_model.dart';

class ConnectedProductsModel extends Model {
  String _newsId = null;
  bool _isLoading = false;
  bool _newsDetailLoading = false;
  List<NewsList> _newsList = [];
  NewsDetail _newsDetail;
  bool _darkMode = false;
}

class NewsListModel extends ConnectedProductsModel {
  // Getter
  List<NewsList> get allNewsList {
    return List.from(_newsList);
  }


  NewsDetail get newsdetail {
    return _newsDetail;
  }

  bool get isLoading {
    return _isLoading;
  }

  bool get newsDetailLoading {
    return _newsDetailLoading;
  }

  Future<dynamic> startGetAllNewsList() {
    _isLoading = true;
    print("It will call");
    return http
        .get("http://70.123.148.33:8080/api/news")
        .then((http.Response response) {
      final List<NewsList> fetchNewsList = [];
      List<dynamic> newslistData = json.decode(response.body);
      if (newslistData == null) {
        return;
      }
      newslistData.forEach((dynamic newsdata) {
        final NewsList newsList = NewsList(
            news_id: newsdata["news_id"],
            title: newsdata["title"],
            title_with_ruby: newsdata["title_with_ruby"],
            news_web_img_uri: newsdata["news_web_image_uri"],
            news_prearranged_time: newsdata["news_prearranged_time"],
            news_web_url: newsdata["news_web_url"],
            news_photo: newsdata["news_img"]);
        fetchNewsList.add(newsList);
      });
      _isLoading = false;
      _newsList = fetchNewsList;
      notifyListeners();
    }).catchError((error) {
      _isLoading = false;
      print(error);
      return;
    });
  }

  /* Get News Detail */
  Future<dynamic> startGetNewsDetail(int index) {
    _newsDetailLoading = true;
    var newsId = allNewsList[index].news_id;
    print(newsId);
    return http
        .get("http://70.123.148.33:8080/api/news/" + newsId)
        .then((http.Response response) {
          print("Get Data");
          print(response.body);
//        return http.get("http://nhk-server.us-east-1.elasticbeanstalk.com/api/news/" + newsId).then((http.Response response) {
      final Map<String, dynamic> newsDetail = json.decode(response.body);
      if (newsDetail == null) {
        return;
      }
      final Map<String, dynamic> newsTitle = newsDetail["title"][0];
      final Map<String, dynamic> publicDate = newsDetail["public_time"][0];
      final List<dynamic> article = newsDetail["article"];
      final NewsDetail nw = new NewsDetail(newsTitle, publicDate, article);
      _newsDetailLoading = false;
      _newsDetail = nw;
      notifyListeners();
    }).catchError((error) {
      _newsDetailLoading = false;
      print(error);
      return;
    });
  }
}

/* Get News Video */
/*BackUp Url: https://www3.nhk.or.jp/news/html/20181019/movie/k10011677101_201810190048_201810190055.html */

/* Get News Audio */
/* BackUp Url:https://www3.nhk.or.jp/news/easy/player/audio.html?id=k10011677101000*/

class DeviceStatus extends ConnectedProductsModel {
  // Getter
  bool get darkMode {
    return _darkMode;
  }

  // setter
  void toggleDarkMode() {
    print(_darkMode);
    _darkMode == false?_darkMode = true:_darkMode = false;
    notifyListeners();
  }
}
