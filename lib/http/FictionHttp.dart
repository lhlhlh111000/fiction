import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fiction/model/Detail.dart';
import 'package:gbk_codec/gbk_codec.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FictionHttp {

  static const String baseUrl = "https://m.booktxt.net";
  static const String contentPath = "$baseUrl/wapbook/9462_3610488_1.html";
  static const String detailPath = "$baseUrl/wapbook/9462_24117306.html";

  static FictionHttp get instance => _getInstance();

  static FictionHttp _instance;

  Dio _dio;

  String _defaultDetailUrl = "${FictionHttp.baseUrl}/wapbook/9462_24117276.html";

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static _getInstance() {
    if(null == _instance) {
      _instance = FictionHttp._internal();
    }

    return _instance;
  }

  FictionHttp._internal() {
    _dio = Dio();
  }

  Future<String> initDefaultDetailUrl() async {
    SharedPreferences prefs = await _prefs;
    String defaultDetailUrl = prefs.getString("nextUrl");
    if(null != defaultDetailUrl) {
      _defaultDetailUrl = defaultDetailUrl;
    }
    return _defaultDetailUrl;
  }

  String getDefaultDetailUrl() {
    return _defaultDetailUrl;
  }

  void setDefaultDetailUrl(String url) {
    _defaultDetailUrl = url;
  }

  Future<String> getContent() async {
    Response<String> response;
    try {
      response = await _dio.get(contentPath, options: Options(responseDecoder: gbkDecoder));
    }on DioError catch (e) {
      print('get请求发生错误：$e');
    }

    return response == null ? "" : response.data.toString();
  }

  Future<Detail> getDetail(String url) async {
    Response response;
    try {
      response = await _dio.get(url, options: Options(responseDecoder: gbkDecoder));
    }on DioError catch (e) {
      print('get请求发生错误：$e');
    }

    return response == null ? null : parseDetailBody(url, response.data.toString());
  }

  String gbkDecoder(List<int> responseBytes, RequestOptions options, ResponseBody responseBody) {
    return gbk_bytes.decode(responseBytes);
  }

  Detail parseDetailBody(String url, String htmlStr) {
    Document document = parse(htmlStr);
    Element element = document.getElementById("chaptercontent");
    if(null != element) {
      String detail = element.text.trim();
      String preUrl = document.getElementById("pb_prev").attributes["href"];
      String nextUrl = document.getElementById("pb_next").attributes["href"];
      _saveDefaultDetailUrl(url);
      return Detail(baseUrl + preUrl, baseUrl + nextUrl, detail);
    }

    return null;
  }

  _saveDefaultDetailUrl(String nextUrl) async {
    if(null == nextUrl || nextUrl.isEmpty) {
      return;
    }

    SharedPreferences prefs = await _prefs;
    prefs.setString("nextUrl", nextUrl);
  }
}