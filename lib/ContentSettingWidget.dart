

import 'package:fiction/http/FictionHttp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContentSettingWidget extends StatefulWidget {

  final VoidCallback contentSettingCallback;

  const ContentSettingWidget({Key key, @required this.contentSettingCallback}) : super(key : key);

  @override
  State<StatefulWidget> createState() {
    return ContentSettingWidgetState();
  }
}

class ContentSettingWidgetState extends State<ContentSettingWidget> {

  final TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text('设置',
                      style: TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.none)),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Material(
                    child: TextField(
                      controller: _controller,
                      decoration: new InputDecoration(
                        hintText: "输入章节内容"
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('取消')),
                      FlatButton(
                          onPressed: () {
                            String url = _controller.text.trim();
                            if(null == url || url.isEmpty) {
                              return;
                            }

                            Navigator.of(context).pop();
                            FictionHttp.instance.setDefaultDetailUrl(url);
                            this.widget.contentSettingCallback();
                          },
                          child: Text('确定')),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}