import 'package:fiction/ContentSettingWidget.dart';
import 'package:fiction/dialog/LoadingDialog.dart';
import 'package:fiction/http/FictionHttp.dart';
import 'package:fiction/model/Detail.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Fiction'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Detail _detail;
  ScrollController _controller = ScrollController();

  void _incrementCounter() {
      LoadingDialog.showProgress(context);
      Future<Detail> response = FictionHttp.instance.getDetail(null == _detail
          ? FictionHttp.instance.getDefaultDetailUrl() : _detail.nextUrl);
      response.then((value) => {
        _controller.animateTo(.0,
            duration: Duration(milliseconds: 200),
            curve: Curves.ease),

        setState((){
          _detail = value;
        }),

        LoadingDialog.dismiss(context)
      });
  }

  void _showMenuSetDialog() {
    showDialog(
        context: context,
        builder: (_) => ContentSettingWidget(contentSettingCallback: _contentSettingCallback,),
      );
  }

  void _contentSettingCallback() {
    _detail = null;
    _incrementCounter();
  }

  @override
  void initState() {
    super.initState();
    FictionHttp.instance.initDefaultDetailUrl().then((value) => {_incrementCounter()});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          new IconButton(icon: Icon(Icons.menu), onPressed: _showMenuSetDialog)
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Text(
              null != _detail ? _detail.detail : '',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            padding: EdgeInsets.all(14),
          ),
          controller: _controller,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.skip_next),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
